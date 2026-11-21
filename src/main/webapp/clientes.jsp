<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.Cliente" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.Usuario" %>
<%
    List<Cliente> lista = (List<Cliente>) request.getAttribute("clientes");
    Cliente cEditar = (Cliente) request.getAttribute("clienteEditar");
    boolean esEdicion = (cEditar != null);

    String error = (String) request.getAttribute("error");
    String mensajeExito = (String) session.getAttribute("mensajeExito");
    String mensajeError = (String) session.getAttribute("mensajeError");
    session.removeAttribute("mensajeExito");
    session.removeAttribute("mensajeError");
%>

<div>
    <% if (error != null) { %>
    <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
        <%= error %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (mensajeExito != null) { %>
    <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
        <%= mensajeExito %>
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
            <%= esEdicion ? "Modificando Cliente #" + cEditar.getIdCliente() : "Registrar Nuevo Cliente" %>
        </div>
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/clientes" method="post">
                <input type="hidden" name="idCliente" value="<%= esEdicion ? cEditar.getIdCliente() : 0 %>">

                <div class="row g-3 mb-3">
                    <div class="col-md-3">
                        <label class="form-label fw-bold text-white">NIT</label>
                        <input type="text" class="form-control" name="nit"
                               value="<%= (esEdicion && cEditar.getNit() != null) ? cEditar.getNit() : "" %>"
                               placeholder="CF" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Nombres</label>
                        <input type="text" class="form-control" name="nombres"
                               value="<%= esEdicion ? cEditar.getNombres() : "" %>" required>
                    </div>

                    <div class="col-md-5">
                        <label class="form-label fw-bold text-white">Apellidos</label>
                        <input type="text" class="form-control" name="apellidos"
                               value="<%= esEdicion ? cEditar.getApellidos() : "" %>" required>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <label class="form-label fw-bold text-white">Teléfono</label>
                        <input type="text" class="form-control" name="telefono"
                               value="<%= (esEdicion && cEditar.getTelefono() != null) ? cEditar.getTelefono() : "" %>"
                               placeholder="Opcional">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Correo Electrónico</label>
                        <input type="email" class="form-control" name="correoElectronico"
                               value="<%= (esEdicion && cEditar.getCorreoElectronico() != null) ? cEditar.getCorreoElectronico() : "" %>"
                               placeholder="Opcional">
                    </div>

                    <div class="col-md-5">
                        <label class="form-label fw-bold text-white">Dirección</label>
                        <input type="text" class="form-control" name="direccion"
                               value="<%= (esEdicion && cEditar.getDireccion() != null) ? cEditar.getDireccion() : "" %>"
                               placeholder="Ciudad">
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn <%= esEdicion ? "btn-warning text-dark fw-bold" : "btn-primary fw-semibold" %> px-4">
                        <%= esEdicion ? "Actualizar Cliente" : "Guardar Cliente" %>
                    </button>
                    <% if (esEdicion) { %>
                    <a href="<%= request.getContextPath() %>/clientes" class="btn btn-secondary px-4">Cancelar Edición</a>
                    <% } %>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-dark text-white fw-bold py-2">
            Listado de Clientes
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead>
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th class="text-start">Cliente</th>
                        <th>NIT</th>
                        <th>Teléfono</th>
                        <th>Correo Electrónico</th>
                        <th class="text-start">Dirección</th>
                        <th style="width: 170px;">Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (lista == null || lista.isEmpty()) { %>
                    <tr>
                        <td colspan="7" class="py-4 text-white">No hay clientes registrados en el sistema.</td>
                    </tr>
                    <% } else {
                        for (Cliente c : lista) { %>
                    <tr>
                        <td><strong class="text-white">#<%= c.getIdCliente() %></strong></td>
                        <td class="text-start fw-semibold text-white"><%= c.getNombreCompleto() %></td>
                        <td><span class="badge bg-secondary"><%= c.getNit() %></span></td>
                        <td class="text-white"><%= c.getTelefono() != null ? c.getTelefono() : "-" %></td>
                        <td class="text-white small"><%= c.getCorreoElectronico() != null ? c.getCorreoElectronico() : "-" %></td>
                        <td class="text-start text-white small"><%= c.getDireccion() != null ? c.getDireccion() : "-" %></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/clientes?accion=editar&id=<%= c.getIdCliente() %>"
                               class="btn btn-sm btn-outline-info me-1 py-0 px-2">
                                Editar
                            </a>
                            <% if (c.getIdCliente() != 1) { %>
                            <a href="<%= request.getContextPath() %>/clientes?accion=eliminar&id=<%= c.getIdCliente() %>"
                               class="btn btn-sm btn-outline-danger py-0 px-2"
                               onclick="return confirm('¿Está seguro de eliminar a este cliente?');">
                                Eliminar
                            </a>
                            <% } else { %>
                            <button class="btn btn-sm btn-outline-secondary py-0 px-2" disabled title="Consumidor Final es fijo">Fijo</button>
                            <% } %>
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