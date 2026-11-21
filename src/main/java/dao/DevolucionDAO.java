package com.proyectobd.rinconguatemaltecoweb.dao;

import com.proyectobd.rinconguatemaltecoweb.conexion.ConexionBD;
import com.proyectobd.rinconguatemaltecoweb.modelo.Devolucion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class DevolucionDAO {

    public List<Devolucion> listarTodas() {
        List<Devolucion> lista = new ArrayList<>();
        String sql = "SELECT d.IdDevolucion, d.IdFactura, f.NumeroFactura, d.IdProducto, p.NombreProducto, " +
                "d.IdUsuario, u.NombreCompleto AS NombreUsuario, d.FechaDevolucion, " +
                "d.CantidadDevuelta, d.Motivo, d.MontoReembolsado, d.Observaciones " +
                "FROM Devoluciones d " +
                "LEFT JOIN Facturas f ON d.IdFactura = f.IdFactura " +
                "INNER JOIN Productos p ON d.IdProducto = p.IdProducto " +
                "INNER JOIN Usuarios u ON d.IdUsuario = u.IdUsuario " +
                "ORDER BY d.IdDevolucion DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Devolucion dev = new Devolucion();
                dev.setIdDevolucion(rs.getInt("IdDevolucion"));

                int idF = rs.getInt("IdFactura");
                dev.setIdFactura(rs.wasNull() ? null : idF);
                dev.setNumeroFactura(rs.getString("NumeroFactura"));

                dev.setIdProducto(rs.getInt("IdProducto"));
                dev.setNombreProducto(rs.getString("NombreProducto"));
                dev.setIdUsuario(rs.getInt("IdUsuario"));
                dev.setNombreUsuario(rs.getString("NombreUsuario"));
                dev.setFechaDevolucion(rs.getTimestamp("FechaDevolucion"));
                dev.setCantidadDevuelta(rs.getInt("CantidadDevuelta"));
                dev.setMotivo(rs.getString("Motivo"));
                dev.setMontoReembolsado(rs.getDouble("MontoReembolsado"));
                dev.setObservaciones(rs.getString("Observaciones"));

                lista.add(dev);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar devoluciones: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public boolean insertar(Devolucion dev) {
        String sql = "INSERT INTO Devoluciones (IdFactura, IdProducto, IdUsuario, FechaDevolucion, CantidadDevuelta, Motivo, MontoReembolsado, Observaciones) " +
                "VALUES (?, ?, ?, GETDATE(), ?, ?, ?, ?)";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (dev.getIdFactura() != null && dev.getIdFactura() > 0) {
                ps.setInt(1, dev.getIdFactura());
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            ps.setInt(2, dev.getIdProducto());
            ps.setInt(3, dev.getIdUsuario());
            ps.setInt(4, dev.getCantidadDevuelta());
            ps.setString(5, dev.getMotivo());
            ps.setDouble(6, dev.getMontoReembolsado());
            ps.setString(7, dev.getObservaciones() != null && !dev.getObservaciones().trim().isEmpty() ? dev.getObservaciones() : null);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar devolucion: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}