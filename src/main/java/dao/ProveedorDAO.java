package com.proyectobd.rinconguatemaltecoweb.dao;

import com.proyectobd.rinconguatemaltecoweb.conexion.ConexionBD;
import com.proyectobd.rinconguatemaltecoweb.modelo.Proveedor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProveedorDAO {

    public List<Proveedor> listar() {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT IdProveedor, NIT, NombreProveedor, Contacto, Telefono, Direccion FROM Proveedores ORDER BY IdProveedor DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new Proveedor(
                        rs.getInt("IdProveedor"),
                        rs.getString("NIT"),
                        rs.getString("NombreProveedor"),
                        rs.getString("Contacto"),
                        rs.getString("Telefono"),
                        rs.getString("Direccion")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar proveedores: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public Proveedor obtenerPorId(int id) {
        Proveedor prov = null;
        String sql = "SELECT IdProveedor, NIT, NombreProveedor, Contacto, Telefono, Direccion FROM Proveedores WHERE IdProveedor = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    prov = new Proveedor(
                            rs.getInt("IdProveedor"),
                            rs.getString("NIT"),
                            rs.getString("NombreProveedor"),
                            rs.getString("Contacto"),
                            rs.getString("Telefono"),
                            rs.getString("Direccion")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener proveedor: " + e.getMessage());
            e.printStackTrace();
        }
        return prov;
    }

    public boolean insertar(Proveedor prov) {
        String sql = "INSERT INTO Proveedores (NIT, NombreProveedor, Contacto, Telefono, Direccion) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, prov.getNit() != null && !prov.getNit().trim().isEmpty() ? prov.getNit() : null);
            ps.setString(2, prov.getNombreProveedor());
            ps.setString(3, prov.getContacto());
            ps.setString(4, prov.getTelefono());
            ps.setString(5, prov.getDireccion());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar proveedor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizar(Proveedor prov) {
        String sql = "UPDATE Proveedores SET NIT = ?, NombreProveedor = ?, Contacto = ?, Telefono = ?, Direccion = ? WHERE IdProveedor = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, prov.getNit() != null && !prov.getNit().trim().isEmpty() ? prov.getNit() : null);
            ps.setString(2, prov.getNombreProveedor());
            ps.setString(3, prov.getContacto());
            ps.setString(4, prov.getTelefono());
            ps.setString(5, prov.getDireccion());
            ps.setInt(6, prov.getIdProveedor());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar proveedor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM Proveedores WHERE IdProveedor = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar proveedor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}