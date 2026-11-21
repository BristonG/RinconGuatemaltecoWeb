package com.proyectobd.rinconguatemaltecoweb.modelo;

public class DetalleCompra {
    private int idDetalleCompra;
    private int idCompra;
    private int idProducto;
    private String nombreProducto;
    private int cantidadComprada;
    private double precioUnitarioCompra;
    private double subtotal;
    private double precioVenta;

    public DetalleCompra() {}

    public DetalleCompra(int idProducto, int cantidadComprada, double precioUnitarioCompra, double subtotal, double precioVenta) {
        this.idProducto = idProducto;
        this.cantidadComprada = cantidadComprada;
        this.precioUnitarioCompra = precioUnitarioCompra;
        this.subtotal = subtotal;
        this.precioVenta = precioVenta;
    }

    public DetalleCompra(int idProducto, int cantidadComprada, double precioUnitarioCompra, double subtotal) {
        this.idProducto = idProducto;
        this.cantidadComprada = cantidadComprada;
        this.precioUnitarioCompra = precioUnitarioCompra;
        this.subtotal = subtotal;
    }

    public int getIdDetalleCompra() { return idDetalleCompra; }
    public void setIdDetalleCompra(int idDetalleCompra) { this.idDetalleCompra = idDetalleCompra; }

    public int getIdCompra() { return idCompra; }
    public void setIdCompra(int idCompra) { this.idCompra = idCompra; }

    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }

    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }

    public int getCantidadComprada() { return cantidadComprada; }
    public void setCantidadComprada(int cantidadComprada) { this.cantidadComprada = cantidadComprada; }

    public double getPrecioUnitarioCompra() { return precioUnitarioCompra; }
    public void setPrecioUnitarioCompra(double precioUnitarioCompra) { this.precioUnitarioCompra = precioUnitarioCompra; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(double precioVenta) { this.precioVenta = precioVenta; }
}