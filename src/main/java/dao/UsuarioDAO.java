package com.proyectobd.rinconguatemaltecoweb.dao;

import com.proyectobd.rinconguatemaltecoweb.conexion.ConexionBD;
import com.proyectobd.rinconguatemaltecoweb.modelo.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    public Usuario validarLogin(String usuario, String clave) {
        Usuario usuarioEncontrado = null;
        String sql = "SELECT IdUsuario, NombreCompleto, NombreUsuario, Rol, Estado " +
                "FROM Usuarios " +
                "WHERE NombreUsuario = ? AND ClaveAcceso = ? AND Estado = 1";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.trim());
            ps.setString(2, clave.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuarioEncontrado = new Usuario(
                            rs.getInt("IdUsuario"),
                            rs.getString("NombreCompleto"),
                            rs.getString("NombreUsuario"),
                            rs.getString("Rol"),
                            rs.getBoolean("Estado")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al autenticar usuario en BD: " + e.getMessage());
            e.printStackTrace();
        }

        return usuarioEncontrado;
    }
}