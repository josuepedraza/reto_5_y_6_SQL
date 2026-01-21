import pandas as pd
import pyodbc

# Ajusta si tu contraseña es distinta
SERVER = "localhost,1433"
DB = "RetoSQL"
USER = "sa"
PASS = "TuPasswordFuerte123!"

CSV_PATH = "01_data/raw/raw_sales_dump.csv"

conn_str = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={SERVER};"
    f"DATABASE={DB};"
    f"UID={USER};"
    f"PWD={PASS};"
    "TrustServerCertificate=yes;"
    "Encrypt=no;"
)

df = pd.read_csv(CSV_PATH)
df["Fecha_Venta"] = pd.to_datetime(df["Fecha_Venta"]).dt.date

with pyodbc.connect(conn_str, autocommit=True) as conn:
    cur = conn.cursor()

    # Limpia datos (para repetir sin errores)
    cur.execute("DELETE FROM dbo.Venta;")
    cur.execute("DELETE FROM dbo.Cliente;")
    cur.execute("DELETE FROM dbo.Producto;")
    cur.execute("DELETE FROM dbo.Sucursal;")

    # Insertar dimensiones sin duplicados
    # Para clientes, deduplicar por Email (llave única en BD)
    clientes = df[["Cliente_Nombre","Cliente_Email"]].drop_duplicates(subset=["Cliente_Email"], keep="first")
    productos = df[["Producto","Categoria"]].drop_duplicates()
    sucursales = df[["Sucursal","Ciudad_Sucursal"]].drop_duplicates()

    cur.fast_executemany = True
    cur.executemany(
        "INSERT INTO dbo.Cliente (Nombre, Email) VALUES (?, ?);",
        list(clientes.itertuples(index=False, name=None))
    )
    cur.executemany(
        "INSERT INTO dbo.Producto (Nombre, Categoria) VALUES (?, ?);",
        list(productos.itertuples(index=False, name=None))
    )
    cur.executemany(
        "INSERT INTO dbo.Sucursal (Nombre, Ciudad) VALUES (?, ?);",
        list(sucursales.itertuples(index=False, name=None))
    )

    # Mapear IDs
    cliente_map = {row.Email: row.ClienteID for row in cur.execute("SELECT ClienteID, Email FROM dbo.Cliente;").fetchall()}
    producto_map = {row.Nombre: row.ProductoID for row in cur.execute("SELECT ProductoID, Nombre FROM dbo.Producto;").fetchall()}
    sucursal_map = {row.Nombre: row.SucursalID for row in cur.execute("SELECT SucursalID, Nombre FROM dbo.Sucursal;").fetchall()}

    ventas = []
    for r in df.itertuples(index=False):
        ventas.append((
            int(r.Transaccion_ID),
            r.Fecha_Venta,
            int(r.Cantidad),
            float(r.Precio_Unitario),
            int(cliente_map[r.Cliente_Email]),
            int(producto_map[r.Producto]),
            int(sucursal_map[r.Sucursal]),
        ))

    cur.executemany(
        """
        INSERT INTO dbo.Venta (VentaID, Fecha, Cantidad, Precio_Unitario, ClienteID, ProductoID, SucursalID)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """,
        ventas
    )

print("Carga completada.")
