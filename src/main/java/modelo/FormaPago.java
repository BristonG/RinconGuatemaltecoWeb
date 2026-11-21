package com.proyectobd.rinconguatemaltecoweb.modelo;

public class FormaPago {
    private int idFormaPago;
    private String descripcion;

    public FormaPago() {}

    public FormaPago(int idFormaPago, String descripcion) {
        this.idFormaPago = idFormaPago;
        this.descripcion = descripcion;
    }

    public int getIdFormaPago() { return idFormaPago; }
    public void setIdFormaPago(int idFormaPago) { this.idFormaPago = idFormaPago; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}