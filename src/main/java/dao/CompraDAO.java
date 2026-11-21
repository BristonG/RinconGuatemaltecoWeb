package com.proyectobd.rinconguatemaltecoweb.dao;

import com.proyectobd.rinconguatemaltecoweb.conexion.ConexionBD;
import com.proyectobd.rinconguatemaltecoweb.modelo.Compra;
import com.proyectobd.rinconguatemaltecoweb.modelo.DetalleCompra;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CompraDAO {

    public boolean registrarCompra(Compra compra) throws SQLException {
        String sqlCompra = "INSERT INTO Compras (IdProveedor, IdUsuario, NumeroFacturaProveedor, FechaCompra, TotalCompra) " +
                "VALUES (?, ?, ?, GETDATE(), ?)";
        String sqlDetalle = "INSERT INTO DetalleCompras (IdCompra, IdProducto, CantidadComprada, PrecioUnitarioCompra, Subtotal) " +
                "VALUES (?, ?, ?, ?, ?)";
        String sqlAumentarStock = "UPDATE Productos SET StockActual = StockActual + ?, PrecioCosto = ?, PrecioVenta = ? WHERE IdProducto = ?";

        Connection con = null;
        try {
            con = ConexionBD.obtenerConexion();
            con.setAutoCommit(false);

            int idCompraGenerada = 0;
            try (PreparedStatement psCompra = con.prepareStatement(sqlCompra, Statement.RETURN_GENERATED_KEYS)) {
                psCompra.setInt(1, compra.getIdProveedor());
                psCompra.setInt(2, compra.getIdUsuario());
                psCompra.setString(3, compra.getNumeroFacturaProveedor() != null && !compra.getNumeroFacturaProveedor().trim().isEmpty()
                        ? compra.getNumeroFacturaProveedor() : null);
                psCompra.setDouble(4, compra.getTotalCompra());
                psCompra.executeUpdate();

                try (ResultSet rs = psCompra.getGeneratedKeys()) {
                    if (rs.next()) {
                        idCompraGenerada = rs.getInt(1);
                        compra.setIdCompra(idCompraGenerada);
                    }
                }
            }

            try (PreparedStatement psDetalle = con.prepareStatement(sqlDetalle);
                 PreparedStatement psStock = con.prepareStatement(sqlAumentarStock)) {

                for (DetalleCompra det : compra.getDetalles()) {
                    psDetalle.setInt(1, idCompraGenerada);
                    psDetalle.setInt(2, det.getIdProducto());
                    psDetalle.setInt(3, det.getCantidadComprada());
                    psDetalle.setDouble(4, det.getPrecioUnitarioCompra());
                    psDetalle.setDouble(5, det.getSubtotal());
                    psDetalle.executeUpdate();

                    psStock.setInt(1, det.getCantidadComprada());
                    psStock.setDouble(2, det.getPrecioUnitarioCompra());
                    psStock.setDouble(3, det.getPrecioVenta());
                    psStock.setInt(4, det.getIdProducto());
                    psStock.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    public List<Compra> listarTodas() {
        List<Compra> lista = new ArrayList<>();
        String sql = "SELECT c.IdCompra, c.NumeroFacturaProveedor, c.FechaCompra, c.TotalCompra, " +
                "p.NombreProveedor, u.NombreCompleto AS NombreUsuario " +
                "FROM Compras c " +
                "INNER JOIN Proveedores p ON c.IdProveedor = p.IdProveedor " +
                "INNER JOIN Usuarios u ON c.IdUsuario = u.IdUsuario " +
                "ORDER BY c.IdCompra DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Compra c = new Compra();
                c.setIdCompra(rs.getInt("IdCompra"));
                c.setNumeroFacturaProveedor(rs.getString("NumeroFacturaProveedor"));
                c.setFechaCompra(rs.getTimestamp("FechaCompra"));
                c.setTotalCompra(rs.getDouble("TotalCompra"));
                c.setNombreProveedor(rs.getString("NombreProveedor"));
                c.setNombreUsuario(rs.getString("NombreUsuario"));
                lista.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar compras: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
}