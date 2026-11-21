package com.proyectobd.rinconguatemaltecoweb.dao;

import com.proyectobd.rinconguatemaltecoweb.conexion.ConexionBD;
import com.proyectobd.rinconguatemaltecoweb.modelo.FormaPago;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FormaPagoDAO {

    public List<FormaPago> listar() {
        List<FormaPago> lista = new ArrayList<>();
        String sql = "SELECT IdFormaPago, Descripcion FROM FormasPago ORDER BY IdFormaPago ASC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new FormaPago(
                        rs.getInt("IdFormaPago"),
                        rs.getString("Descripcion")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar formas de pago: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
}