<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.dao.ReporteDAO.*" %>
<%
    String tab = (String) request.getAttribute("tabActivo");
    if (tab == null) tab = "cierre";
    String fecha = (String) request.getAttribute("fechaSeleccionada");

    List<FilaFacturaDia> facturasDia = (List<FilaFacturaDia>) request.getAttribute("facturasDia");
    List<FilaProductoVendidoDia> productosVendidosDia = (List<FilaProductoVendidoDia>) request.getAttribute("productosVendidosDia");
    List<FilaDevolucionRep> listaDevoluciones = (List<FilaDevolucionRep>) request.getAttribute("listaDevoluciones");
    List<FilaClienteRep> listaClientes = (List<FilaClienteRep>) request.getAttribute("listaClientes");
    List<FilaCompraRep> listaCompras = (List<FilaCompraRep>) request.getAttribute("listaCompras");
%>

<style>
    .kpi-card {
        background-color: #121b2d;
        border: 1px solid #1f2d48;
        border-radius: 10px;
        padding: 16px 20px;
        position: relative;
        overflow: hidden;
    }
    .kpi-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 4px;
        height: 100%;
    }
    .kpi-primary::before { background-color: #00d2ff; }
    .kpi-success::before { background-color: #10b981; }
    .kpi-warning::before { background-color: #f59e0b; }
    .kpi-danger::before { background-color: #ef4444; }

    .analytics-table th {
        background-color: #101726 !important;
        color: #94a3b8 !important;
        font-size: 0.78rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        border-bottom: 2px solid #28354f !important;
        padding: 12px 14px !important;
    }
    .analytics-table td {
        border-bottom: 1px solid #1a2438 !important;
        padding: 12px 14px !important;
        color: #e2e8f0;
    }
    .analytics-table tfoot th, .analytics-table tfoot td {
        background-color: #101726 !important;
        border-top: 2px solid #28354f !important;
        font-weight: 700;
    }
    .nav-analytics .nav-link {
        color: #94a3b8;
        font-weight: 600;
        border-radius: 6px;
        padding: 8px 18px;
        border: 1px solid transparent;
        transition: all 0.2s ease;
    }
    .nav-analytics .nav-link:hover {
        color: #ffffff;
        background-color: #152035;
    }
    .nav-analytics .nav-link.active {
        color: #00d2ff !important;
        background-color: #17243c;
        border-color: #00d2ff;
    }
</style>

<div>
    <div class="d-flex flex-wrap justify-content-between align-items-center pb-3 mb-4 border-bottom" style="border-color: #1e293b !important;">
        <ul class="nav nav-analytics gap-2">
            <li class="nav-item">
                <a class="nav-link <%= "cierre".equals(tab) ? "active" : "" %>" href="<%= request.getContextPath() %>/reportes?tab=cierre">
                    Balance de Ventas
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "devoluciones".equals(tab) ? "active" : "" %>" href="<%= request.getContextPath() %>/reportes?tab=devoluciones">
                    Devoluciones
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "clientes".equals(tab) ? "active" : "" %>" href="<%= request.getContextPath() %>/reportes?tab=clientes">
                    Cartera de Clientes
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "compras".equals(tab) ? "active" : "" %>" href="<%= request.getContextPath() %>/reportes?tab=compras">
                    Inversión en Existencias
                </a>
            </li>
        </ul>

        <% if ("cierre".equals(tab)) { %>
        <form action="<%= request.getContextPath() %>/reportes" method="get" class="d-flex align-items-center gap-2">
            <input type="hidden" name="tab" value="cierre">
            <label class="text-white small fw-bold opacity-75">Fecha de Auditoría:</label>
            <input type="date" name="fecha" value="<%= fecha %>" class="form-control form-control-sm text-white"
                   style="background-color: #151c2c; border-color: #28354f;" onchange="this.form.submit()">
        </form>
        <% } %>
    </div>

    <% if ("cierre".equals(tab)) {
        double totalGeneral = 0.0;
        int totalTransacciones = 0;
        if (facturasDia != null) {
            for (FilaFacturaDia f : facturasDia) {
                if ("Emitida".equalsIgnoreCase(f.getEstado())) {
                    totalGeneral += f.getTotal();
                    totalTransacciones++;
                }
            }
        }
    %>
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="kpi-card kpi-success">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Ingresos Netos Totales</span>
                <h3 class="fw-bold text-success mb-1 mt-1">Q <%= String.format(Locale.US, "%,.2f", totalGeneral) %></h3>
                <small class="text-white opacity-50">Venta facturada del día</small>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card kpi-primary">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Transacciones Totales</span>
                <h3 class="fw-bold text-info mb-1 mt-1"><%= totalTransacciones %></h3>
                <small class="text-white opacity-50">Facturas emitidas procesadas</small>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card kpi-primary">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Fecha Auditada</span>
                <h4 class="fw-bold text-white mb-1 mt-1"><%= fecha %></h4>
                <small class="text-info fw-semibold">Corte diario de caja</small>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-5">
            <div class="card shadow-sm h-100" style="background-color: #0f1728; border: 1px solid #1f2d48;">
                <div class="card-header bg-transparent text-white fw-bold py-3 border-bottom d-flex justify-content-between align-items-center" style="border-color: #1f2d48 !important;">
                    <span>Productos Vendidos en el Día</span>
                    <span class="badge bg-secondary"><%= productosVendidosDia != null ? productosVendidosDia.size() : 0 %> Ítems</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table analytics-table align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="text-start">Nombre del Producto</th>
                                <th class="text-center" style="width: 130px;">Stock Vendido</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                int totalUnidadesVendidas = 0;
                                if (productosVendidosDia == null || productosVendidosDia.isEmpty()) { %>
                            <tr><td colspan="2" class="py-4 text-center text-white opacity-50">No hubo salida de productos en esta fecha.</td></tr>
                            <% } else {
                                for (FilaProductoVendidoDia pv : productosVendidosDia) {
                                    totalUnidadesVendidas += pv.getTotalVendido();
                            %>
                            <tr>
                                <td class="text-start fw-semibold text-white"><%= pv.getNombreProducto() %></td>
                                <td class="text-center"><span class="badge bg-info text-dark fw-bold fs-6"><%= pv.getTotalVendido() %></span></td>
                            </tr>
                            <%  }
                            } %>
                            </tbody>
                            <% if (productosVendidosDia != null && !productosVendidosDia.isEmpty()) { %>
                            <tfoot>
                            <tr>
                                <th class="text-start text-white">TOTAL STOCK VENDIDO</th>
                                <th class="text-center text-info fs-6"><%= totalUnidadesVendidas %> uds</th>
                            </tr>
                            </tfoot>
                            <% } %>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="card shadow-sm h-100" style="background-color: #0f1728; border: 1px solid #1f2d48;">
                <div class="card-header bg-transparent text-white fw-bold py-3 border-bottom" style="border-color: #1f2d48 !important;">
                    Registro Transaccional de Facturación
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table analytics-table align-middle text-center mb-0">
                            <thead>
                            <tr>
                                <th>Factura</th>
                                <th>Hora</th>
                                <th class="text-start">Cliente</th>
                                <th>Método</th>
                                <th class="text-end">Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if (facturasDia == null || facturasDia.isEmpty()) { %>
                            <tr><td colspan="5" class="py-4 text-white opacity-50">No hay facturas registradas en esta fecha.</td></tr>
                            <% } else {
                                for (FilaFacturaDia f : facturasDia) { %>
                            <tr>
                                <td class="fw-bold text-info"><%= f.getNumeroFactura() %></td>
                                <td class="text-white small opacity-75"><%= f.getFechaHora().length() > 16 ? f.getFechaHora().substring(11, 16) : f.getFechaHora() %></td>
                                <td class="text-start text-white"><%= f.getCliente() %></td>
                                <td><span class="badge" style="background-color: #1c273e; color: #38bdf8;"><%= f.getFormaPago() %></span></td>
                                <td class="text-end fw-bold text-success">Q <%= String.format(Locale.US, "%,.2f", f.getTotal()) %></td>
                            </tr>
                            <%  }
                            } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <% if ("devoluciones".equals(tab)) {
        double totalPerdidas = 0.0;
        int totalItemsDevueltos = 0;
        int mermasDanadas = 0;
        int mermasVencidas = 0;

        if (listaDevoluciones != null) {
            for (FilaDevolucionRep d : listaDevoluciones) {
                totalPerdidas += d.getMonto();
                totalItemsDevueltos += d.getCantidad();
                if ("Vencimiento".equalsIgnoreCase(d.getMotivo())) {
                    mermasVencidas += d.getCantidad();
                } else {
                    mermasDanadas += d.getCantidad();
                }
            }
        }
    %>
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="kpi-card kpi-danger">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Pérdida Financiera Neta</span>
                <h3 class="fw-bold text-danger mb-1 mt-1">Q <%= String.format(Locale.US, "%,.2f", totalPerdidas) %></h3>
                <small class="text-white opacity-50">Total reembolsado en caja</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="kpi-card kpi-warning">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Unidades Descartadas</span>
                <h3 class="fw-bold text-warning mb-1 mt-1"><%= totalItemsDevueltos %></h3>
                <small class="text-white opacity-50">Artículos retirados del stock</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="kpi-card kpi-primary">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Por Daño de Fábrica</span>
                <h3 class="fw-bold text-info mb-1 mt-1"><%= mermasDanadas %> <small class="fs-6 opacity-75">uds</small></h3>
                <small class="text-white opacity-50">Empaques rotos o defectos</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="kpi-card kpi-danger">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Por Vencimiento</span>
                <h3 class="fw-bold text-white mb-1 mt-1"><%= mermasVencidas %> <small class="fs-6 opacity-75">uds</small></h3>
                <small class="text-danger fw-semibold">Caducidad en anaquel</small>
            </div>
        </div>
    </div>

    <div class="card shadow-sm" style="background-color: #0f1728; border: 1px solid #1f2d48;">
        <div class="card-header bg-transparent text-white fw-bold py-3 border-bottom d-flex justify-content-between align-items-center" style="border-color: #1f2d48 !important;">
            <span>Auditoría de Devoluciones y Registro de Mermas</span>
            <span class="badge bg-secondary"><%= listaDevoluciones != null ? listaDevoluciones.size() : 0 %> Registros</span>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table analytics-table align-middle text-center mb-0">
                    <thead>
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th>Fecha y Hora</th>
                        <th>Doc. Factura</th>
                        <th class="text-start">Producto Devuelto</th>
                        <th>Cantidad</th>
                        <th>Motivo Clasificado</th>
                        <th>Responsable</th>
                        <th class="text-end" style="width: 140px;">Reembolso</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (listaDevoluciones == null || listaDevoluciones.isEmpty()) { %>
                    <tr><td colspan="8" class="py-4 text-white opacity-50">No hay devoluciones registradas en la base de datos.</td></tr>
                    <% } else {
                        for (FilaDevolucionRep d : listaDevoluciones) { %>
                    <tr>
                        <td><strong class="text-white opacity-75">#<%= d.getIdDevolucion() %></strong></td>
                        <td class="text-white small opacity-75"><%= d.getFechaHora() %></td>
                        <td><span class="badge" style="background-color: #182642; color: #38bdf8;"><%= d.getFacturaOrigen() %></span></td>
                        <td class="text-start fw-semibold text-white"><%= d.getProducto() %></td>
                        <td><span class="badge bg-secondary"><%= d.getCantidad() %></span></td>
                        <td>
                                            <span class="badge <%= "Vencimiento".equalsIgnoreCase(d.getMotivo()) ? "bg-warning text-dark fw-bold" : "bg-danger" %>">
                                                <%= d.getMotivo() %>
                                            </span>
                        </td>
                        <td class="text-white small"><%= d.getResponsable() %></td>
                        <td class="text-end fw-bold text-danger">Q <%= String.format(Locale.US, "%,.2f", d.getMonto()) %></td>
                    </tr>
                    <%  }
                    } %>
                    </tbody>
                    <tfoot>
                    <tr>
                        <th colspan="4" class="text-start text-white">TOTAL IMPACTO EN PÉRDIDAS</th>
                        <th class="text-center text-white"><%= totalItemsDevueltos %> uds</th>
                        <th colspan="2"></th>
                        <th class="text-end text-danger fs-6">Q <%= String.format(Locale.US, "%,.2f", totalPerdidas) %></th>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
    <% } %>

    <% if ("clientes".equals(tab)) {
        double totalCartera = 0.0;
        int clientesActivos = 0;
        String topCliente = "-";
        double maxConsumo = 0.0;

        if (listaClientes != null) {
            for (FilaClienteRep c : listaClientes) {
                totalCartera += c.getTotalConsumido();
                if (c.getTotalConsumido() > 0) clientesActivos++;
                if (c.getTotalConsumido() > maxConsumo) {
                    maxConsumo = c.getTotalConsumido();
                    topCliente = c.getNombreCompleto();
                }
            }
        }
    %>
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="kpi-card kpi-primary">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Base Total Padrón</span>
                <h3 class="fw-bold text-info mb-1 mt-1"><%= listaClientes != null ? listaClientes.size() : 0 %></h3>
                <small class="text-white opacity-50"><%= clientesActivos %> clientes con compras activas</small>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card kpi-success">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Facturación Acumulada</span>
                <h3 class="fw-bold text-success mb-1 mt-1">Q <%= String.format(Locale.US, "%,.2f", totalCartera) %></h3>
                <small class="text-white opacity-50">Consumo histórico de la cartera</small>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card kpi-primary">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Cliente Líder</span>
                <h5 class="fw-bold text-white mb-1 mt-2 text-truncate" title="<%= topCliente %>"><%= topCliente %></h5>
                <small class="text-info fw-semibold">Q <%= String.format(Locale.US, "%,.2f", maxConsumo) %> facturados</small>
            </div>
        </div>
    </div>

    <div class="card shadow-sm" style="background-color: #0f1728; border: 1px solid #1f2d48;">
        <div class="card-header bg-transparent text-white fw-bold py-3 border-bottom d-flex justify-content-between align-items-center" style="border-color: #1f2d48 !important;">
            <span>Padrón de Clientes y Fecha de Última Compra</span>
            <span class="badge bg-secondary"><%= listaClientes != null ? listaClientes.size() : 0 %> Clientes</span>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table analytics-table align-middle mb-0">
                    <thead>
                    <tr>
                        <th style="width: 140px;">NIT</th>
                        <th>Nombre Comercial / Cliente</th>
                        <th>Teléfono</th>
                        <th>Dirección</th>
                        <th class="text-center" style="width: 190px;">Última Compra</th>
                        <th class="text-end" style="width: 160px;">Consumo Total</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (listaClientes == null || listaClientes.isEmpty()) { %>
                    <tr><td colspan="6" class="py-4 text-center text-white opacity-50">No hay clientes registrados en el sistema.</td></tr>
                    <% } else {
                        for (FilaClienteRep c : listaClientes) { %>
                    <tr>
                        <td class="fw-bold text-info"><%= c.getNit() %></td>
                        <td class="fw-semibold text-white"><%= c.getNombreCompleto() %></td>
                        <td class="text-white small opacity-75">
                            <%= c.getTelefono() != null && !c.getTelefono().trim().isEmpty() ? c.getTelefono() : "-" %>
                        </td>
                        <td class="text-white small opacity-75">
                            <%= c.getDireccion() != null && !c.getDireccion().trim().isEmpty() ? c.getDireccion() : "-" %>
                        </td>
                        <td class="text-center">
                            <% if (c.getUltimaCompra() != null) { %>
                            <span class="badge" style="background-color: #1a253d; color: #38bdf8;">
                                                <%= c.getUltimaCompra() %>
                                            </span>
                            <% } else { %>
                            <span class="text-white opacity-50 small">Sin compras</span>
                            <% } %>
                        </td>
                        <td class="text-end fw-bold text-success">Q <%= String.format(Locale.US, "%,.2f", c.getTotalConsumido()) %></td>
                    </tr>
                    <%  }
                    } %>
                    </tbody>
                    <tfoot>
                    <tr>
                        <th colspan="5" class="text-start text-white">TOTAL HISTÓRICO CONSOLIDADO</th>
                        <th class="text-end text-success fs-6">Q <%= String.format(Locale.US, "%,.2f", totalCartera) %></th>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
    <% } %>

    <% if ("compras".equals(tab)) {
        double totalInversion = 0.0;
        int totalPiezasCompradas = 0;

        if (listaCompras != null) {
            for (FilaCompraRep cp : listaCompras) {
                totalInversion += cp.getSubtotal();
                totalPiezasCompradas += cp.getCantidad();
            }
        }
    %>
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="kpi-card kpi-success">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Inversión Total en Bodega</span>
                <h3 class="fw-bold text-success mb-1 mt-1">Q <%= String.format(Locale.US, "%,.2f", totalInversion) %></h3>
                <small class="text-white opacity-50">Desembolso acumulado a proveedores</small>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card kpi-primary">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Volumen Ingresado</span>
                <h3 class="fw-bold text-info mb-1 mt-1"><%= totalPiezasCompradas %> <small class="fs-6 opacity-75">piezas</small></h3>
                <small class="text-white opacity-50">Unidades sumadas a existencias</small>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card kpi-primary">
                <span class="small text-white opacity-75 text-uppercase fw-semibold d-block">Lotes Registrados</span>
                <h3 class="fw-bold text-white mb-1 mt-1"><%= listaCompras != null ? listaCompras.size() : 0 %></h3>
                <small class="text-info fw-semibold">Órdenes de reabastecimiento</small>
            </div>
        </div>
    </div>

    <div class="card shadow-sm" style="background-color: #0f1728; border: 1px solid #1f2d48;">
        <div class="card-header bg-transparent text-white fw-bold py-3 border-bottom d-flex justify-content-between align-items-center" style="border-color: #1f2d48 !important;">
            <span>Auditoría de Reabastecimiento de Existencias por Proveedor</span>
            <span class="badge bg-secondary"><%= listaCompras != null ? listaCompras.size() : 0 %> Entradas</span>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table analytics-table align-middle text-center mb-0">
                    <thead>
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th>Fecha de Ingreso</th>
                        <th class="text-start">Proveedor</th>
                        <th>Factura Proveedor</th>
                        <th class="text-start">Producto Ingresado</th>
                        <th>Cantidad</th>
                        <th class="text-end">Costo Unitario</th>
                        <th class="text-end" style="width: 140px;">Subtotal</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (listaCompras == null || listaCompras.isEmpty()) { %>
                    <tr><td colspan="8" class="py-4 text-white opacity-50">No hay compras registradas en el sistema.</td></tr>
                    <% } else {
                        for (FilaCompraRep cp : listaCompras) { %>
                    <tr>
                        <td><strong class="text-white opacity-75">#<%= cp.getIdCompra() %></strong></td>
                        <td class="text-white small opacity-75"><%= cp.getFechaHora() %></td>
                        <td class="text-start fw-semibold text-white"><%= cp.getProveedor() %></td>
                        <td><span class="badge" style="background-color: #1c273e; color: #38bdf8;"><%= cp.getNoFacturaProveedor() %></span></td>
                        <td class="text-start text-white"><%= cp.getProducto() %></td>
                        <td><span class="badge bg-primary"><%= cp.getCantidad() %></span></td>
                        <td class="text-end text-white opacity-90">Q <%= String.format(Locale.US, "%,.2f", cp.getCostoUnitario()) %></td>
                        <td class="text-end fw-bold text-success">Q <%= String.format(Locale.US, "%,.2f", cp.getSubtotal()) %></td>
                    </tr>
                    <%  }
                    } %>
                    </tbody>
                    <tfoot>
                    <tr>
                        <th colspan="5" class="text-start text-white">TOTAL INVERTIDO EN INVENTARIO</th>
                        <th class="text-center text-white"><%= totalPiezasCompradas %> uds</th>
                        <th></th>
                        <th class="text-end text-success fs-6">Q <%= String.format(Locale.US, "%,.2f", totalInversion) %></th>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
    <% } %>
</div>