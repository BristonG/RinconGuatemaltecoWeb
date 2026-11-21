CREATE DATABASE RinconGuatemalteco;
GO
USE RinconGuatemalteco;
GO

CREATE TABLE Usuarios (
    IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
    NombreCompleto NVARCHAR(150) NOT NULL,
    NombreUsuario NVARCHAR(50) NOT NULL UNIQUE,
    ClaveAcceso NVARCHAR(255) NOT NULL,
    Rol NVARCHAR(50) NOT NULL,
    Estado BIT NOT NULL DEFAULT 1
);

CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoria NVARCHAR(100) NOT NULL UNIQUE,
    Descripcion NVARCHAR(255) NULL
);

CREATE TABLE Proveedores (
    IdProveedor INT IDENTITY(1,1) PRIMARY KEY,
    NIT NVARCHAR(20) NULL,
    NombreProveedor NVARCHAR(150) NOT NULL,
    Contacto NVARCHAR(100) NULL,
    Telefono NVARCHAR(20) NULL,
    Direccion NVARCHAR(200) NULL
);

CREATE TABLE Clientes (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    NIT NVARCHAR(20) NOT NULL,
    Nombres NVARCHAR(100) NOT NULL,
    Apellidos NVARCHAR(100) NOT NULL,
    Direccion NVARCHAR(200) NULL,
    Telefono NVARCHAR(20) NULL,
    CorreoElectronico NVARCHAR(100) NULL
);

CREATE TABLE FormasPago (
    IdFormaPago INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Productos (
    IdProducto INT IDENTITY(1,1) PRIMARY KEY,
    IdCategoria INT NOT NULL,
    CodigoBarras NVARCHAR(50) NULL,
    NombreProducto NVARCHAR(150) NOT NULL,
    Descripcion NVARCHAR(255) NULL,
    PrecioCosto DECIMAL(10,2) NOT NULL,
    PrecioVenta DECIMAL(10,2) NOT NULL,
    StockActual INT NOT NULL DEFAULT 0,
    StockMinimo INT NOT NULL DEFAULT 5,
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria)
);

CREATE TABLE Compras (
    IdCompra INT IDENTITY(1,1) PRIMARY KEY,
    IdProveedor INT NOT NULL,
    IdUsuario INT NOT NULL,
    NumeroFacturaProveedor NVARCHAR(50) NULL,
    FechaCompra DATETIME NOT NULL DEFAULT GETDATE(),
    TotalCompra DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Compras_Proveedores FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IdProveedor),
    CONSTRAINT FK_Compras_Usuarios FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario)
);

CREATE TABLE DetalleCompras (
    IdDetalleCompra INT IDENTITY(1,1) PRIMARY KEY,
    IdCompra INT NOT NULL,
    IdProducto INT NOT NULL,
    CantidadComprada INT NOT NULL,
    PrecioUnitarioCompra DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetalleCompras_Compras FOREIGN KEY (IdCompra) REFERENCES Compras(IdCompra),
    CONSTRAINT FK_DetalleCompras_Productos FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);

CREATE TABLE Facturas (
    IdFactura INT IDENTITY(1,1) PRIMARY KEY,
    NumeroFactura NVARCHAR(50) NOT NULL UNIQUE,
    FechaFactura DATETIME NOT NULL DEFAULT GETDATE(),
    IdCliente INT NOT NULL,
    IdUsuario INT NOT NULL,
    IdFormaPago INT NOT NULL,
    TotalVenta DECIMAL(10,2) NOT NULL,
    MontoRecibido DECIMAL(10,2) NULL,
    Cambio DECIMAL(10,2) NULL,
    Estado NVARCHAR(20) NOT NULL DEFAULT 'Emitida',
    CONSTRAINT FK_Facturas_Clientes FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente),
    CONSTRAINT FK_Facturas_Usuarios FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario),
    CONSTRAINT FK_Facturas_FormasPago FOREIGN KEY (IdFormaPago) REFERENCES FormasPago(IdFormaPago)
);

CREATE TABLE DetalleFactura (
    IdDetalleFactura INT IDENTITY(1,1) PRIMARY KEY,
    IdFactura INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitarioVenta DECIMAL(10,2) NOT NULL,
    SubtotalLinea DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetalleFactura_Facturas FOREIGN KEY (IdFactura) REFERENCES Facturas(IdFactura),
    CONSTRAINT FK_DetalleFactura_Productos FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);

CREATE TABLE Devoluciones (
    IdDevolucion INT IDENTITY(1,1) PRIMARY KEY,
    IdFactura INT NULL,
    IdProducto INT NOT NULL,
    IdUsuario INT NOT NULL,
    FechaDevolucion DATETIME NOT NULL DEFAULT GETDATE(),
    CantidadDevuelta INT NOT NULL,
    Motivo NVARCHAR(50) NOT NULL,
    MontoReembolsado DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Observaciones NVARCHAR(255) NULL,
    CONSTRAINT CK_Devoluciones_Motivo CHECK (Motivo IN ('Producto Dañado', 'Vencimiento')),
    CONSTRAINT FK_Devoluciones_Facturas FOREIGN KEY (IdFactura) REFERENCES Facturas(IdFactura),
    CONSTRAINT FK_Devoluciones_Productos FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto),
    CONSTRAINT FK_Devoluciones_Usuarios FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario)
);
GO