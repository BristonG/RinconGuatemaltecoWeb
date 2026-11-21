package com.proyectobd.rinconguatemaltecoweb.controlador;

import com.proyectobd.rinconguatemaltecoweb.dao.ProveedorDAO;
import com.proyectobd.rinconguatemaltecoweb.modelo.Proveedor;
import com.proyectobd.rinconguatemaltecoweb.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/proveedores")
public class ProveedorServlet extends HttpServlet {

    private final ProveedorDAO proveedorDAO = new ProveedorDAO();

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

        switch (accion) {
            case "editar":
                try {
                    int idEditar = Integer.parseInt(req.getParameter("id"));
                    Proveedor prov = proveedorDAO.obtenerPorId(idEditar);
                    req.setAttribute("proveedorEditar", prov);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID de proveedor inválido.");
                }
                break;

            case "eliminar":
                try {
                    int idEliminar = Integer.parseInt(req.getParameter("id"));
                    boolean eliminado = proveedorDAO.eliminar(idEliminar);
                    if (!eliminado) {
                        req.getSession().setAttribute("mensajeError", "No se puede eliminar el proveedor porque tiene compras asociadas.");
                    }
                } catch (Exception e) {
                    req.getSession().setAttribute("mensajeError", "Error al eliminar: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/proveedores");
                return;

            case "listar":
            default:
                break;
        }

        List<Proveedor> lista = proveedorDAO.listar();
        req.setAttribute("proveedores", lista);
        req.setAttribute("vistaCentral", "/proveedores.jsp");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            String idStr = req.getParameter("idProveedor");
            String nit = req.getParameter("nit");
            String nombre = req.getParameter("nombreProveedor");
            String contacto = req.getParameter("contacto");
            String telefono = req.getParameter("telefono");
            String direccion = req.getParameter("direccion");

            Proveedor prov = new Proveedor();
            prov.setNit(nit);
            prov.setNombreProveedor(nombre);
            prov.setContacto(contacto);
            prov.setTelefono(telefono);
            prov.setDireccion(direccion);

            if (idStr == null || idStr.trim().isEmpty() || idStr.equals("0")) {
                proveedorDAO.insertar(prov);
            } else {
                prov.setIdProveedor(Integer.parseInt(idStr));
                proveedorDAO.actualizar(prov);
            }

            resp.sendRedirect(req.getContextPath() + "/proveedores");
        } catch (Exception e) {
            req.setAttribute("error", "Error al procesar proveedor: " + e.getMessage());
            doGet(req, resp);
        }
    }
}