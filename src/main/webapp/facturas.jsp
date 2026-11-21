<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.Factura" %>
<%
    List<Factura> facturas = (List<Factura>) request.getAttribute("facturas");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    String mensajeExito = (String) session.getAttribute("mensajeExito");
    String mensajeError = (String) session.getAttribute("mensajeError");
    session.removeAttribute("mensajeExito");
    session.removeAttribute("mensajeError");
%>

<div>
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

    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h4 class="fw-bold text-white mb-1">Historial de Facturación</h4>
            <span class="text-white opacity-75 small">Registro general de ventas, comprobantes y control de estado</span>
        </div>
        <a href="<%= request.getContextPath() %>/despacho" class="btn btn-primary fw-semibold px-3">
            + Nueva Venta
        </a>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-dark text-white fw-bold py-2">
            Comprobantes Emitidos
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead>
                    <tr>
                        <th style="width: 130px;">No. Factura</th>
                        <th style="width: 150px;">Fecha y Hora</th>
                        <th class="text-start">Cliente</th>
                        <th>Cajero</th>
                        <th>Forma Pago</th>
                        <th class="text-end" style="width: 130px;">Total</th>
                        <th style="width: 110px;">Estado</th>
                        <th style="width: 140px;">Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (facturas == null || facturas.isEmpty()) { %>
                    <tr>
                        <td colspan="8" class="py-4 text-white opacity-75">Sin facturas emitidas.</td>
                    </tr>
                    <% } else {
                        for (Factura f : facturas) {
                            boolean esEmitida = "Emitida".equalsIgnoreCase(f.getEstado());
                    %>
                    <tr>
                        <td class="fw-bold text-info"><%= f.getNumeroFactura() %></td>
                        <td class="text-white small"><%= f.getFechaFactura() != null ? sdf.format(f.getFechaFactura()) : "-" %></td>
                        <td class="text-start text-white">
                            <div class="fw-semibold"><%= f.getNombreCliente() %></div>
                            <small class="text-white opacity-75">NIT: <%= f.getNitCliente() %></small>
                        </td>
                        <td class="text-white"><%= f.getNombreCajero() %></td>
                        <td><span class="badge bg-secondary"><%= f.getDescripcionFormaPago() %></span></td>
                        <td class="text-end fw-bold text-success">Q <%= String.format(java.util.Locale.US, "%.2f", f.getTotalVenta()) %></td>
                        <td>
                            <span class="badge <%= esEmitida ? "bg-success" : "bg-danger" %>">
                                <%= f.getEstado() %>
                            </span>
                        </td>
                        <td>
                            <% if (esEmitida) { %>
                            <a href="<%= request.getContextPath() %>/facturas?accion=anular&id=<%= f.getIdFactura() %>"
                               class="btn btn-sm btn-outline-danger py-0 px-2"
                               onclick="return confirm('¿Está seguro de anular la factura <%= f.getNumeroFactura() %>?');">
                                Anular
                            </a>
                            <% } else { %>
                            <span class="badge bg-secondary opacity-75">Anulada</span>
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