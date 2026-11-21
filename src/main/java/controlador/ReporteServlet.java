package com.proyectobd.rinconguatemaltecoweb.controlador;

import com.proyectobd.rinconguatemaltecoweb.dao.ReporteDAO;
import com.proyectobd.rinconguatemaltecoweb.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/reportes")
public class ReporteServlet extends HttpServlet {

    private final ReporteDAO reporteDAO = new ReporteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String tab = req.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "cierre";
        }

        String fecha = req.getParameter("fecha");
        if (fecha == null || fecha.trim().isEmpty()) {
            fecha = LocalDate.now().toString(); // Formato yyyy-MM-dd
        }

        req.setAttribute("tabActivo", tab);
        req.setAttribute("fechaSeleccionada", fecha);

        switch (tab) {
            case "cierre":
                req.setAttribute("facturasDia", reporteDAO.obtenerFacturasPorFecha(fecha));
                req.setAttribute("productosVendidosDia", reporteDAO.obtenerProductosVendidosPorFecha(fecha));
                break;
            case "devoluciones":
                req.setAttribute("listaDevoluciones", reporteDAO.obtenerReporteDevoluciones());
                break;
            case "clientes":
                req.setAttribute("listaClientes", reporteDAO.obtenerReporteClientes());
                break;
            case "compras":
                req.setAttribute("listaCompras", reporteDAO.obtenerReporteCompras());
                break;
        }

        req.setAttribute("vistaCentral", "/reportes.jsp");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}