package com.proyectobd.rinconguatemaltecoweb.modelo;

public class Producto {
    private int idProducto;
    private int idCategoria;
    private String nombreCategoria;
    private String codigoBarras;
    private String nombreProducto;
    private String descripcion;
    private double precioCosto;
    private double precioVenta;
    private int stockActual;
    private int stockMinimo;
    private boolean estado;

    public Producto() {
        this.stockMinimo = 5;
        this.estado = true;
    }

    public Producto(int idProducto, int idCategoria, String nombreCategoria, String codigoBarras,
                    String nombreProducto, String descripcion, double precioCosto, double precioVenta,
                    int stockActual, int stockMinimo, boolean estado) {
        this.idProducto = idProducto;
        this.idCategoria = idCategoria;
        this.nombreCategoria = nombreCategoria;
        this.codigoBarras = codigoBarras;
        this.nombreProducto = nombreProducto;
        this.descripcion = descripcion;
        this.precioCosto = precioCosto;
        this.precioVenta = precioVenta;
        this.stockActual = stockActual;
        this.stockMinimo = stockMinimo;
        this.estado = estado;
    }

    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }

    public int getIdCategoria() { return idCategoria; }
    public void setIdCategoria(int idCategoria) { this.idCategoria = idCategoria; }

    public String getNombreCategoria() { return nombreCategoria; }
    public void setNombreCategoria(String nombreCategoria) { this.nombreCategoria = nombreCategoria; }

    public String getCodigoBarras() { return codigoBarras; }
    public void setCodigoBarras(String codigoBarras) { this.codigoBarras = codigoBarras; }

    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public double getPrecioCosto() { return precioCosto; }
    public void setPrecioCosto(double precioCosto) { this.precioCosto = precioCosto; }

    public double getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(double precioVenta) { this.precioVenta = precioVenta; }

    public int getStockActual() { return stockActual; }
    public void setStockActual(int stockActual) { this.stockActual = stockActual; }

    public int getStockMinimo() { return stockMinimo; }
    public void setStockMinimo(int stockMinimo) { this.stockMinimo = stockMinimo; }

    public boolean isEstado() { return estado; }
    public void setEstado(boolean estado) { this.estado = estado; }
}