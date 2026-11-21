package com.proyectobd.rinconguatemaltecoweb.modelo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Factura {
    private int idFactura;
    private String numeroFactura;
    private Date fechaFactura;
    private int idCliente;
    private int idUsuario;
    private int idFormaPago;
    private double totalVenta;
    private double montoRecibido;
    private double cambio;
    private String estado;

    private String nombreCliente;
    private String nitCliente;
    private String nombreCajero;
    private String descripcionFormaPago;
    private List<DetalleFactura> detalles = new ArrayList<>();

    public Factura() {}

    public int getIdFactura() { return idFactura; }
    public void setIdFactura(int idFactura) { this.idFactura = idFactura; }

    public String getNumeroFactura() { return numeroFactura; }
    public void setNumeroFactura(String numeroFactura) { this.numeroFactura = numeroFactura; }

    public Date getFechaFactura() { return fechaFactura; }
    public void setFechaFactura(Date fechaFactura) { this.fechaFactura = fechaFactura; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public int getIdFormaPago() { return idFormaPago; }
    public void setIdFormaPago(int idFormaPago) { this.idFormaPago = idFormaPago; }

    public double getTotalVenta() { return totalVenta; }
    public void setTotalVenta(double totalVenta) { this.totalVenta = totalVenta; }

    public double getMontoRecibido() { return montoRecibido; }
    public void setMontoRecibido(double montoRecibido) { this.montoRecibido = montoRecibido; }

    public double getCambio() { return cambio; }
    public void setCambio(double cambio) { this.cambio = cambio; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }

    public String getNitCliente() { return nitCliente; }
    public void setNitCliente(String nitCliente) { this.nitCliente = nitCliente; }

    public String getNombreCajero() { return nombreCajero; }
    public void setNombreCajero(String nombreCajero) { this.nombreCajero = nombreCajero; }

    public String getDescripcionFormaPago() { return descripcionFormaPago; }
    public void setDescripcionFormaPago(String descripcionFormaPago) { this.descripcionFormaPago = descripcionFormaPago; }

    public List<DetalleFactura> getDetalles() { return detalles; }
    public void setDetalles(List<DetalleFactura> detalles) { this.detalles = detalles; }
}