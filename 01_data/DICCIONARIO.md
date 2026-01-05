
# Diccionario de Datos Originales

| Campo | Descripción | Problema a Resolver |
| --- | --- | --- |
| `Cliente_Nombre` | Nombre del comprador | Aparece en mayúsculas y minúsculas. Normalizar. |
| `Cliente_Email` | Identificador único lógico | Se repite en cada compra. Mover a tabla Clientes. |
| `Producto` | Nombre del item | Texto repetido. Mover a tabla Productos. |
| `Categoria` | Clasificación | Depende del producto. Evaluar si requiere tabla propia. |
| `Sucursal` | Nombre de la tienda | Texto repetido. Mover a tabla Sucursales. |
| `Ciudad_Sucursal` | Ubicación | Dependencia transitiva de Sucursal. |
