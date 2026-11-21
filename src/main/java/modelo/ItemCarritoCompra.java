package com.proyectobd.rinconguatemaltecoweb.modelo;

public class ItemCarritoCompra {
    private int idProducto;
    private String nombreProducto;
    private double costoUnitario;
    private double precioVenta;
    private int cantidad;

    public ItemCarritoCompra() {}

    public ItemCarritoCompra(int idProducto, String nombreProducto, double costoUnitario, double precioVenta, int cantidad) {
        this.idProducto = idProducto;
        this.nombreProducto = nombreProducto;
        this.costoUnitario = costoUnitario;
        this.precioVenta = precioVenta;
        this.cantidad = cantidad;
    }

    public ItemCarritoCompra(int idProducto, String nombreProducto, double costoUnitario, int cantidad) {
        this.idProducto = idProducto;
        this.nombreProducto = nombreProducto;
        this.costoUnitario = costoUnitario;
        this.cantidad = cantidad;
    }

    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }

    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }

    public double getCostoUnitario() { return costoUnitario; }
    public void setCostoUnitario(double costoUnitario) { this.costoUnitario = costoUnitario; }

    public double getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(double precioVenta) { this.precioVenta = precioVenta; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getSubtotal() { return this.costoUnitario * this.cantidad; }
}