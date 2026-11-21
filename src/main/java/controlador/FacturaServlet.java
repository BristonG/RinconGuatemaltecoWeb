package com.proyectobd.rinconguatemaltecoweb.controlador;

import com.proyectobd.rinconguatemaltecoweb.dao.FacturaDAO;
import com.proyectobd.rinconguatemaltecoweb.modelo.Factura;
import com.proyectobd.rinconguatemaltecoweb.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/facturas")
public class FacturaServlet extends HttpServlet {

    private final FacturaDAO facturaDAO = new FacturaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String accion = req.getParameter("accion");
        if (accion == null) accion = "listar";

        if ("anular".equalsIgnoreCase(accion)) {
            try {
                int idFactura = Integer.parseInt(req.getParameter("id"));
                boolean anulada = facturaDAO.anularFactura(idFactura);

                if (anulada) {
                    req.getSession().setAttribute("mensajeExito", "Factura anulada con éxito y productos devueltos al stock.");
                } else {
                    req.getSession().setAttribute("mensajeError", "No se pudo anular la factura (ya estaba anulada o no existe).");
                }
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("mensajeError", "ID de factura no válido.");
            } catch (Exception e) {
                req.getSession().setAttribute("mensajeError", "Error al procesar la anulación: " + e.getMessage());
            }

            resp.sendRedirect(req.getContextPath() + "/facturas");
            return;
        }

        List<Factura> historial = facturaDAO.listarTodas();
        req.setAttribute("facturas", historial);
        req.setAttribute("vistaCentral", "/facturas.jsp");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}