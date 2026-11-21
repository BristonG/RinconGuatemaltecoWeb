package com.proyectobd.rinconguatemaltecoweb.modelo;

public class Usuario {
    private int idUsuario;
    private String nombreCompleto;
    private String nombreUsuario;
    private String rol;
    private boolean estado;

    public Usuario() {}

    public Usuario(int idUsuario, String nombreCompleto, String nombreUsuario, String rol, boolean estado) {
        this.idUsuario = idUsuario;
        this.nombreCompleto = nombreCompleto;
        this.nombreUsuario = nombreUsuario;
        this.rol = rol;
        this.estado = estado;
    }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public boolean isEstado() { return estado; }
    public void setEstado(boolean estado) { this.estado = estado; }
}