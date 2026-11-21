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

@WebServlet("/devoluciones")
public class DevolucionServlet extends HttpServlet {

    private final DevolucionDAO devolucionDAO = new DevolucionDAO();
    private final ProductoDAO productoDAO = new ProductoDAO();
    private final FacturaDAO facturaDAO = new FacturaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        req.setAttribute("devoluciones", devolucionDAO.listarTodas());
        req.setAttribute("productos", productoDAO.listar());
        req.setAttribute("facturas", facturaDAO.listarTodas());

        req.setAttribute("vistaCentral", "/devoluciones.jsp");
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

        try {
            String idFacturaStr = req.getParameter("idFactura");
            int idProducto = Integer.parseInt(req.getParameter("idProducto"));
            int cantidad = Integer.parseInt(req.getParameter("cantidadDevuelta"));
            String motivo = req.getParameter("motivo");
            double monto = Double.parseDouble(req.getParameter("montoReembolsado"));
            String observaciones = req.getParameter("observaciones");

            if (!"Producto Dañado".equals(motivo) && !"Vencimiento".equals(motivo)) {
                req.getSession().setAttribute("mensajeError", "Motivo inválido. Solo se admite 'Producto Dañado' o 'Vencimiento'.");
                resp.sendRedirect(req.getContextPath() + "/devoluciones");
                return;
            }

            Devolucion dev = new Devolucion();
            if (idFacturaStr != null && !idFacturaStr.trim().isEmpty() && !idFacturaStr.equals("0")) {
                dev.setIdFactura(Integer.parseInt(idFacturaStr));
            } else {
                dev.setIdFactura(null);
            }

            dev.setIdProducto(idProducto);
            dev.setIdUsuario(usuario.getIdUsuario());
            dev.setCantidadDevuelta(cantidad);
            dev.setMotivo(motivo);
            dev.setMontoReembolsado(monto);
            dev.setObservaciones(observaciones);

            boolean guardado = devolucionDAO.insertar(dev);
            if (guardado) {
                req.getSession().setAttribute("mensajeExito", "Devolución registrada exitosamente.");
            } else {
                req.getSession().setAttribute("mensajeError", "No se pudo registrar la devolución.");
            }

            resp.sendRedirect(req.getContextPath() + "/devoluciones");

        } catch (Exception e) {
            req.getSession().setAttribute("mensajeError", "Error al procesar la devolución: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/devoluciones");
        }
    }
}