package com.proyectobd.rinconguatemaltecoweb.dao;

import com.proyectobd.rinconguatemaltecoweb.conexion.ConexionBD;
import com.proyectobd.rinconguatemaltecoweb.modelo.Cliente;
import com.proyectobd.rinconguatemaltecoweb.modelo.DetalleFactura;
import com.proyectobd.rinconguatemaltecoweb.modelo.Factura;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class FacturaDAO {

    public List<Factura> listarTodas() {
        List<Factura> lista = new ArrayList<>();
        String sql = "SELECT f.IdFactura, f.NumeroFactura, f.IdCliente, " +
                "LTRIM(RTRIM(CONCAT(c.Nombres, ' ', ISNULL(c.Apellidos, '')))) AS NombreCliente, " +
                "c.NIT AS NitCliente, f.IdUsuario, u.NombreCompleto AS NombreCajero, " +
                "f.IdFormaPago, fp.Descripcion AS DescripcionFormaPago, f.FechaFactura, " +
                "f.TotalVenta, f.MontoRecibido, f.Cambio, f.Estado " +
                "FROM Facturas f " +
                "INNER JOIN Clientes c ON f.IdCliente = c.IdCliente " +
                "INNER JOIN Usuarios u ON f.IdUsuario = u.IdUsuario " +
                "INNER JOIN FormasPago fp ON f.IdFormaPago = fp.IdFormaPago " +
                "ORDER BY f.IdFactura DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Factura f = new Factura();
                f.setIdFactura(rs.getInt("IdFactura"));
                f.setNumeroFactura(rs.getString("NumeroFactura"));
                f.setIdCliente(rs.getInt("IdCliente"));
                f.setNombreCliente(rs.getString("NombreCliente"));
                f.setNitCliente(rs.getString("NitCliente"));
                f.setIdUsuario(rs.getInt("IdUsuario"));
                f.setNombreCajero(rs.getString("NombreCajero"));
                f.setIdFormaPago(rs.getInt("IdFormaPago"));
                f.setDescripcionFormaPago(rs.getString("DescripcionFormaPago"));
                f.setFechaFactura(rs.getTimestamp("FechaFactura"));
                f.setTotalVenta(rs.getDouble("TotalVenta"));
                f.setMontoRecibido(rs.getDouble("MontoRecibido"));
                f.setCambio(rs.getDouble("Cambio"));
                f.setEstado(rs.getString("Estado"));
                lista.add(f);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar facturas: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public Factura obtenerPorId(int id) {
        Factura f = null;
        String sql = "SELECT f.IdFactura, f.NumeroFactura, f.IdCliente, " +
                "LTRIM(RTRIM(CONCAT(c.Nombres, ' ', ISNULL(c.Apellidos, '')))) AS NombreCliente, " +
                "c.NIT AS NitCliente, f.IdUsuario, u.NombreCompleto AS NombreCajero, " +
                "f.IdFormaPago, fp.Descripcion AS DescripcionFormaPago, f.FechaFactura, " +
                "f.TotalVenta, f.MontoRecibido, f.Cambio, f.Estado " +
                "FROM Facturas f " +
                "INNER JOIN Clientes c ON f.IdCliente = c.IdCliente " +
                "INNER JOIN Usuarios u ON f.IdUsuario = u.IdUsuario " +
                "INNER JOIN FormasPago fp ON f.IdFormaPago = fp.IdFormaPago " +
                "WHERE f.IdFactura = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    f = new Factura();
                    f.setIdFactura(rs.getInt("IdFactura"));
                    f.setNumeroFactura(rs.getString("NumeroFactura"));
                    f.setIdCliente(rs.getInt("IdCliente"));
                    f.setNombreCliente(rs.getString("NombreCliente"));
                    f.setNitCliente(rs.getString("NitCliente"));
                    f.setIdUsuario(rs.getInt("IdUsuario"));
                    f.setNombreCajero(rs.getString("NombreCajero"));
                    f.setIdFormaPago(rs.getInt("IdFormaPago"));
                    f.setDescripcionFormaPago(rs.getString("DescripcionFormaPago"));
                    f.setFechaFactura(rs.getTimestamp("FechaFactura"));
                    f.setTotalVenta(rs.getDouble("TotalVenta"));
                    f.setMontoRecibido(rs.getDouble("MontoRecibido"));
                    f.setCambio(rs.getDouble("Cambio"));
                    f.setEstado(rs.getString("Estado"));
                }
            }

            if (f != null) {
                String sqlDet = "SELECT d.IdDetalleFactura, d.IdFactura, d.IdProducto, p.NombreProducto, " +
                        "d.Cantidad, d.PrecioUnitarioVenta, d.SubtotalLinea " +
                        "FROM DetalleFactura d " +
                        "INNER JOIN Productos p ON d.IdProducto = p.IdProducto " +
                        "WHERE d.IdFactura = ?";
                try (PreparedStatement psDet = con.prepareStatement(sqlDet)) {
                    psDet.setInt(1, id);
                    try (ResultSet rsDet = psDet.executeQuery()) {
                        List<DetalleFactura> detalles = new ArrayList<>();
                        while (rsDet.next()) {
                            DetalleFactura df = new DetalleFactura();
                            df.setIdDetalleFactura(rsDet.getInt("IdDetalleFactura"));
                            df.setIdFactura(rsDet.getInt("IdFactura"));
                            df.setIdProducto(rsDet.getInt("IdProducto"));
                            df.setNombreProducto(rsDet.getString("NombreProducto"));
                            df.setCantidad(rsDet.getInt("Cantidad"));
                            df.setPrecioUnitarioVenta(rsDet.getDouble("PrecioUnitarioVenta"));
                            df.setSubtotalLinea(rsDet.getDouble("SubtotalLinea"));
                            detalles.add(df);
                        }
                        f.setDetalles(detalles);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener factura: " + e.getMessage());
            e.printStackTrace();
        }
        return f;
    }

    public Factura procesarVentaCompleta(Cliente cliente, int idUsuario, int idFormaPago,
                                         double montoRecibido, double cambio,
                                         List<DetalleFactura> carrito) throws SQLException {

        Connection con = null;
        PreparedStatement psClienteCheck = null;
        PreparedStatement psClienteInsert = null;
        PreparedStatement psCorrelativo = null;
        PreparedStatement psFactura = null;
        PreparedStatement psDetalle = null;
        PreparedStatement psStock = null;
        ResultSet rs = null;

        try {
            con = ConexionBD.obtenerConexion();
            con.setAutoCommit(false);

            int idClienteFinal = 0;
            String nitLimpio = (cliente.getNit() != null && !cliente.getNit().trim().isEmpty())
                    ? cliente.getNit().trim().toUpperCase() : "CF";

            String sqlBuscarCliente = "SELECT IdCliente FROM Clientes WHERE UPPER(LTRIM(RTRIM(NIT))) = ?";
            psClienteCheck = con.prepareStatement(sqlBuscarCliente);
            psClienteCheck.setString(1, nitLimpio);
            rs = psClienteCheck.executeQuery();

            if (rs.next()) {
                idClienteFinal = rs.getInt("IdCliente");
            } else {
                String sqlInsertCliente = "INSERT INTO Clientes (NIT, Nombres, Apellidos, Direccion, Telefono, CorreoElectronico) " +
                        "VALUES (?, ?, ?, ?, ?, ?)";
                psClienteInsert = con.prepareStatement(sqlInsertCliente, Statement.RETURN_GENERATED_KEYS);
                psClienteInsert.setString(1, nitLimpio);
                psClienteInsert.setString(2, (cliente.getNombres() != null && !cliente.getNombres().trim().isEmpty()) ? cliente.getNombres().trim() : "Consumidor");
                psClienteInsert.setString(3, (cliente.getApellidos() != null) ? cliente.getApellidos().trim() : "Final");
                psClienteInsert.setString(4, (cliente.getDireccion() != null && !cliente.getDireccion().trim().isEmpty()) ? cliente.getDireccion().trim() : "Ciudad");
                psClienteInsert.setString(5, cliente.getTelefono());
                psClienteInsert.setString(6, cliente.getCorreoElectronico());
                psClienteInsert.executeUpdate();

                ResultSet rsKey = psClienteInsert.getGeneratedKeys();
                if (rsKey.next()) {
                    idClienteFinal = rsKey.getInt(1);
                }
            }

            if (rs != null) rs.close();

            String sqlCorr = "SELECT ISNULL(MAX(IdFactura), 0) + 1 AS SiguienteId FROM Facturas";
            psCorrelativo = con.prepareStatement(sqlCorr);
            rs = psCorrelativo.executeQuery();
            int siguienteId = 1;
            if (rs.next()) {
                siguienteId = rs.getInt("SiguienteId");
            }
            String numeroFactura = String.format("FAC-%05d", siguienteId);

            double totalVenta = 0.0;
            for (DetalleFactura item : carrito) {
                totalVenta += item.getSubtotalLinea();
            }

            String sqlFac = "INSERT INTO Facturas (NumeroFactura, FechaFactura, IdCliente, IdUsuario, IdFormaPago, TotalVenta, MontoRecibido, Cambio, Estado) " +
                    "VALUES (?, GETDATE(), ?, ?, ?, ?, ?, ?, 'Emitida')";
            psFactura = con.prepareStatement(sqlFac, Statement.RETURN_GENERATED_KEYS);
            psFactura.setString(1, numeroFactura);
            psFactura.setInt(2, idClienteFinal);
            psFactura.setInt(3, idUsuario);
            psFactura.setInt(4, idFormaPago);
            psFactura.setDouble(5, totalVenta);
            psFactura.setDouble(6, montoRecibido);
            psFactura.setDouble(7, cambio);
            psFactura.executeUpdate();

            int idFacturaGenerada = 0;
            ResultSet rsFacKey = psFactura.getGeneratedKeys();
            if (rsFacKey.next()) {
                idFacturaGenerada = rsFacKey.getInt(1);
            }

            if (idFacturaGenerada == 0) {
                try (Statement st = con.createStatement();
                     ResultSet rsId = st.executeQuery("SELECT SCOPE_IDENTITY() AS LastId")) {
                    if (rsId.next()) {
                        idFacturaGenerada = rsId.getInt("LastId");
                    }
                }
            }

            String sqlDet = "INSERT INTO DetalleFactura (IdFactura, IdProducto, Cantidad, PrecioUnitarioVenta, SubtotalLinea) VALUES (?, ?, ?, ?, ?)";
            String sqlUpdStock = "UPDATE Productos SET StockActual = StockActual - ? WHERE IdProducto = ? AND StockActual >= ?";

            psDetalle = con.prepareStatement(sqlDet);
            psStock = con.prepareStatement(sqlUpdStock);

            for (DetalleFactura item : carrito) {
                psDetalle.setInt(1, idFacturaGenerada);
                psDetalle.setInt(2, item.getIdProducto());
                psDetalle.setInt(3, item.getCantidad());
                psDetalle.setDouble(4, item.getPrecioUnitarioVenta());
                psDetalle.setDouble(5, item.getSubtotalLinea());
                psDetalle.executeUpdate();

                psStock.setInt(1, item.getCantidad());
                psStock.setInt(2, item.getIdProducto());
                psStock.setInt(3, item.getCantidad());
                int filasAfectadas = psStock.executeUpdate();

                if (filasAfectadas == 0) {
                    throw new SQLException("Stock insuficiente para: " + item.getNombreProducto());
                }
            }

            con.commit();

            Factura facturaEmitida = new Factura();
            facturaEmitida.setIdFactura(idFacturaGenerada);
            facturaEmitida.setNumeroFactura(numeroFactura);
            facturaEmitida.setTotalVenta(totalVenta);
            facturaEmitida.setMontoRecibido(montoRecibido);
            facturaEmitida.setCambio(cambio);
            facturaEmitida.setNitCliente(nitLimpio);
            facturaEmitida.setNombreCliente(cliente.getNombreCompleto());
            facturaEmitida.setDetalles(carrito);

            return facturaEmitida;

        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (psClienteCheck != null) psClienteCheck.close();
            if (psClienteInsert != null) psClienteInsert.close();
            if (psCorrelativo != null) psCorrelativo.close();
            if (psFactura != null) psFactura.close();
            if (psDetalle != null) psDetalle.close();
            if (psStock != null) psStock.close();
            if (con != null) con.close();
        }
    }

    public boolean anularFactura(int idFactura) {
        String sqlVerificar = "SELECT Estado FROM Facturas WHERE IdFactura = ?";
        String sqlRestituirStock = "UPDATE p " +
                "SET p.StockActual = p.StockActual + d.Cantidad " +
                "FROM Productos p " +
                "INNER JOIN DetalleFactura d ON p.IdProducto = d.IdProducto " +
                "WHERE d.IdFactura = ?";
        String sqlActualizarFactura = "UPDATE Facturas SET Estado = 'Anulada' WHERE IdFactura = ?";

        Connection con = null;

        try {
            con = ConexionBD.obtenerConexion();
            con.setAutoCommit(false);

            try (PreparedStatement psVerificar = con.prepareStatement(sqlVerificar)) {
                psVerificar.setInt(1, idFactura);
                try (ResultSet rs = psVerificar.executeQuery()) {
                    if (!rs.next()) {
                        System.err.println("La factura con ID " + idFactura + " no existe.");
                        con.rollback();
                        return false;
                    }
                    String estado = rs.getString("Estado");
                    if ("Anulada".equalsIgnoreCase(estado)) {
                        System.err.println("La factura ya se encuentra anulada.");
                        con.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement psStock = con.prepareStatement(sqlRestituirStock)) {
                psStock.setInt(1, idFactura);
                psStock.executeUpdate();
            }

            try (PreparedStatement psEstado = con.prepareStatement(sqlActualizarFactura)) {
                psEstado.setInt(1, idFactura);
                psEstado.executeUpdate();
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al anular la factura: " + e.getMessage());
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error durante rollback: " + ex.getMessage());
                }
            }
            return false;

        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}