package com.proyectobd.rinconguatemaltecoweb.dao;

import com.proyectobd.rinconguatemaltecoweb.conexion.ConexionBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReporteDAO {
    //Reporte ventas
    public static class FilaFacturaDia {
        private String numeroFactura;
        private String fechaHora;
        private String cliente;
        private String cajero;
        private String formaPago;
        private double total;
        private String estado;

        public FilaFacturaDia(String numeroFactura, String fechaHora, String cliente, String cajero, String formaPago, double total, String estado) {
            this.numeroFactura = numeroFactura;
            this.fechaHora = fechaHora;
            this.cliente = cliente;
            this.cajero = cajero;
            this.formaPago = formaPago;
            this.total = total;
            this.estado = estado;
        }
        public String getNumeroFactura() { return numeroFactura; }
        public String getFechaHora() { return fechaHora; }
        public String getCliente() { return cliente; }
        public String getCajero() { return cajero; }
        public String getFormaPago() { return formaPago; }
        public double getTotal() { return total; }
        public String getEstado() { return estado; }
    }

    public static class FilaProductoVendidoDia {
        private String nombreProducto;
        private int totalVendido;

        public FilaProductoVendidoDia(String nombreProducto, int totalVendido) {
            this.nombreProducto = nombreProducto;
            this.totalVendido = totalVendido;
        }
        public String getNombreProducto() { return nombreProducto; }
        public int getTotalVendido() { return totalVendido; }
    }

    public List<FilaFacturaDia> obtenerFacturasPorFecha(String fecha) {
        List<FilaFacturaDia> lista = new ArrayList<>();
        String sql = "SELECT f.NumeroFactura, CONVERT(VARCHAR, f.FechaFactura, 120) AS FechaHora, " +
                "LTRIM(RTRIM(CONCAT(c.Nombres, ' ', ISNULL(c.Apellidos, '')))) AS Cliente, " +
                "u.NombreCompleto AS Cajero, fp.Descripcion AS FormaPago, f.TotalVenta, f.Estado " +
                "FROM Facturas f " +
                "INNER JOIN Clientes c ON f.IdCliente = c.IdCliente " +
                "INNER JOIN Usuarios u ON f.IdUsuario = u.IdUsuario " +
                "INNER JOIN FormasPago fp ON f.IdFormaPago = fp.IdFormaPago " +
                "WHERE CAST(f.FechaFactura AS DATE) = ? " +
                "ORDER BY f.IdFactura DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fecha);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new FilaFacturaDia(
                            rs.getString("NumeroFactura"),
                            rs.getString("FechaHora"),
                            rs.getString("Cliente"),
                            rs.getString("Cajero"),
                            rs.getString("FormaPago"),
                            rs.getDouble("TotalVenta"),
                            rs.getString("Estado")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<FilaProductoVendidoDia> obtenerProductosVendidosPorFecha(String fecha) {
        List<FilaProductoVendidoDia> lista = new ArrayList<>();
        String sql = "SELECT p.NombreProducto, SUM(df.Cantidad) AS TotalVendido " +
                "FROM DetalleFactura df " +
                "INNER JOIN Facturas f ON df.IdFactura = f.IdFactura " +
                "INNER JOIN Productos p ON df.IdProducto = p.IdProducto " +
                "WHERE CAST(f.FechaFactura AS DATE) = ? AND (f.Estado = 'Emitida' OR f.Estado IS NULL) " +
                "GROUP BY p.NombreProducto " +
                "ORDER BY SUM(df.Cantidad) DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fecha);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new FilaProductoVendidoDia(
                            rs.getString("NombreProducto"),
                            rs.getInt("TotalVendido")
                    ));
                }
            }
            System.out.println(">>> Productos vendidos cargados para " + fecha + ": " + lista.size());
        } catch (SQLException e) {
            System.err.println(">>> ERROR SQL ReporteDAO: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
    //reporte devoluciones
    public static class FilaDevolucionRep {
        private int idDevolucion;
        private String fechaHora;
        private String facturaOrigen;
        private String producto;
        private int cantidad;
        private String motivo;
        private double monto;
        private String responsable;

        public FilaDevolucionRep(int idDevolucion, String fechaHora, String facturaOrigen, String producto, int cantidad, String motivo, double monto, String responsable) {
            this.idDevolucion = idDevolucion;
            this.fechaHora = fechaHora;
            this.facturaOrigen = facturaOrigen;
            this.producto = producto;
            this.cantidad = cantidad;
            this.motivo = motivo;
            this.monto = monto;
            this.responsable = responsable;
        }
        public int getIdDevolucion() { return idDevolucion; }
        public String getFechaHora() { return fechaHora; }
        public String getFacturaOrigen() { return facturaOrigen; }
        public String getProducto() { return producto; }
        public int getCantidad() { return cantidad; }
        public String getMotivo() { return motivo; }
        public double getMonto() { return monto; }
        public String getResponsable() { return responsable; }
    }

    public List<FilaDevolucionRep> obtenerReporteDevoluciones() {
        List<FilaDevolucionRep> lista = new ArrayList<>();
        String sql = "SELECT d.IdDevolucion, CONVERT(VARCHAR, d.FechaDevolucion, 120) AS FechaHora, " +
                "ISNULL(f.NumeroFactura, 'Sin Factura') AS FacturaOrigen, " +
                "p.NombreProducto, d.CantidadDevuelta, d.Motivo, d.MontoReembolsado, u.NombreCompleto AS Responsable " +
                "FROM Devoluciones d " +
                "LEFT JOIN Facturas f ON d.IdFactura = f.IdFactura " +
                "INNER JOIN Productos p ON d.IdProducto = p.IdProducto " +
                "INNER JOIN Usuarios u ON d.IdUsuario = u.IdUsuario " +
                "ORDER BY d.FechaDevolucion DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new FilaDevolucionRep(
                        rs.getInt("IdDevolucion"),
                        rs.getString("FechaHora"),
                        rs.getString("FacturaOrigen"),
                        rs.getString("NombreProducto"),
                        rs.getInt("CantidadDevuelta"),
                        rs.getString("Motivo"),
                        rs.getDouble("MontoReembolsado"),
                        rs.getString("Responsable")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    //Cartera de clientes
    public static class FilaClienteRep {
        private String nit;
        private String nombreCompleto;
        private String telefono;
        private String correo;
        private String direccion;
        private double totalConsumido;
        private String ultimaCompra;

        public FilaClienteRep(String nit, String nombreCompleto, String telefono, String correo, String direccion, double totalConsumido, String ultimaCompra) {
            this.nit = nit;
            this.nombreCompleto = nombreCompleto;
            this.telefono = telefono;
            this.correo = correo;
            this.direccion = direccion;
            this.totalConsumido = totalConsumido;
            this.ultimaCompra = ultimaCompra;
        }
        public String getNit() { return nit; }
        public String getNombreCompleto() { return nombreCompleto; }
        public String getTelefono() { return telefono; }
        public String getCorreo() { return correo; }
        public String getDireccion() { return direccion; }
        public double getTotalConsumido() { return totalConsumido; }
        public String getUltimaCompra() { return ultimaCompra; }
    }

    public List<FilaClienteRep> obtenerReporteClientes() {
        List<FilaClienteRep> lista = new ArrayList<>();
        String sql = "SELECT c.NIT, LTRIM(RTRIM(CONCAT(c.Nombres, ' ', ISNULL(c.Apellidos, '')))) AS NombreCliente, " +
                "c.Telefono, c.CorreoElectronico, c.Direccion, " +
                "ISNULL(SUM(CASE WHEN f.Estado = 'Emitida' THEN f.TotalVenta ELSE 0 END), 0) AS TotalConsumido, " +
                "MAX(CASE WHEN f.Estado = 'Emitida' THEN CONVERT(VARCHAR, f.FechaFactura, 120) ELSE NULL END) AS UltimaCompra " +
                "FROM Clientes c " +
                "LEFT JOIN Facturas f ON c.IdCliente = f.IdCliente " +
                "GROUP BY c.IdCliente, c.NIT, c.Nombres, c.Apellidos, c.Telefono, c.CorreoElectronico, c.Direccion " +
                "ORDER BY TotalConsumido DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new FilaClienteRep(
                        rs.getString("NIT"),
                        rs.getString("NombreCliente"),
                        rs.getString("Telefono"),
                        rs.getString("CorreoElectronico"),
                        rs.getString("Direccion"),
                        rs.getDouble("TotalConsumido"),
                        rs.getString("UltimaCompra")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    //reporte de compras
    public static class FilaCompraRep {
        private int idCompra;
        private String fechaHora;
        private String proveedor;
        private String noFacturaProveedor;
        private String producto;
        private int cantidad;
        private double costoUnitario;
        private double subtotal;

        public FilaCompraRep(int idCompra, String fechaHora, String proveedor, String noFacturaProveedor, String producto, int cantidad, double costoUnitario, double subtotal) {
            this.idCompra = idCompra;
            this.fechaHora = fechaHora;
            this.proveedor = proveedor;
            this.noFacturaProveedor = noFacturaProveedor;
            this.producto = producto;
            this.cantidad = cantidad;
            this.costoUnitario = costoUnitario;
            this.subtotal = subtotal;
        }
        public int getIdCompra() { return idCompra; }
        public String getFechaHora() { return fechaHora; }
        public String getProveedor() { return proveedor; }
        public String getNoFacturaProveedor() { return noFacturaProveedor; }
        public String getProducto() { return producto; }
        public int getCantidad() { return cantidad; }
        public double getCostoUnitario() { return costoUnitario; }
        public double getSubtotal() { return subtotal; }
    }

    public List<FilaCompraRep> obtenerReporteCompras() {
        List<FilaCompraRep> lista = new ArrayList<>();
        String sql = "SELECT c.IdCompra, CONVERT(VARCHAR, c.FechaCompra, 120) AS FechaHora, " +
                "p.NombreProveedor, ISNULL(c.NumeroFacturaProveedor, 'S/N') AS NoFacturaProveedor, " +
                "pr.NombreProducto, dc.CantidadComprada, dc.PrecioUnitarioCompra, dc.Subtotal " +
                "FROM DetalleCompras dc " +
                "INNER JOIN Compras c ON dc.IdCompra = c.IdCompra " +
                "INNER JOIN Proveedores p ON c.IdProveedor = p.IdProveedor " +
                "INNER JOIN Productos pr ON dc.IdProducto = pr.IdProducto " +
                "ORDER BY c.FechaCompra DESC";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new FilaCompraRep(
                        rs.getInt("IdCompra"),
                        rs.getString("FechaHora"),
                        rs.getString("NombreProveedor"),
                        rs.getString("NoFacturaProveedor"),
                        rs.getString("NombreProducto"),
                        rs.getInt("CantidadComprada"),
                        rs.getDouble("PrecioUnitarioCompra"),
                        rs.getDouble("Subtotal")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}