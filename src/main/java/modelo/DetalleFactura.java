package com.proyectobd.rinconguatemaltecoweb.modelo;

public class DetalleFactura {
    private int idDetalleFactura;
    private int idFactura;
    private int idProducto;
    private String nombreProducto;
    private int cantidad;
    private double precioUnitarioVenta;
    private double subtotalLinea;

    public DetalleFactura() {}

    public DetalleFactura(int idProducto, int cantidad, double precioUnitarioVenta, double subtotalLinea) {
        this.idProducto = idProducto;
        this.cantidad = cantidad;
        this.precioUnitarioVenta = precioUnitarioVenta;
        this.subtotalLinea = subtotalLinea;
    }

    public int getIdDetalleFactura() { return idDetalleFactura; }
    public void setIdDetalleFactura(int idDetalleFactura) { this.idDetalleFactura = idDetalleFactura; }

    public int getIdFactura() { return idFactura; }
    public void setIdFactura(int idFactura) { this.idFactura = idFactura; }

    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }

    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getPrecioUnitarioVenta() { return precioUnitarioVenta; }
    public void setPrecioUnitarioVenta(double precioUnitarioVenta) { this.precioUnitarioVenta = precioUnitarioVenta; }

    public double getSubtotalLinea() { return subtotalLinea; }
    public void setSubtotalLinea(double subtotalLinea) { this.subtotalLinea = subtotalLinea; }
}