<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.Producto" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.Categoria" %>
<%
    List<Producto> lista = (List<Producto>) request.getAttribute("productos");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
    Producto prodEditar = (Producto) request.getAttribute("productoEditar");
    boolean esEdicion = (prodEditar != null);
    String error = (String) request.getAttribute("error");
%>

<div>
    <% if (error != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= error %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="card shadow-sm mb-4">
        <div class="card-header <%= esEdicion ? "bg-warning text-dark" : "bg-primary text-white" %> fw-bold py-2 text-center text-md-start">
            <%= esEdicion ? "Modificando Producto #" + prodEditar.getIdProducto() : "Ingresar Producto" %>
        </div>
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/productos" method="post">
                <input type="hidden" name="idProducto" value="<%= esEdicion ? prodEditar.getIdProducto() : 0 %>">

                <div class="row g-3 mb-3">
                    <div class="col-md-3">
                        <label class="form-label fw-bold text-white">Categoría</label>
                        <select class="form-select" name="idCategoria" required>
                            <option value="">-- Seleccionar --</option>
                            <% if (categorias != null) {
                                for (Categoria cat : categorias) { %>
                            <option value="<%= cat.getIdCategoria() %>"
                                    <%= (esEdicion && cat.getIdCategoria() == prodEditar.getIdCategoria()) ? "selected" : "" %>>
                                <%= cat.getNombreCategoria() %>
                            </option>
                            <%  }
                            } %>
                        </select>
                    </div>

                    <div class="col-md-5">
                        <label class="form-label fw-bold text-white">Nombre</label>
                        <input type="text" class="form-control" name="nombreProducto"
                               value="<%= esEdicion ? prodEditar.getNombreProducto() : "" %>"
                               placeholder="" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Descripción</label>
                        <input type="text" class="form-control" name="descripcion"
                               value="<%= (esEdicion && prodEditar.getDescripcion() != null) ? prodEditar.getDescripcion() : "" %>"
                               placeholder="Detalles / Presentación">
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <label class="form-label fw-bold text-white">Código de Barras</label>
                        <input type="text" class="form-control" name="codigoBarras"
                               value="<%= (esEdicion && prodEditar.getCodigoBarras() != null) ? prodEditar.getCodigoBarras() : "" %>"
                               placeholder="Opcional">
                    </div>

                    <div class="col-md-2">
                        <label class="form-label fw-bold text-white">Costo Q</label>
                        <input type="number" step="0.01" class="form-control" name="precioCosto"
                               value="<%= esEdicion ? prodEditar.getPrecioCosto() : "0.00" %>" min="0" required>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label fw-bold text-white">Precio Venta Q</label>
                        <input type="number" step="0.01" class="form-control" name="precioVenta"
                               value="<%= esEdicion ? prodEditar.getPrecioVenta() : "0.00" %>" min="0" required>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label fw-bold text-white">Ingreso</label>
                        <input type="number" class="form-control" name="stockActual"
                               value="<%= esEdicion ? prodEditar.getStockActual() : "0" %>" min="0" required>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-bold text-white">Stock Mínimo</label>
                        <input type="number" class="form-control" name="stockMinimo"
                               value="<%= esEdicion ? prodEditar.getStockMinimo() : "5" %>" min="1" required>
                    </div>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn <%= esEdicion ? "btn-warning" : "btn-primary" %> px-5 py-2 fw-semibold">
                        <%= esEdicion ? "Actualizar Producto" : "Guardar Producto" %>
                    </button>
                    <% if (esEdicion) { %>
                    <a href="<%= request.getContextPath() %>/productos" class="btn btn-secondary ms-2 py-2">Cancelar Edición</a>
                    <% } %>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-dark text-white fw-bold py-2">
            Historial de ingresos
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead>
                    <tr>
                        <th style="width: 80px;">ID</th>
                        <th class="text-start">Nombre de Producto</th>
                        <th>Categoría</th>
                        <th style="width: 150px;">Stock Ingresado</th>
                        <th style="width: 170px;">Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (lista == null || lista.isEmpty()) { %>
                    <tr>
                        <td colspan="5" class="py-4 text-white">Inventario Vacío.</td>
                    </tr>
                    <% } else {
                        for (Producto p : lista) { %>
                    <tr>
                        <td><strong class="text-white">#<%= p.getIdProducto() %></strong></td>
                        <td class="text-start fw-semibold text-white">
                            <%= p.getNombreProducto() %>
                            <% if (p.getDescripcion() != null && !p.getDescripcion().trim().isEmpty()) { %>
                            <small class="d-block text-white opacity-75" style="font-size: 0.78rem;">
                                <%= p.getDescripcion() %>
                            </small>
                            <% } %>
                        </td>
                        <td><span class="badge bg-secondary"><%= p.getNombreCategoria() %></span></td>
                        <td>
                                        <span class="badge <%= (p.getStockActual() <= p.getStockMinimo()) ? "bg-danger" : "bg-success" %> px-3 py-2">
                                            <%= p.getStockActual() %>
                                        </span>
                        </td>
                        <td>
                            <a href="<%= request.getContextPath() %>/productos?accion=editar&id=<%= p.getIdProducto() %>"
                               class="btn btn-sm btn-outline-secondary me-1">
                                Editar
                            </a>
                            <a href="<%= request.getContextPath() %>/productos?accion=eliminar&id=<%= p.getIdProducto() %>"
                               class="btn btn-sm btn-outline-danger"
                               onclick="return confirm('¿Está seguro de desactivar este producto?');">
                                Desactivar
                            </a>
                        </td>
                    </tr>
                    <%  }
                    } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>