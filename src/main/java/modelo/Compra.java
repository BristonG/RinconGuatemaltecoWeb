package com.proyectobd.rinconguatemaltecoweb.modelo;
import com.proyectobd.rinconguatemaltecoweb.modelo.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Compra {
    private int idCompra;
    private int idProveedor;
    private int idUsuario;
    private String numeroFacturaProveedor;
    private Date fechaCompra;
    private double totalCompra;

    // Campos auxiliares para vistas
    private String nombreProveedor;
    private String nombreUsuario;
    private List<DetalleCompra> detalles = new ArrayList<>();

    public Compra() {}

    public int getIdCompra() { return idCompra; }
    public void setIdCompra(int idCompra) { this.idCompra = idCompra; }

    public int getIdProveedor() { return idProveedor; }
    public void setIdProveedor(int idProveedor) { this.idProveedor = idProveedor; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNumeroFacturaProveedor() { return numeroFacturaProveedor; }
    public void setNumeroFacturaProveedor(String numeroFacturaProveedor) { this.numeroFacturaProveedor = numeroFacturaProveedor; }

    public Date getFechaCompra() { return fechaCompra; }
    public void setFechaCompra(Date fechaCompra) { this.fechaCompra = fechaCompra; }

    public double getTotalCompra() { return totalCompra; }
    public void setTotalCompra(double totalCompra) { this.totalCompra = totalCompra; }

    public String getNombreProveedor() { return nombreProveedor; }
    public void setNombreProveedor(String nombreProveedor) { this.nombreProveedor = nombreProveedor; }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }

    public List<DetalleCompra> getDetalles() { return detalles; }
    public void setDetalles(List<DetalleCompra> detalles) { this.detalles = detalles; }
}