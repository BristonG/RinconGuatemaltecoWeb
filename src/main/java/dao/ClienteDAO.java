package com.proyectobd.rinconguatemaltecoweb.dao;

import com.proyectobd.rinconguatemaltecoweb.conexion.ConexionBD;
import com.proyectobd.rinconguatemaltecoweb.modelo.Cliente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    public List<Cliente> listar() {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT IdCliente, NIT, Nombres, Apellidos, Direccion, Telefono, CorreoElectronico FROM Clientes ORDER BY IdCliente DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new Cliente(
                        rs.getInt("IdCliente"),
                        rs.getString("NIT"),
                        rs.getString("Nombres"),
                        rs.getString("Apellidos"),
                        rs.getString("Direccion"),
                        rs.getString("Telefono"),
                        rs.getString("CorreoElectronico")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public Cliente obtenerPorId(int id) {
        Cliente cliente = null;
        String sql = "SELECT IdCliente, NIT, Nombres, Apellidos, Direccion, Telefono, CorreoElectronico FROM Clientes WHERE IdCliente = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente(
                            rs.getInt("IdCliente"),
                            rs.getString("NIT"),
                            rs.getString("Nombres"),
                            rs.getString("Apellidos"),
                            rs.getString("Direccion"),
                            rs.getString("Telefono"),
                            rs.getString("CorreoElectronico")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cliente: " + e.getMessage());
            e.printStackTrace();
        }
        return cliente;
    }

    public boolean insertar(Cliente c) {
        String sql = "INSERT INTO Clientes (NIT, Nombres, Apellidos, Direccion, Telefono, CorreoElectronico) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getNit());
            ps.setString(2, c.getNombres());
            ps.setString(3, c.getApellidos());
            ps.setString(4, c.getDireccion());
            ps.setString(5, c.getTelefono());
            ps.setString(6, c.getCorreoElectronico());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar cliente: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizar(Cliente c) {
        String sql = "UPDATE Clientes SET NIT = ?, Nombres = ?, Apellidos = ?, Direccion = ?, Telefono = ?, CorreoElectronico = ? WHERE IdCliente = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getNit());
            ps.setString(2, c.getNombres());
            ps.setString(3, c.getApellidos());
            ps.setString(4, c.getDireccion());
            ps.setString(5, c.getTelefono());
            ps.setString(6, c.getCorreoElectronico());
            ps.setInt(7, c.getIdCliente());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar cliente: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM Clientes WHERE IdCliente = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar cliente (posiblemente tiene facturas emitidas): " + e.getMessage());
            return false;
        }
    }
}