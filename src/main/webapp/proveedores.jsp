<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.Proveedor" %>
<%
    List<Proveedor> lista = (List<Proveedor>) request.getAttribute("proveedores");
    Proveedor provEditar = (Proveedor) request.getAttribute("proveedorEditar");
    boolean esEdicion = (provEditar != null);

    String error = (String) request.getAttribute("error");
    String mensajeError = (String) session.getAttribute("mensajeError");
    session.removeAttribute("mensajeError");
%>

<div>
    <% if (error != null) { %>
    <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
        <%= error %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (mensajeError != null) { %>
    <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
        <%= mensajeError %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="card shadow-sm mb-4">
        <div class="card-header <%= esEdicion ? "bg-warning text-dark" : "bg-primary text-white" %> fw-bold py-2">
            <%= esEdicion ? "Modificando Proveedor #" + provEditar.getIdProveedor() : "Registrar Nuevo Proveedor" %>
        </div>
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/proveedores" method="post">
                <input type="hidden" name="idProveedor" value="<%= esEdicion ? provEditar.getIdProveedor() : 0 %>">

                <div class="row g-3 mb-3">
                    <div class="col-md-3">
                        <label class="form-label fw-bold text-white">NIT</label>
                        <input type="text" class="form-control" name="nit"
                               value="<%= (esEdicion && provEditar.getNit() != null) ? provEditar.getNit() : "" %>"
                               placeholder="Campo Obligatorio">
                    </div>

                    <div class="col-md-5">
                        <label class="form-label fw-bold text-white">Nombre de la Empresa / Proveedor</label>
                        <input type="text" class="form-control" name="nombreProveedor"
                               value="<%= esEdicion ? provEditar.getNombreProveedor() : "" %>" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Persona de Contacto</label>
                        <input type="text" class="form-control" name="contacto"
                               value="<%= (esEdicion && provEditar.getContacto() != null) ? provEditar.getContacto() : "" %>">
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Teléfono</label>
                        <input type="text" class="form-control" name="telefono"
                               value="<%= (esEdicion && provEditar.getTelefono() != null) ? provEditar.getTelefono() : "" %>">
                    </div>

                    <div class="col-md-8">
                        <label class="form-label fw-bold text-white">Dirección</label>
                        <input type="text" class="form-control" name="direccion"
                               value="<%= (esEdicion && provEditar.getDireccion() != null) ? provEditar.getDireccion() : "" %>">
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn <%= esEdicion ? "btn-warning text-dark fw-bold" : "btn-primary fw-semibold" %> px-4">
                        <%= esEdicion ? "Actualizar Cambios" : "Guardar Proveedor" %>
                    </button>
                    <% if (esEdicion) { %>
                    <a href="<%= request.getContextPath() %>/proveedores" class="btn btn-secondary px-4">Cancelar Edición</a>
                    <% } %>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-dark text-white fw-bold py-2">
            Listado de Proveedores Registrados
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead>
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th class="text-start">Empresa / Proveedor</th>
                        <th>NIT</th>
                        <th>Contacto</th>
                        <th>Teléfono</th>
                        <th class="text-start">Dirección</th>
                        <th style="width: 160px;">Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (lista == null || lista.isEmpty()) { %>
                    <tr>
                        <td colspan="7" class="py-4 text-white opacity-75">No hay proveedores registrados.</td>
                    </tr>
                    <% } else {
                        for (Proveedor prov : lista) { %>
                    <tr>
                        <td><strong class="text-white">#<%= prov.getIdProveedor() %></strong></td>
                        <td class="fw-semibold text-start text-white"><%= prov.getNombreProveedor() %></td>
                        <td><span class="badge bg-secondary"><%= prov.getNit() != null ? prov.getNit() : "C/F" %></span></td>
                        <td class="text-white"><%= prov.getContacto() != null ? prov.getContacto() : "-" %></td>
                        <td class="text-white"><%= prov.getTelefono() != null ? prov.getTelefono() : "-" %></td>
                        <td class="text-start text-white small"><%= prov.getDireccion() != null ? prov.getDireccion() : "-" %></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/proveedores?accion=editar&id=<%= prov.getIdProveedor() %>"
                               class="btn btn-sm btn-outline-info py-0 px-2 me-1">
                                Editar
                            </a>
                            <a href="<%= request.getContextPath() %>/proveedores?accion=eliminar&id=<%= prov.getIdProveedor() %>"
                               class="btn btn-sm btn-outline-danger py-0 px-2"
                               onclick="return confirm('¿Está seguro de eliminar a este proveedor?');">
                                Eliminar
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