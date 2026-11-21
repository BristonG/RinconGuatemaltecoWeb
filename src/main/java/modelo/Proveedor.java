package com.proyectobd.rinconguatemaltecoweb.modelo;

public class Proveedor {
    private int idProveedor;
    private String nit;
    private String nombreProveedor;
    private String contacto;
    private String telefono;
    private String direccion;

    public Proveedor() {}

    public Proveedor(int idProveedor, String nit, String nombreProveedor, String contacto, String telefono, String direccion) {
        this.idProveedor = idProveedor;
        this.nit = nit;
        this.nombreProveedor = nombreProveedor;
        this.contacto = contacto;
        this.telefono = telefono;
        this.direccion = direccion;
    }

    public int getIdProveedor() { return idProveedor; }
    public void setIdProveedor(int idProveedor) { this.idProveedor = idProveedor; }

    public String getNit() { return nit; }
    public void setNit(String nit) { this.nit = nit; }

    public String getNombreProveedor() { return nombreProveedor; }
    public void setNombreProveedor(String nombreProveedor) { this.nombreProveedor = nombreProveedor; }

    public String getContacto() { return contacto; }
    public void setContacto(String contacto) { this.contacto = contacto; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
}