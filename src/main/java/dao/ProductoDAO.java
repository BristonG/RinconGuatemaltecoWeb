package com.proyectobd.rinconguatemaltecoweb.dao;

import com.proyectobd.rinconguatemaltecoweb.conexion.ConexionBD;
import com.proyectobd.rinconguatemaltecoweb.modelo.Producto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public List<Producto> listar() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.IdProducto, p.IdCategoria, c.NombreCategoria, p.CodigoBarras, " +
                "p.NombreProducto, p.Descripcion, p.PrecioCosto, p.PrecioVenta, " +
                "p.StockActual, p.StockMinimo, p.Estado " +
                "FROM Productos p " +
                "INNER JOIN Categorias c ON p.IdCategoria = c.IdCategoria " +
                "WHERE p.Estado = 1 " +
                "ORDER BY p.IdProducto DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new Producto(
                        rs.getInt("IdProducto"),
                        rs.getInt("IdCategoria"),
                        rs.getString("NombreCategoria"),
                        rs.getString("CodigoBarras"),
                        rs.getString("NombreProducto"),
                        rs.getString("Descripcion"),
                        rs.getDouble("PrecioCosto"),
                        rs.getDouble("PrecioVenta"),
                        rs.getInt("StockActual"),
                        rs.getInt("StockMinimo"),
                        rs.getBoolean("Estado")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar productos: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public Producto obtenerPorId(int id) {
        Producto prod = null;
        String sql = "SELECT p.IdProducto, p.IdCategoria, c.NombreCategoria, p.CodigoBarras, " +
                "p.NombreProducto, p.Descripcion, p.PrecioCosto, p.PrecioVenta, " +
                "p.StockActual, p.StockMinimo, p.Estado " +
                "FROM Productos p " +
                "INNER JOIN Categorias c ON p.IdCategoria = c.IdCategoria " +
                "WHERE p.IdProducto = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    prod = new Producto(
                            rs.getInt("IdProducto"),
                            rs.getInt("IdCategoria"),
                            rs.getString("NombreCategoria"),
                            rs.getString("CodigoBarras"),
                            rs.getString("NombreProducto"),
                            rs.getString("Descripcion"),
                            rs.getDouble("PrecioCosto"),
                            rs.getDouble("PrecioVenta"),
                            rs.getInt("StockActual"),
                            rs.getInt("StockMinimo"),
                            rs.getBoolean("Estado")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar producto por ID: " + e.getMessage());
            e.printStackTrace();
        }
        return prod;
    }

    public boolean insertar(Producto prod) {
        String sql = "INSERT INTO Productos (IdCategoria, CodigoBarras, NombreProducto, Descripcion, " +
                "PrecioCosto, PrecioVenta, StockActual, StockMinimo, Estado) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, prod.getIdCategoria());
            ps.setString(2, prod.getCodigoBarras() != null && !prod.getCodigoBarras().trim().isEmpty() ? prod.getCodigoBarras() : null);
            ps.setString(3, prod.getNombreProducto());
            ps.setString(4, prod.getDescripcion());
            ps.setDouble(5, prod.getPrecioCosto());
            ps.setDouble(6, prod.getPrecioVenta());
            ps.setInt(7, prod.getStockActual());
            ps.setInt(8, prod.getStockMinimo() > 0 ? prod.getStockMinimo() : 5);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar producto: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizar(Producto prod) {
        String sql = "UPDATE Productos SET IdCategoria = ?, CodigoBarras = ?, NombreProducto = ?, " +
                "Descripcion = ?, PrecioCosto = ?, PrecioVenta = ?, StockActual = ?, StockMinimo = ? " +
                "WHERE IdProducto = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, prod.getIdCategoria());
            ps.setString(2, prod.getCodigoBarras() != null && !prod.getCodigoBarras().trim().isEmpty() ? prod.getCodigoBarras() : null);
            ps.setString(3, prod.getNombreProducto());
            ps.setString(4, prod.getDescripcion());
            ps.setDouble(5, prod.getPrecioCosto());
            ps.setDouble(6, prod.getPrecioVenta());
            ps.setInt(7, prod.getStockActual());
            ps.setInt(8, prod.getStockMinimo());
            ps.setInt(9, prod.getIdProducto());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar producto: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "UPDATE Productos SET Estado = 0 WHERE IdProducto = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al desactivar producto: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}