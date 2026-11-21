package com.proyectobd.rinconguatemaltecoweb.controlador;

import com.proyectobd.rinconguatemaltecoweb.dao.ClienteDAO;
import com.proyectobd.rinconguatemaltecoweb.dao.FacturaDAO;
import com.proyectobd.rinconguatemaltecoweb.dao.FormaPagoDAO;
import com.proyectobd.rinconguatemaltecoweb.dao.ProductoDAO;
import com.proyectobd.rinconguatemaltecoweb.modelo.Cliente;
import com.proyectobd.rinconguatemaltecoweb.modelo.DetalleFactura;
import com.proyectobd.rinconguatemaltecoweb.modelo.Factura;
import com.proyectobd.rinconguatemaltecoweb.modelo.Producto;
import com.proyectobd.rinconguatemaltecoweb.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/despacho")
public class DespachoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();
    private final FormaPagoDAO formaPagoDAO = new FormaPagoDAO();
    private final FacturaDAO facturaDAO = new FacturaDAO();
    private final ClienteDAO clienteDAO = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<DetalleFactura> carrito = (List<DetalleFactura>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito);
        }

        String paso = req.getParameter("paso");
        if (paso == null || paso.isEmpty()) {
            paso = "1";
        }

        String errorSesion = (String) session.getAttribute("error");
        if (errorSesion != null) {
            req.setAttribute("error", errorSesion);
            session.removeAttribute("error");
        }

        req.setAttribute("productos", productoDAO.listar());
        req.setAttribute("formasPago", formaPagoDAO.listar());
        req.setAttribute("clientes", clienteDAO.listar());
        req.setAttribute("pasoActual", paso);

        double total = 0.0;
        for (DetalleFactura item : carrito) {
            total += item.getSubtotalLinea();
        }
        req.setAttribute("totalPagar", total);

        req.setAttribute("vistaCentral", "/despacho.jsp");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<DetalleFactura> carrito = (List<DetalleFactura>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito);
        }

        String accion = req.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {
            case "agregar":
                try {
                    int idProducto = Integer.parseInt(req.getParameter("idProducto"));
                    int cantidad = Integer.parseInt(req.getParameter("cantidad"));

                    Producto prod = productoDAO.obtenerPorId(idProducto);
                    if (prod != null && cantidad > 0) {
                        boolean encontrado = false;
                        for (DetalleFactura item : carrito) {
                            if (item.getIdProducto() == idProducto) {
                                int nuevaCant = item.getCantidad() + cantidad;
                                if (nuevaCant <= prod.getStockActual()) {
                                    item.setCantidad(nuevaCant);
                                    item.setSubtotalLinea(nuevaCant * item.getPrecioUnitarioVenta());
                                } else {
                                    session.setAttribute("error", "Stock insuficiente. Máximo disponible: " + prod.getStockActual());
                                }
                                encontrado = true;
                                break;
                            }
                        }
                        if (!encontrado) {
                            if (cantidad <= prod.getStockActual()) {
                                DetalleFactura nuevoItem = new DetalleFactura(
                                        prod.getIdProducto(),
                                        cantidad,
                                        prod.getPrecioVenta(),
                                        cantidad * prod.getPrecioVenta()
                                );
                                nuevoItem.setNombreProducto(prod.getNombreProducto());
                                carrito.add(nuevoItem);
                            } else {
                                session.setAttribute("error", "Stock insuficiente. Solo quedan " + prod.getStockActual() + " unidades.");
                            }
                        }
                    }
                } catch (Exception e) {
                    session.setAttribute("error", "Error al agregar producto: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/despacho?paso=1");
                return;

            case "eliminar":
                try {
                    int idProductoEliminar = Integer.parseInt(req.getParameter("idProducto"));
                    carrito.removeIf(item -> item.getIdProducto() == idProductoEliminar);
                } catch (Exception e) {
                    session.setAttribute("error", "Error al eliminar producto: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/despacho?paso=1");
                return;

            case "guardarClienteTemporal":
                Cliente clienteTemp = new Cliente();
                clienteTemp.setNit(req.getParameter("nit"));
                clienteTemp.setNombres(req.getParameter("nombres"));
                clienteTemp.setApellidos(req.getParameter("apellidos"));
                clienteTemp.setTelefono(req.getParameter("telefono"));
                clienteTemp.setCorreoElectronico(req.getParameter("email"));
                clienteTemp.setDireccion(req.getParameter("direccion"));

                session.setAttribute("clienteTemporal", clienteTemp);
                resp.sendRedirect(req.getContextPath() + "/despacho?paso=3");
                return;

            case "procesarFactura":
                if (carrito.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/despacho?paso=1");
                    return;
                }

                Cliente cli = (Cliente) session.getAttribute("clienteTemporal");
                if (cli == null) {
                    cli = new Cliente();
                    cli.setNit("CF");
                    cli.setNombres("Consumidor");
                    cli.setApellidos("Final");
                    cli.setDireccion("Ciudad");
                }

                try {
                    int idFormaPago = Integer.parseInt(req.getParameter("idFormaPago"));
                    double montoRecibido = Double.parseDouble(req.getParameter("montoRecibido"));

                    double total = 0.0;
                    for (DetalleFactura item : carrito) {
                        total += item.getSubtotalLinea();
                    }

                    if (montoRecibido < total) {
                        session.setAttribute("error", "El monto recibido es menor al total a pagar.");
                        resp.sendRedirect(req.getContextPath() + "/despacho?paso=3");
                        return;
                    }

                    double cambio = montoRecibido - total;

                    Factura facturaEmitida = facturaDAO.procesarVentaCompleta(
                            cli, usuario.getIdUsuario(), idFormaPago, montoRecibido, cambio, carrito
                    );

                    String nombreFormaPago = (idFormaPago == 1) ? "Efectivo" : (idFormaPago == 2 ? "Tarjeta de Crédito/Débito" : "Transferencia");
                    facturaEmitida.setDescripcionFormaPago(nombreFormaPago);

                    List<DetalleFactura> productosFacturados = new ArrayList<>(carrito);

                    session.removeAttribute("carrito");
                    session.removeAttribute("clienteTemporal");

                    req.setAttribute("facturaEmitida", facturaEmitida);
                    req.setAttribute("clienteFactura", cli);
                    req.setAttribute("productosFacturados", productosFacturados);
                    req.setAttribute("pasoActual", "4");
                    req.setAttribute("vistaCentral", "/despacho.jsp");
                    req.getRequestDispatcher("/index.jsp").forward(req, resp);
                    return;

                } catch (Exception e) {
                    session.setAttribute("error", "Error al procesar la factura: " + e.getMessage());
                    resp.sendRedirect(req.getContextPath() + "/despacho?paso=3");
                    return;
                }
        }

        doGet(req, resp);
    }
}