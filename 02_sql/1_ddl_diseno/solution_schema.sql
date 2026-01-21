/*
RETO PARTE A: DISEÑO DEL ESQUEMA RELACIONAL (3FN)
Estudiante: [JOSUE PEDRAZA GARCIA]
Fecha: [20/01/2026]

Objetivo:
Normalizar el archivo raw_sales_dump.csv en un modelo relacional
cumpliendo Tercera Forma Normal (3FN), usando llaves primarias y foráneas.
*/

-- =======================================================
-- 0. BASE DE DATOS (opcional si ya existe)
-- =======================================================

CREATE DATABASE RetoSQL;
GO
USE RetoSQL;
GO

-- =======================================================
-- LIMPIEZA (orden correcto por dependencias)
-- =======================================================

IF OBJECT_ID('dbo.Venta', 'U') IS NOT NULL DROP TABLE dbo.Venta;
IF OBJECT_ID('dbo.Cliente', 'U') IS NOT NULL DROP TABLE dbo.Cliente;
IF OBJECT_ID('dbo.Producto', 'U') IS NOT NULL DROP TABLE dbo.Producto;
IF OBJECT_ID('dbo.Sucursal', 'U') IS NOT NULL DROP TABLE dbo.Sucursal;
GO

-- =======================================================
-- 1. TABLAS MAESTRAS
-- =======================================================

-- -----------------------
-- CLIENTE
-- -----------------------
CREATE TABLE Cliente (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(200) NOT NULL,
    Email VARCHAR(200) NOT NULL UNIQUE
);
GO

-- -----------------------
-- PRODUCTO
-- -----------------------
CREATE TABLE Producto (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(200) NOT NULL,
    Categoria VARCHAR(120)
);
GO

-- -----------------------
-- SUCURSAL
-- -----------------------
CREATE TABLE Sucursal (
    SucursalID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(200) NOT NULL,
    Ciudad VARCHAR(120)
);
GO

-- =======================================================
-- 2. TABLA TRANSACCIONAL
-- =======================================================

CREATE TABLE Venta (
    VentaID INT PRIMARY KEY,  -- corresponde a Transaccion_ID del CSV
    Fecha DATE NOT NULL,
    Cantidad INT NOT NULL,
    Precio_Unitario DECIMAL(18,2) NOT NULL,

    ClienteID INT NOT NULL,
    ProductoID INT NOT NULL,
    SucursalID INT NOT NULL,

    CONSTRAINT FK_Venta_Cliente
        FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),

    CONSTRAINT FK_Venta_Producto
        FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID),

    CONSTRAINT FK_Venta_Sucursal
        FOREIGN KEY (SucursalID) REFERENCES Sucursal(SucursalID)
);
GO

-- =======================================================
-- 3. ÍNDICES (mejoran JOINs y performance)
-- =======================================================

CREATE INDEX IX_Venta_ClienteID  ON Venta(ClienteID);
CREATE INDEX IX_Venta_ProductoID ON Venta(ProductoID);
CREATE INDEX IX_Venta_SucursalID ON Venta(SucursalID);
GO