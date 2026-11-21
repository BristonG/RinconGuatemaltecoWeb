package com.proyectobd.rinconguatemaltecoweb.controlador;

import com.proyectobd.rinconguatemaltecoweb.dao.CategoriaDAO;
import com.proyectobd.rinconguatemaltecoweb.dao.ProductoDAO;
import com.proyectobd.rinconguatemaltecoweb.modelo.Categoria;
import com.proyectobd.rinconguatemaltecoweb.modelo.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/productos")
public class ProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String accion = req.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "editar":
                try {
                    int idEditar = Integer.parseInt(req.getParameter("id"));
                    Producto prodEditar = productoDAO.obtenerPorId(idEditar);
                    req.setAttribute("productoEditar", prodEditar);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID de producto inválido.");
                }
                break;

            case "eliminar":
                try {
                    int idEliminar = Integer.parseInt(req.getParameter("id"));
                    productoDAO.eliminar(idEliminar);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID de producto inválido para eliminar.");
                }
                resp.sendRedirect(req.getContextPath() + "/productos");
                return;

            case "listar":
            default:
                break;
        }

        List<Producto> listaProductos = productoDAO.listar();
        List<Categoria> listaCategorias = categoriaDAO.listar();
        req.setAttribute("productos", listaProductos);
        req.setAttribute("categorias", listaCategorias);
        req.setAttribute("vistaCentral", "/productos.jsp");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            String idStr = req.getParameter("idProducto");
            String codigoBarras = req.getParameter("codigoBarras");
            String nombre = req.getParameter("nombreProducto");
            String descripcion = req.getParameter("descripcion");
            int idCategoria = Integer.parseInt(req.getParameter("idCategoria"));
            double precioCosto = Double.parseDouble(req.getParameter("precioCosto"));
            double precioVenta = Double.parseDouble(req.getParameter("precioVenta"));
            int stockActual = Integer.parseInt(req.getParameter("stockActual"));
            int stockMinimo = Integer.parseInt(req.getParameter("stockMinimo"));

            Producto prod = new Producto();
            prod.setCodigoBarras(codigoBarras);
            prod.setNombreProducto(nombre);
            prod.setDescripcion(descripcion);
            prod.setIdCategoria(idCategoria);
            prod.setPrecioCosto(precioCosto);
            prod.setPrecioVenta(precioVenta);
            prod.setStockActual(stockActual);
            prod.setStockMinimo(stockMinimo);

            if (idStr == null || idStr.trim().isEmpty() || idStr.equals("0")) {
                productoDAO.insertar(prod);
            } else {
                prod.setIdProducto(Integer.parseInt(idStr));
                productoDAO.actualizar(prod);
            }

            resp.sendRedirect(req.getContextPath() + "/productos");
        } catch (Exception e) {
            req.setAttribute("error", "Error al procesar el producto: " + e.getMessage());
            doGet(req, resp);
        }
    }
}