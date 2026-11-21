<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.*" %>
<%
    List<Proveedor> proveedores = (List<Proveedor>) request.getAttribute("proveedores");
    List<Producto> productos = (List<Producto>) request.getAttribute("productos");
    List<ItemCarritoCompra> carrito = (List<ItemCarritoCompra>) session.getAttribute("carritoCompras");
    List<Compra> historial = (List<Compra>) request.getAttribute("historialCompras");
    Double totalCompra = (Double) request.getAttribute("totalCompra");
    if (totalCompra == null) totalCompra = 0.0;

    String error = (String) request.getAttribute("error");
    String mensajeExito = (String) session.getAttribute("mensajeExito");
    session.removeAttribute("mensajeExito");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
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

    <div class="row g-4 mb-4">
        <div class="col-lg-7">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-primary text-white fw-bold py-2">
                    Agregar Productos al Inventario
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/compras" method="post" class="row g-3">
                        <input type="hidden" name="accion" value="agregar">

                        <div class="col-md-12">
                            <label class="form-label fw-bold text-white">Producto</label>
                            <select class="form-select" name="idProducto" id="cboProductoCompra" required>
                                <option value="" data-costo="" data-venta="">-- Seleccionar Producto a Reabastecer --</option>
                                <% if (productos != null) {
                                    for (Producto p : productos) { %>
                                <option value="<%= p.getIdProducto() %>"
                                        data-costo="<%= String.format(java.util.Locale.US, "%.2f", p.getPrecioCosto()) %>"
                                        data-venta="<%= String.format(java.util.Locale.US, "%.2f", p.getPrecioVenta()) %>">
                                    <%= p.getNombreProducto() %> (Stock Actual: <%= p.getStockActual() %>)
                                </option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold text-white small">Costo Compra Q</label>
                            <input type="number" step="0.01" class="form-control" name="costoUnitario" id="txtCostoUnitario" min="0.01" placeholder="0.00" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold text-info small">Precio Venta Q</label>
                            <input type="number" step="0.01" class="form-control" name="precioVenta" id="txtPrecioVenta" min="0.01" placeholder="0.00" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold text-white small">Cantidad Ingreso</label>
                            <input type="number" class="form-control" name="cantidad" min="1" value="10" required>
                        </div>

                        <div class="col-12 text-end">
                            <button type="submit" class="btn btn-primary px-4 fw-semibold">+ Agregar al Lote</button>
                        </div>
                    </form>

                    <hr class="my-3" style="border-color: #28354f;">

                    <div class="table-responsive">
                        <table class="table table-sm align-middle text-center mb-0">
                            <thead>
                            <tr>
                                <th class="text-start">Producto</th>
                                <th style="width: 65px;">Cant.</th>
                                <th style="width: 95px;">Costo U.</th>
                                <th style="width: 95px;">P. Venta</th>
                                <th style="width: 105px;">Subtotal</th>
                                <th style="width: 45px;"></th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if (carrito == null || carrito.isEmpty()) { %>
                            <tr>
                                <td colspan="6" class="py-3 text-white opacity-75">No hay productos agregados para la compra.</td>
                            </tr>
                            <% } else {
                                for (ItemCarritoCompra item : carrito) { %>
                            <tr>
                                <td class="text-start text-white"><%= item.getNombreProducto() %></td>
                                <td class="text-white"><%= item.getCantidad() %></td>
                                <td class="text-white">Q <%= String.format(java.util.Locale.US, "%.2f", item.getCostoUnitario()) %></td>
                                <td class="text-info">Q <%= String.format(java.util.Locale.US, "%.2f", item.getPrecioVenta()) %></td>
                                <td class="fw-bold text-success">Q <%= String.format(java.util.Locale.US, "%.2f", item.getSubtotal()) %></td>
                                <td>
                                    <form action="<%= request.getContextPath() %>/compras" method="post" class="d-inline">
                                        <input type="hidden" name="accion" value="eliminar">
                                        <input type="hidden" name="idProducto" value="<%= item.getIdProducto() %>">
                                        <button type="submit" class="btn btn-outline-danger btn-sm py-0 px-2 fw-bold">&times;</button>
                                    </form>
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

        <div class="col-lg-5">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-dark text-white fw-bold py-2">
                    Liquidación y Factura Proveedor
                </div>
                <div class="card-body d-flex flex-column justify-content-between">
                    <form action="<%= request.getContextPath() %>/compras" method="post">
                        <input type="hidden" name="accion" value="guardarCompra">

                        <div class="text-center py-2 mb-3">
                            <span class="text-white fw-bold small text-uppercase d-block mb-1 opacity-75">Total de Compra</span>
                            <h2 class="fw-bold text-success mb-0">Q <%= String.format(java.util.Locale.US, "%.2f", totalCompra) %></h2>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-white">Proveedor Emisor</label>
                            <select class="form-select" name="idProveedor" required>
                                <option value="">-- Seleccionar Proveedor --</option>
                                <% if (proveedores != null) {
                                    for (Proveedor prov : proveedores) { %>
                                <option value="<%= prov.getIdProveedor() %>">
                                    <%= prov.getNombreProveedor() %> (NIT: <%= prov.getNit() != null ? prov.getNit() : "C/F" %>)
                                </option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-white">No. Factura / Serie del Proveedor</label>
                            <input type="text" class="form-control" name="numeroFacturaProveedor" placeholder="Ej: FAC-A-89412">
                        </div>

                        <button type="submit" class="btn btn-success btn-lg w-100 py-2 fw-semibold" <%= (totalCompra <= 0) ? "disabled" : "" %>>
                            Procesar Ingreso a Bodega
                        </button>
                    </form>
                    <small class="text-white opacity-75 text-center mt-3 d-block">
                        Al procesar, se aumentará el stock y se actualizarán el costo y precio de venta.
                    </small>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-secondary text-white fw-bold py-2">
            Historial de Compras y Reabastecimientos
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead>
                    <tr>
                        <th style="width: 80px;">ID</th>
                        <th class="text-start">Proveedor</th>
                        <th>No. Factura Proveedor</th>
                        <th>Fecha y Hora</th>
                        <th>Registrado Por</th>
                        <th class="text-end" style="width: 140px;">Total Compra</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (historial == null || historial.isEmpty()) { %>
                    <tr>
                        <td colspan="6" class="py-4 text-white opacity-75">No hay compras registradas en el sistema.</td>
                    </tr>
                    <% } else {
                        for (Compra c : historial) { %>
                    <tr>
                        <td><strong class="text-white">#<%= c.getIdCompra() %></strong></td>
                        <td class="fw-semibold text-start text-white"><%= c.getNombreProveedor() %></td>
                        <td class="text-white"><%= c.getNumeroFacturaProveedor() != null ? c.getNumeroFacturaProveedor() : "-" %></td>
                        <td class="text-white small"><%= c.getFechaCompra() != null ? sdf.format(c.getFechaCompra()) : "-" %></td>
                        <td class="text-white"><%= c.getNombreUsuario() %></td>
                        <td class="text-end fw-bold text-success">Q <%= String.format(java.util.Locale.US, "%.2f", c.getTotalCompra()) %></td>
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
    const cboProducto = document.getElementById('cboProductoCompra');
    const txtCosto = document.getElementById('txtCostoUnitario');
    const txtVenta = document.getElementById('txtPrecioVenta');

    cboProducto.addEventListener('change', function() {
        const opt = this.options[this.selectedIndex];
        if (opt && opt.value) {
            txtCosto.value = opt.getAttribute('data-costo') || '';
            txtVenta.value = opt.getAttribute('data-venta') || '';
        } else {
            txtCosto.value = '';
            txtVenta.value = '';
        }
    });
</script>