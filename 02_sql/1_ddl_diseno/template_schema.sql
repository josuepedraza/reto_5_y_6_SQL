/*
RETO PARTE A: DISEÑO DEL ESQUEMA RELACIONAL
Estudiante: [Tu Nombre]
Fecha: [Fecha]

```
INSTRUCCIONES:
1.  Crea la base de datos si no existe.
2.  Define las tablas maestras primero (las que no dependen de nadie).
3.  Define las tablas transaccionales al final.

```

*/

-- CREATE DATABASE RetoSQL;
-- GO
-- USE RetoSQL;
-- GO

-- =======================================================
-- 1. TABLAS MAESTRAS (Clientes, Productos, Sucursales)
-- =======================================================

-- PISTA: Usa IDENTITY(1,1) para las llaves primarias.
/*
CREATE TABLE Cliente (
ClienteID INT IDENTITY(1,1) PRIMARY KEY,
Nombre VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE NOT NULL, -- Constraint de unicidad
...
);
*/

-- =======================================================
-- 2. TABLA TRANSACCIONAL (Ventas)
-- =======================================================

/*
CREATE TABLE Venta (
VentaID INT IDENTITY(1,1) PRIMARY KEY,
Fecha DATETIME DEFAULT GETDATE(),

```
-- LLAVES FORÁNEAS (La magia de la relación)
ClienteID INT,
ProductoID INT,

CONSTRAINT FK_Venta_Cliente FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
...

```

);
*/
