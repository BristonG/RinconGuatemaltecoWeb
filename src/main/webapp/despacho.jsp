<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.*" %>
<%
    String paso = (String) request.getAttribute("pasoActual");
    if (paso == null) paso = "1";

    List<Producto> productos = (List<Producto>) request.getAttribute("productos");
    List<FormaPago> formasPago = (List<FormaPago>) request.getAttribute("formasPago");
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
    List<DetalleFactura> carrito = (List<DetalleFactura>) session.getAttribute("carrito");
    Cliente clienteTemp = (Cliente) session.getAttribute("clienteTemporal");
    Cliente clienteFactura = (Cliente) request.getAttribute("clienteFactura");
    Double totalPagar = (Double) request.getAttribute("totalPagar");
    if (totalPagar == null) totalPagar = 0.0;

    String error = (String) request.getAttribute("error");

    Factura facturaEmitida = (Factura) request.getAttribute("facturaEmitida");
    List<DetalleFactura> productosFacturados = (List<DetalleFactura>) request.getAttribute("productosFacturados");
%>

<style>
    @media print {
        html, body {
            height: auto !important;
            overflow: visible !important;
            background-color: #ffffff !important;
            color: #000000 !important;
            margin: 0 !important;
            padding: 0 !important;
        }

        .top-header,
        .sidebar-actions,
        .top-bar-workspace,
        .bottom-bar-workspace,
        .footer-panel,
        .no-print,
        .card-header,
        .alert {
            display: none !important;
        }

        .main-workspace,
        .dashboard-content,
        .dynamic-view-container {
            display: block !important;
            height: auto !important;
            overflow: visible !important;
            padding: 0 !important;
            margin: 0 !important;
            border: none !important;
            background: transparent !important;
        }

        .card {
            border: none !important;
            background: transparent !important;
            box-shadow: none !important;
            margin: 0 !important;
        }

        .card-body {
            padding: 0 !important;
        }

        #seccionFacturaImprimible {
            position: static !important;
            width: 100% !important;
            margin: 0 !important;
            padding: 10px 0 !important;
            background: #ffffff !important;
            color: #000000 !important;
        }

        #seccionFacturaImprimible * {
            color: #000000 !important;
            background-color: transparent !important;
            opacity: 1 !important;
            text-shadow: none !important;
        }

        #seccionFacturaImprimible .table {
            border-bottom: 1px solid #000000 !important;
            margin-bottom: 12px !important;
        }

        #seccionFacturaImprimible .table th {
            border-bottom: 2px solid #000000 !important;
            color: #000000 !important;
            padding: 6px 8px !important;
        }

        #seccionFacturaImprimible .table td {
            border-top: 1px solid #dddddd !important;
            color: #000000 !important;
            padding: 6px 8px !important;
        }

        #seccionFacturaImprimible .rounded {
            border: 1px solid #333333 !important;
            background-color: #f9f9f9 !important;
        }

        #seccionFacturaImprimible .badge {
            border: 1px solid #000000 !important;
            color: #000000 !important;
        }
    }
</style>

<div>
    <% if (error != null) { %>
    <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
        <%= error %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if ("1".equals(paso)) { %>
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white fw-bold py-2">
            Gestión de ventas
        </div>
        <div class="card-body">
            <div class="row g-4">
                <div class="col-md-5 border-end" style="border-color: #28354f !important;">
                    <form action="<%= request.getContextPath() %>/despacho" method="post">
                        <input type="hidden" name="accion" value="agregar">

                        <div class="mb-3">
                            <label class="form-label fw-bold text-white">Seleccionar producto</label>
                            <select class="form-select" name="idProducto" required>
                                <option value="">-- Buscar producto disponible --</option>
                                <% if (productos != null) {
                                    for (Producto p : productos) { %>
                                <option value="<%= p.getIdProducto() %>">
                                    <%= p.getNombreProducto() %> (Stock: <%= p.getStockActual() %> | Q <%= String.format(java.util.Locale.US, "%.2f", p.getPrecioVenta()) %>)
                                </option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-white">Cantidad</label>
                            <input type="number" class="form-control" name="cantidad" min="1" value="1" required>
                        </div>

                        <button type="submit" class="btn btn-primary px-4 fw-semibold">
                            + Agregar
                        </button>
                    </form>
                </div>

                <div class="col-md-7">
                    <h6 class="fw-bold text-white mb-3">Carrito</h6>
                    <div class="table-responsive">
                        <table class="table table-sm align-middle text-center mb-0">
                            <thead>
                            <tr>
                                <th class="text-start">Producto</th>
                                <th style="width: 70px;">Cant</th>
                                <th style="width: 110px;">Precio</th>
                                <th style="width: 120px;">Subtotal</th>
                                <th style="width: 45px;"></th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if (carrito == null || carrito.isEmpty()) { %>
                            <tr>
                                <td colspan="5" class="py-4 text-white opacity-75">Aún no hay productos en el carrito</td>
                            </tr>
                            <% } else {
                                for (DetalleFactura item : carrito) { %>
                            <tr>
                                <td class="text-start text-white"><%= item.getNombreProducto() %></td>
                                <td class="text-white"><%= item.getCantidad() %></td>
                                <td class="text-white">Q <%= String.format(java.util.Locale.US, "%.2f", item.getPrecioUnitarioVenta()) %></td>
                                <td class="fw-bold text-info">Q <%= String.format(java.util.Locale.US, "%.2f", item.getSubtotalLinea()) %></td>
                                <td>
                                    <form action="<%= request.getContextPath() %>/despacho" method="post" class="d-inline">
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

            <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top" style="border-color: #28354f !important;">
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-secondary px-4">
                    Volver a menú principal
                </a>

                <a href="<%= request.getContextPath() %>/despacho?paso=2"
                   class="btn btn-success px-4 fw-semibold <%= (carrito == null || carrito.isEmpty()) ? "disabled" : "" %>">
                    Confirmar compra &rarr;
                </a>
            </div>
        </div>
    </div>
    <% } %>

    <% if ("2".equals(paso)) { %>
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white fw-bold py-2">
            Datos de cliente
        </div>
        <div class="card-body">
            <div class="mb-4 p-3 rounded" style="background-color: #101726; border: 1px solid #28354f;">
                <label class="form-label fw-bold text-info mb-1">
                    Cargar cliente registrado (opcional)
                </label>
                <select id="selClienteExistente" class="form-select">
                    <option value="">-- Seleccionar de la base de datos o escribir abajo --</option>
                    <option value="CF" data-nom="Consumidor" data-ape="Final" data-tel="" data-correo="" data-dir="Ciudad">
                        CF - Consumidor Final
                    </option>
                    <% if (clientes != null) {
                        for (Cliente c : clientes) { %>
                    <option value="<%= c.getNit() %>"
                            data-nom="<%= c.getNombres() %>"
                            data-ape="<%= c.getApellidos() != null ? c.getApellidos() : "" %>"
                            data-tel="<%= c.getTelefono() != null ? c.getTelefono() : "" %>"
                            data-correo="<%= c.getCorreoElectronico() != null ? c.getCorreoElectronico() : "" %>"
                            data-dir="<%= c.getDireccion() != null ? c.getDireccion() : "" %>">
                        <%= c.getNit() %> — <%= c.getNombreCompleto() %>
                    </option>
                    <%  }
                    } %>
                </select>
            </div>

            <form action="<%= request.getContextPath() %>/despacho" method="post">
                <input type="hidden" name="accion" value="guardarClienteTemporal">

                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">NIT</label>
                        <input type="text" class="form-control" name="nit" id="txtNit" list="listaNits"
                               value="<%= (clienteTemp != null && clienteTemp.getNit() != null) ? clienteTemp.getNit() : "CF" %>"
                               placeholder="CF" required autocomplete="off">
                        <datalist id="listaNits">
                            <option value="CF">Consumidor Final</option>
                            <% if (clientes != null) {
                                for (Cliente c : clientes) { %>
                            <option value="<%= c.getNit() %>"><%= c.getNombreCompleto() %></option>
                            <%  }
                            } %>
                        </datalist>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Nombre</label>
                        <input type="text" class="form-control" name="nombres" id="txtNombres"
                               value="<%= (clienteTemp != null && clienteTemp.getNombres() != null) ? clienteTemp.getNombres() : "Consumidor Final" %>"
                               placeholder="Nombres del cliente" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Apellido</label>
                        <input type="text" class="form-control" name="apellidos" id="txtApellidos"
                               value="<%= (clienteTemp != null && clienteTemp.getApellidos() != null) ? clienteTemp.getApellidos() : "" %>"
                               placeholder="Apellidos">
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Tel. <span class="fw-normal opacity-75">(opcional)</span></label>
                        <input type="text" class="form-control" name="telefono" id="txtTelefono"
                               value="<%= (clienteTemp != null && clienteTemp.getTelefono() != null) ? clienteTemp.getTelefono() : "" %>"
                               placeholder="Opcional">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Correo <span class="fw-normal opacity-75">(opcional)</span></label>
                        <input type="email" class="form-control" name="email" id="txtCorreo"
                               value="<%= (clienteTemp != null && clienteTemp.getCorreoElectronico() != null) ? clienteTemp.getCorreoElectronico() : "" %>"
                               placeholder="Opcional">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-white">Dirección</label>
                        <input type="text" class="form-control" name="direccion" id="txtDireccion"
                               value="<%= (clienteTemp != null && clienteTemp.getDireccion() != null) ? clienteTemp.getDireccion() : "Ciudad" %>"
                               placeholder="Ciudad" required>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center pt-3 border-top" style="border-color: #28354f !important;">
                    <a href="<%= request.getContextPath() %>/despacho?paso=1" class="btn btn-secondary px-4">
                        &larr; Regresar a carrito
                    </a>
                    <button type="submit" class="btn btn-success px-4 fw-semibold">
                        Proceder a cobro &rarr;
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const selCliente = document.getElementById('selClienteExistente');
        const txtNit = document.getElementById('txtNit');
        const txtNombres = document.getElementById('txtNombres');
        const txtApellidos = document.getElementById('txtApellidos');
        const txtTelefono = document.getElementById('txtTelefono');
        const txtCorreo = document.getElementById('txtCorreo');
        const txtDireccion = document.getElementById('txtDireccion');

        selCliente.addEventListener('change', function() {
            const opt = this.options[this.selectedIndex];
            if (this.value) {
                txtNit.value = this.value;
                txtNombres.value = opt.getAttribute('data-nom') || '';
                txtApellidos.value = opt.getAttribute('data-ape') || '';
                txtTelefono.value = opt.getAttribute('data-tel') || '';
                txtCorreo.value = opt.getAttribute('data-correo') || '';
                txtDireccion.value = opt.getAttribute('data-dir') || 'Ciudad';
            }
        });

        txtNit.addEventListener('input', function() {
            if (this.value.trim().toUpperCase() === 'CF') {
                if (!txtNombres.value || txtNombres.value === '') {
                    txtNombres.value = 'Consumidor Final';
                }
                if (!txtDireccion.value || txtDireccion.value === '') {
                    txtDireccion.value = 'Ciudad';
                }
            }
        });
    </script>
    <% } %>

    <% if ("3".equals(paso)) { %>
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white fw-bold py-2">
            Facturación
        </div>
        <div class="card-body">
            <div class="row g-4">
                <div class="col-md-6 border-end" style="border-color: #28354f !important;">
                    <h6 class="fw-bold text-white mb-3">Carrito</h6>
                    <div class="table-responsive">
                        <table class="table table-sm align-middle text-center mb-0">
                            <thead>
                            <tr>
                                <th class="text-start">Producto</th>
                                <th style="width: 70px;">Cant</th>
                                <th style="width: 100px;">Precio</th>
                                <th style="width: 110px;">Subtotal</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if (carrito != null) {
                                for (DetalleFactura item : carrito) { %>
                            <tr>
                                <td class="text-start text-white"><%= item.getNombreProducto() %></td>
                                <td class="text-white"><%= item.getCantidad() %></td>
                                <td class="text-white">Q <%= String.format(java.util.Locale.US, "%.2f", item.getPrecioUnitarioVenta()) %></td>
                                <td class="fw-bold text-info">Q <%= String.format(java.util.Locale.US, "%.2f", item.getSubtotalLinea()) %></td>
                            </tr>
                            <%  }
                            } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4 pt-3">
                        <a href="<%= request.getContextPath() %>/despacho?paso=2" class="btn btn-secondary px-4">
                            &larr; Regresar a datos de cliente
                        </a>
                    </div>
                </div>

                <div class="col-md-6">
                    <form action="<%= request.getContextPath() %>/despacho" method="post">
                        <input type="hidden" name="accion" value="procesarFactura">

                        <div class="text-center mb-4">
                            <span class="text-white small fw-bold text-uppercase d-block mb-1">Total a pagar</span>
                            <h2 class="fw-bold text-info mb-0">Q <%= String.format(java.util.Locale.US, "%.2f", totalPagar) %></h2>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-white">Forma de pago</label>
                            <select class="form-select" name="idFormaPago" required>
                                <% if (formasPago != null) {
                                    for (FormaPago fp : formasPago) { %>
                                <option value="<%= fp.getIdFormaPago() %>"><%= fp.getDescripcion() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <div class="row align-items-center mb-4">
                            <div class="col-md-7">
                                <label class="form-label fw-bold text-white">Monto recibido Q</label>
                                <input type="number" step="0.01" class="form-control" name="montoRecibido" id="txtMontoRecibido"
                                       min="<%= totalPagar %>" value="<%= String.format(java.util.Locale.US, "%.2f", totalPagar) %>" required>
                            </div>
                            <div class="col-md-5 text-end">
                                <span class="text-white small d-block mb-1">Cambio</span>
                                <h4 class="fw-bold text-success mb-0" id="lblCambio">Q 0.00</h4>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-success btn-lg w-100 py-2 fw-semibold" <%= (totalPagar <= 0) ? "disabled" : "" %>>
                            Procesar factura
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        const txtRecibido = document.getElementById('txtMontoRecibido');
        const lblVuelto = document.getElementById('lblCambio');
        const total = <%= totalPagar %>;

        txtRecibido.addEventListener('input', function() {
            const rec = parseFloat(this.value) || 0;
            const cambio = Math.max(0, rec - total);
            lblVuelto.innerText = 'Q ' + cambio.toFixed(2);
        });
    </script>
    <% } %>

    <% if ("4".equals(paso) && facturaEmitida != null) { %>
    <div class="card shadow-sm">
        <div class="card-header bg-success text-white fw-bold py-2 d-flex justify-content-between align-items-center no-print">
            <span>Venta finalizada exitosamente</span>
            <span class="badge bg-light text-dark"><%= facturaEmitida.getNumeroFactura() %></span>
        </div>

        <div class="card-body p-4" id="seccionFacturaImprimible">
            <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3" style="border-color: #28354f !important;">
                <div>
                    <h4 class="fw-bold text-info mb-1">Rincón Guatemalteco, S.A.</h4>
                    <div class="small text-white opacity-75">
                        <div>NIT: 10485923-4</div>
                        <div>Calzada San Juan 14-22, Zona 7, Guatemala</div>
                    </div>
                </div>
                <div class="text-end">
                    <span class="badge bg-primary text-uppercase px-3 py-1">Factura</span>
                    <h5 class="fw-bold text-white mt-1 mb-0"><%= facturaEmitida.getNumeroFactura() %></h5>
                </div>
            </div>

            <div class="p-3 rounded mb-3" style="background-color: #101726; border: 1px solid #28354f;">
                <div class="row g-2 small">
                    <div class="col-md-3">
                        <span class="text-white opacity-75">NIT:</span>
                        <div class="fw-bold text-warning"><%= facturaEmitida.getNitCliente() %></div>
                    </div>
                    <div class="col-md-5">
                        <span class="text-white opacity-75">Nombre del Cliente:</span>
                        <div class="fw-bold text-white"><%= facturaEmitida.getNombreCliente() %></div>
                    </div>
                    <div class="col-md-4">
                        <span class="text-white opacity-75">Dirección:</span>
                        <div class="fw-semibold text-white">
                            <%= (clienteFactura != null && clienteFactura.getDireccion() != null && !clienteFactura.getDireccion().trim().isEmpty()) ? clienteFactura.getDireccion() : "Ciudad" %>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-responsive mb-3">
                <table class="table table-sm align-middle text-center mb-0">
                    <thead>
                    <tr>
                        <th style="width: 70px;">Cant</th>
                        <th class="text-start">Descripción del Producto</th>
                        <th style="width: 120px;" class="text-end">Precio U.</th>
                        <th style="width: 130px;" class="text-end">Subtotal</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (productosFacturados != null) {
                        for (DetalleFactura item : productosFacturados) { %>
                    <tr>
                        <td class="text-white"><%= item.getCantidad() %></td>
                        <td class="text-start text-white"><%= item.getNombreProducto() %></td>
                        <td class="text-end text-white">Q <%= String.format(java.util.Locale.US, "%.2f", item.getPrecioUnitarioVenta()) %></td>
                        <td class="text-end fw-bold text-info">Q <%= String.format(java.util.Locale.US, "%.2f", item.getSubtotalLinea()) %></td>
                    </tr>
                    <%  }
                    } %>
                    </tbody>
                </table>
            </div>

            <div class="row justify-content-end mb-4">
                <div class="col-md-5">
                    <div class="p-3 rounded" style="background-color: #101726; border: 1px solid #28354f;">
                        <div class="d-flex justify-content-between mb-1 small">
                            <span class="text-white opacity-75">Método de pago:</span>
                            <span class="text-info fw-semibold"><%= facturaEmitida.getDescripcionFormaPago() %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-1 small">
                            <span class="text-white opacity-75">Monto recibido:</span>
                            <span class="text-white">Q <%= String.format(java.util.Locale.US, "%.2f", facturaEmitida.getMontoRecibido()) %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-white opacity-75">Cambio devuelto:</span>
                            <span class="text-success fw-bold">Q <%= String.format(java.util.Locale.US, "%.2f", facturaEmitida.getCambio()) %></span>
                        </div>
                        <div class="d-flex justify-content-between pt-2 border-top" style="border-color: #28354f !important;">
                            <h5 class="fw-bold mb-0 text-white">TOTAL:</h5>
                            <h5 class="fw-bold mb-0 text-success">Q <%= String.format(java.util.Locale.US, "%.2f", facturaEmitida.getTotalVenta()) %></h5>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center pt-3 border-top no-print" style="border-color: #28354f !important;">
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-secondary px-4">
                    Volver al menú principal
                </a>

                <div class="d-flex gap-2">
                    <a href="<%= request.getContextPath() %>/despacho?paso=1" class="btn btn-outline-info px-3">
                        + Nueva venta
                    </a>
                    <button onclick="window.print();" class="btn btn-cyan px-4 fw-semibold">
                        Descargar / Imprimir factura (PDF)
                    </button>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</div>