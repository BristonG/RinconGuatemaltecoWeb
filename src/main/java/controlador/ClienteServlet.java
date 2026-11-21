package com.proyectobd.rinconguatemaltecoweb.controlador;

import com.proyectobd.rinconguatemaltecoweb.dao.ClienteDAO;
import com.proyectobd.rinconguatemaltecoweb.modelo.Cliente;
import com.proyectobd.rinconguatemaltecoweb.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/clientes")
public class ClienteServlet extends HttpServlet {

    private final ClienteDAO clienteDAO = new ClienteDAO();

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
                    Cliente c = clienteDAO.obtenerPorId(idEditar);
                    req.setAttribute("clienteEditar", c);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID de cliente inválido.");
                }
                break;

            case "eliminar":
                try {
                    int idEliminar = Integer.parseInt(req.getParameter("id"));
                    if (idEliminar == 1) {
                        req.getSession().setAttribute("mensajeError", "No se puede eliminar el cliente 'Consumidor Final' por ser requerido por el sistema.");
                    } else {
                        boolean eliminado = clienteDAO.eliminar(idEliminar);
                        if (!eliminado) {
                            req.getSession().setAttribute("mensajeError", "No se puede eliminar el cliente porque tiene facturas asociadas.");
                        } else {
                            req.getSession().setAttribute("mensajeExito", "Cliente eliminado correctamente.");
                        }
                    }
                } catch (Exception e) {
                    req.getSession().setAttribute("mensajeError", "Error al procesar la eliminación: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/clientes");
                return;

            case "listar":
            default:
                break;
        }

        List<Cliente> lista = clienteDAO.listar();
        req.setAttribute("clientes", lista);

        req.setAttribute("vistaCentral", "/clientes.jsp");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            String idStr = req.getParameter("idCliente");
            String nit = req.getParameter("nit");
            String nombres = req.getParameter("nombres");
            String apellidos = req.getParameter("apellidos");
            String direccion = req.getParameter("direccion");
            String telefono = req.getParameter("telefono");
            String correo = req.getParameter("correoElectronico");

            Cliente c = new Cliente();
            c.setNit(nit);
            c.setNombres(nombres);
            c.setApellidos(apellidos);
            c.setDireccion(direccion);
            c.setTelefono(telefono);
            c.setCorreoElectronico(correo);

            if (idStr == null || idStr.trim().isEmpty() || idStr.equals("0")) {
                clienteDAO.insertar(c);
                req.getSession().setAttribute("mensajeExito", "Cliente registrado exitosamente.");
            } else {
                c.setIdCliente(Integer.parseInt(idStr));
                clienteDAO.actualizar(c);
                req.getSession().setAttribute("mensajeExito", "Cliente actualizado correctamente.");
            }

            resp.sendRedirect(req.getContextPath() + "/clientes");
        } catch (Exception e) {
            req.setAttribute("error", "Error al guardar el cliente: " + e.getMessage());
            doGet(req, resp);
        }
    }
}