package com.proyectobd.rinconguatemaltecoweb.modelo;

import java.util.Date;

public class Devolucion {
    private int idDevolucion;
    private Integer idFactura;
    private String numeroFactura;
    private int idProducto;
    private String nombreProducto;
    private int idUsuario;
    private String nombreUsuario;
    private Date fechaDevolucion;
    private int cantidadDevuelta;
    private String motivo;
    private double montoReembolsado;
    private String observaciones;

    public Devolucion() {}

    public int getIdDevolucion() { return idDevolucion; }
    public void setIdDevolucion(int idDevolucion) { this.idDevolucion = idDevolucion; }

    public Integer getIdFactura() { return idFactura; }
    public void setIdFactura(Integer idFactura) { this.idFactura = idFactura; }

    public String getNumeroFactura() { return numeroFactura; }
    public void setNumeroFactura(String numeroFactura) { this.numeroFactura = numeroFactura; }

    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }

    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }

    public Date getFechaDevolucion() { return fechaDevolucion; }
    public void setFechaDevolucion(Date fechaDevolucion) { this.fechaDevolucion = fechaDevolucion; }

    public int getCantidadDevuelta() { return cantidadDevuelta; }
    public void setCantidadDevuelta(int cantidadDevuelta) { this.cantidadDevuelta = cantidadDevuelta; }

    public String getMotivo() { return motivo; }
    public void setMotivo(String motivo) { this.motivo = motivo; }

    public double getMontoReembolsado() { return montoReembolsado; }
    public void setMontoReembolsado(double montoReembolsado) { this.montoReembolsado = montoReembolsado; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}