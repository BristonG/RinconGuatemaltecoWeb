package com.proyectobd.rinconguatemaltecoweb.controlador;

import com.proyectobd.rinconguatemaltecoweb.dao.*;
import com.proyectobd.rinconguatemaltecoweb.modelo.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/compras")
public class CompraServlet extends HttpServlet {

    private final ProveedorDAO proveedorDAO = new ProveedorDAO();
    private final ProductoDAO productoDAO = new ProductoDAO();
    private final CompraDAO compraDAO = new CompraDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (session.getAttribute("carritoCompras") == null) {
            session.setAttribute("carritoCompras", new ArrayList<ItemCarritoCompra>());
        }

        cargarCatalogos(req);
        calcularTotal(session, req);

        req.setAttribute("historialCompras", compraDAO.listarTodas());
        req.setAttribute("vistaCentral", "/compras.jsp");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<ItemCarritoCompra> carrito = (List<ItemCarritoCompra>) session.getAttribute("carritoCompras");
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carritoCompras", carrito);
        }

        String accion = req.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {
            case "agregar":
                try {
                    int idProd = Integer.parseInt(req.getParameter("idProducto"));
                    int cant = Integer.parseInt(req.getParameter("cantidad"));
                    double costo = Double.parseDouble(req.getParameter("costoUnitario"));
                    double venta = Double.parseDouble(req.getParameter("precioVenta"));

                    Producto p = productoDAO.obtenerPorId(idProd);
                    if (p != null) {
                        ItemCarritoCompra existente = carrito.stream()
                                .filter(i -> i.getIdProducto() == idProd)
                                .findFirst().orElse(null);

                        if (existente != null) {
                            existente.setCantidad(existente.getCantidad() + cant);
                            existente.setCostoUnitario(costo);
                            existente.setPrecioVenta(venta);
                        } else {
                            carrito.add(new ItemCarritoCompra(p.getIdProducto(), p.getNombreProducto(), costo, venta, cant));
                        }
                    }
                } catch (Exception e) {
                    req.setAttribute("error", "Datos de entrada inválidos para agregar producto.");
                }
                break;

            case "eliminar":
                try {
                    int idEliminar = Integer.parseInt(req.getParameter("idProducto"));
                    carrito.removeIf(i -> i.getIdProducto() == idEliminar);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID de producto inválido.");
                }
                break;

            case "guardarCompra":
                if (carrito.isEmpty()) {
                    req.setAttribute("error", "Debe agregar al menos un producto a la compra.");
                    break;
                }

                try {
                    int idProveedor = Integer.parseInt(req.getParameter("idProveedor"));
                    String noFactura = req.getParameter("numeroFacturaProveedor");
                    double totalCompra = carrito.stream().mapToDouble(ItemCarritoCompra::getSubtotal).sum();

                    Compra compra = new Compra();
                    compra.setIdProveedor(idProveedor);
                    compra.setIdUsuario(usuario.getIdUsuario());
                    compra.setNumeroFacturaProveedor(noFactura);
                    compra.setTotalCompra(totalCompra);

                    for (ItemCarritoCompra item : carrito) {
                        compra.getDetalles().add(new DetalleCompra(
                                item.getIdProducto(),
                                item.getCantidad(),
                                item.getCostoUnitario(),
                                item.getSubtotal(),
                                item.getPrecioVenta()
                        ));
                    }

                    compraDAO.registrarCompra(compra);

                    session.removeAttribute("carritoCompras");
                    session.setAttribute("mensajeExito", "¡Compra #" + compra.getIdCompra() + " registrada con éxito! El inventario, costo y precio de venta han sido actualizados.");

                    resp.sendRedirect(req.getContextPath() + "/compras");
                    return;

                } catch (Exception e) {
                    req.setAttribute("error", "Error al procesar la compra: " + e.getMessage());
                }
                break;
        }

        cargarCatalogos(req);
        calcularTotal(session, req);
        req.setAttribute("historialCompras", compraDAO.listarTodas());
        req.setAttribute("vistaCentral", "/compras.jsp");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private void cargarCatalogos(HttpServletRequest req) {
        req.setAttribute("proveedores", proveedorDAO.listar());
        req.setAttribute("productos", productoDAO.listar());
    }

    private void calcularTotal(HttpSession session, HttpServletRequest req) {
        @SuppressWarnings("unchecked")
        List<ItemCarritoCompra> carrito = (List<ItemCarritoCompra>) session.getAttribute("carritoCompras");
        double total = 0.0;
        if (carrito != null) {
            total = carrito.stream().mapToDouble(ItemCarritoCompra::getSubtotal).sum();
        }
        req.setAttribute("totalCompra", total);
    }
}