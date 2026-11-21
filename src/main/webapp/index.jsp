<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.Usuario" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.Producto" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.modelo.Factura" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.dao.ProductoDAO" %>
<%@ page import="com.proyectobd.rinconguatemaltecoweb.dao.FacturaDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    ProductoDAO prodDAO = new ProductoDAO();
    FacturaDAO facDAO = new FacturaDAO();

    List<Producto> listaProductos = prodDAO.listar();
    List<Factura> listaFacturas = facDAO.listarTodas();

    int totalVentasRealizadas = (int) listaFacturas.stream()
            .filter(f -> "Emitida".equalsIgnoreCase(f.getEstado()))
            .count();

    long totalProductosEnStock = listaProductos.stream()
            .filter(p -> p.getStockActual() > 1)
            .count();

    SimpleDateFormat sdf = new SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy", new java.util.Locale("es", "GT"));
    String fechaHoy = sdf.format(new Date());

    String vistaCentral = (String) request.getAttribute("vistaCentral");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Principal - Rincón Guatemalteco</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/custom-dark.css" rel="stylesheet">
    <style>
        html, body {
            height: 100vh;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .top-header {
            border-bottom: 2px solid #28354f;
            background-color: #0d1322;
            padding: 12px 20px;
            flex-shrink: 0;
        }

        .main-workspace {
            flex: 1;
            display: flex;
            overflow: hidden;
        }

        .sidebar-actions {
            width: 280px;
            min-width: 260px;
            border-right: 2px solid #28354f;
            background-color: #101726;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex-shrink: 0;
            overflow-y: auto;
        }

        .btn-panel {
            background-color: #172136;
            color: #ffffff !important;
            border: 1px solid #2e3f61;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 0.95rem;
            font-weight: 600;
            text-align: left;
            text-decoration: none;
            transition: all 0.2s ease-in-out;
            display: block;
        }

        .btn-panel:hover {
            background-color: #1f2e4d;
            border-color: #38bdf8;
            color: #38bdf8 !important;
            transform: translateX(4px);
        }

        .btn-panel-reportes {
            background-color: rgba(0, 210, 255, 0.08);
            border: 1px solid #00d2ff;
            color: #00d2ff !important;
            border-radius: 8px;
            padding: 11px 14px;
            font-size: 0.95rem;
            font-weight: 700;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s ease-in-out;
        }

        .btn-panel-reportes:hover {
            background-color: #00d2ff;
            color: #0d1322 !important;
            box-shadow: 0 0 15px rgba(0, 210, 255, 0.35);
            transform: translateX(4px);
        }

        .action-group-separator {
            height: 1px;
            background-color: #28354f;
            margin: 6px 0;
        }

        .dashboard-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            background-color: #0b0f19;
        }

        .top-bar-workspace {
            padding: 12px 30px;
            display: flex;
            justify-content: flex-end;
            border-bottom: 1px solid #1a2333;
            flex-shrink: 0;
        }

        .dynamic-view-container {
            flex: 1;
            overflow-y: auto;
            padding: 24px 30px;
            display: flex;
            flex-direction: column;
        }

        .bottom-bar-workspace {
            padding: 14px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #28354f;
            background-color: #0e1422;
            flex-shrink: 0;
        }

        .metrics-split {
            display: flex;
            border: 1px solid #28354f;
            border-radius: 8px;
            overflow: hidden;
            background-color: #151c2c;
        }

        .metric-cell {
            padding: 10px 20px;
            min-width: 190px;
        }

        .metric-cell:first-child {
            border-right: 1px solid #28354f;
        }

        .footer-panel {
            border-top: 1px solid #28354f;
            background-color: #0d1322;
            padding: 8px 20px;
            text-align: center;
            font-size: 0.82rem;
            color: #94a3b8;
            flex-shrink: 0;
        }
    </style>
</head>
<body>

<header class="top-header text-center">
    <h3 class="fw-bold mb-0 text-white tracking-wide">La Casa del Rincón Guatemalteco</h3>
</header>

<main class="main-workspace">

    <nav class="sidebar-actions">
        <a href="<%= request.getContextPath() %>/despacho" class="btn-panel text-info">
            Registrar venta
        </a>

        <a href="<%= request.getContextPath() %>/facturas" class="btn-panel">
            Historial de facturas
        </a>

        <div class="action-group-separator"></div>

        <a href="<%= request.getContextPath() %>/clientes" class="btn-panel">
            Clientes
        </a>

        <a href="<%= request.getContextPath() %>/proveedores" class="btn-panel">
            Proveedores
        </a>

        <div class="action-group-separator"></div>

        <a href="<%= request.getContextPath() %>/compras" class="btn-panel">
            Ingresar orden de compra
        </a>

        <a href="<%= request.getContextPath() %>/productos" class="btn-panel">
            Ingresar Producto
        </a>

        <div class="action-group-separator"></div>

        <a href="<%= request.getContextPath() %>/devoluciones" class="btn-panel text-danger">
            Devoluciones
        </a>

        <div class="mt-auto pt-3">
            <div class="action-group-separator mb-3"></div>
            <a href="<%= request.getContextPath() %>/reportes" class="btn-panel-reportes">
                <span>Reportes del Sistema</span>
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-bar-chart-line-fill" viewBox="0 0 16 16">
                    <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1z"/>
                </svg>
            </a>
        </div>
    </nav>

    <section class="dashboard-content">

        <div class="top-bar-workspace">
            <div class="px-3 py-1 rounded" style="background-color: #151c2c; border: 1px solid #28354f;">
                <span class="small text-white opacity-75 d-block text-uppercase" style="font-size: 0.7rem;"></span>
                <strong class="text-white text-capitalize small"><%= fechaHoy %></strong>
            </div>
        </div>

        <div class="dynamic-view-container">
            <% if (vistaCentral != null && !vistaCentral.trim().isEmpty()) { %>
            <jsp:include page="<%= vistaCentral %>" />
            <% } else { %>
            <div class="text-center my-auto py-5">
                <h1 class="display-5 fw-bold text-white mb-2">Bienvenido</h1>
                <h2 class="fw-semibold text-info mb-3"><%= usuario.getNombreCompleto() %></h2>
                <p class="text-white opacity-75 mb-0" style="max-width: 500px; margin: 0 auto;">
                    Terminal administrativa y operativa central.
                </p>
            </div>
            <% } %>
        </div>

        <div class="bottom-bar-workspace">
            <div class="metrics-split">
                <div class="metric-cell">
                    <span class="text-white small d-block mb-1 opacity-75">Ventas realizadas</span>
                    <h4 class="fw-bold text-success mb-0"><%= totalVentasRealizadas %></h4>
                </div>
                <div class="metric-cell">
                    <span class="text-white small d-block mb-1 opacity-75">Productos en stock</span>
                    <h4 class="fw-bold text-info mb-0"><%= totalProductosEnStock %></h4>
                </div>
            </div>

            <div>
                <a href="<%= request.getContextPath() %>/login?accion=salir"
                   class="btn btn-outline-danger px-4 py-2 fw-semibold rounded-pill">
                    Cerrar sesión
                </a>
            </div>
        </div>

    </section>

</main>

<footer class="footer-panel">
    <span>Sistema de Gestión Comercial — La Casa del Rincón Guatemalteco S.A.</span>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>