<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.*" %>
<%
    List<Devolucion> devoluciones = (List<Devolucion>) request.getAttribute("devoluciones");
    List<Producto> productos = (List<Producto>) request.getAttribute("productos");
    List<Factura> facturas = (List<Factura>) request.getAttribute("facturas");

    String mensajeExito = (String) session.getAttribute("mensajeExito");
    String mensajeError = (String) session.getAttribute("mensajeError");
    session.removeAttribute("mensajeExito");
    session.removeAttribute("mensajeError");

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
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

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-danger text-white fw-bold py-2">
            Registrar Devolución de Producto
        </div>
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/devoluciones" method="post">
                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">No. Factura de Origen (Opcional)</label>
                        <select class="form-select" name="idFactura">
                            <option value="0">-- Sin Factura Asociada --</option>
                            <% if (facturas != null) {
                                for (Factura f : facturas) { %>
                            <option value="<%= f.getIdFactura() %>">
                                <%= f.getNumeroFactura() %> - <%= f.getNombreCliente() %>
                            </option>
                            <%  }
                            } %>
                        </select>
                    </div>

                    <div class="col-md-5">
                        <label class="form-label fw-bold text-white">Producto</label>
                        <select class="form-select" name="idProducto" id="cboProducto" required>
                            <option value="" data-precio="0">-- Seleccionar Producto Devuelto --</option>
                            <% if (productos != null) {
                                for (Producto p : productos) { %>
                            <option value="<%= p.getIdProducto() %>" data-precio="<%= p.getPrecioVenta() %>">
                                <%= p.getNombreProducto() %> (P. Venta: Q <%= String.format(java.util.Locale.US, "%.2f", p.getPrecioVenta()) %>)
                            </option>
                            <%  }
                            } %>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-bold text-white">Motivo</label>
                        <select class="form-select" name="motivo" required>
                            <option value="Producto Dañado">Producto Dañado</option>
                            <option value="Vencimiento">Vencimiento</option>
                        </select>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <label class="form-label fw-bold text-white">Cantidad Devuelta</label>
                        <input type="number" class="form-control" name="cantidadDevuelta" id="txtCantidad" min="1" value="1" required>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-bold text-white">Monto Reembolsado (Q)</label>
                        <input type="number" step="0.01" class="form-control fw-bold text-danger" name="montoReembolsado" id="txtMonto" min="0" value="0.00" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold text-white">Observaciones / Detalle del Daño</label>
                        <input type="text" class="form-control" name="observaciones" placeholder="Empaque roto, fecha caducada al recibir, etc">
                    </div>
                </div>

                <button type="submit" class="btn btn-danger px-4 fw-semibold">
                    Registrar Devolución
                </button>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-dark text-white fw-bold py-2">
            Historial de Devoluciones Registradas
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead>
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th>Fecha y Hora</th>
                        <th>Factura</th>
                        <th class="text-start">Producto Devuelto</th>
                        <th>Cant.</th>
                        <th>Motivo</th>
                        <th class="text-end" style="width: 130px;">Reembolso</th>
                        <th>Atendido Por</th>
                        <th class="text-start">Observaciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (devoluciones == null || devoluciones.isEmpty()) { %>
                    <tr>
                        <td colspan="9" class="py-4 text-white opacity-75">No hay registros de devoluciones en el sistema.</td>
                    </tr>
                    <% } else {
                        for (Devolucion d : devoluciones) { %>
                    <tr>
                        <td><strong class="text-white">#<%= d.getIdDevolucion() %></strong></td>
                        <td class="text-white small"><%= d.getFechaDevolucion() != null ? sdf.format(d.getFechaDevolucion()) : "-" %></td>
                        <td>
                            <%= d.getNumeroFactura() != null ? "<span class='badge bg-primary'>" + d.getNumeroFactura() + "</span>" : "<span class='text-white opacity-75'>-</span>" %>
                        </td>
                        <td class="text-start fw-semibold text-white"><%= d.getNombreProducto() %></td>
                        <td><span class="badge bg-secondary"><%= d.getCantidadDevuelta() %></span></td>
                        <td>
                            <span class="badge <%= "Vencimiento".equals(d.getMotivo()) ? "bg-warning text-dark" : "bg-danger" %>">
                                <%= d.getMotivo() %>
                            </span>
                        </td>
                        <td class="text-end fw-bold text-danger">Q <%= String.format(java.util.Locale.US, "%.2f", d.getMontoReembolsado()) %></td>
                        <td class="text-white"><%= d.getNombreUsuario() %></td>
                        <td class="text-start small text-white"><%= d.getObservaciones() != null ? d.getObservaciones() : "-" %></td>
                    </tr>
                    <%  }
                    } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    const cboProducto = document.getElementById('cboProducto');
    const txtCantidad = document.getElementById('txtCantidad');
    const txtMonto = document.getElementById('txtMonto');

    function autocalcularMonto() {
        const opt = cboProducto.options[cboProducto.selectedIndex];
        const precio = parseFloat(opt ? opt.getAttribute('data-precio') : 0) || 0;
        const cant = parseInt(txtCantidad.value) || 0;
        txtMonto.value = (precio * cant).toFixed(2);
    }

    cboProducto.addEventListener('change', autocalcularMonto);
    txtCantidad.addEventListener('input', autocalcularMonto);
</script>