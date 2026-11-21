<div class="container text-center mt-4 no-print" style="max-width: 780px;">
    <div class="d-flex justify-content-between align-items-center mb-2">
        <a href="<%= request.getContextPath() %>/facturas" class="btn btn-outline-secondary btn-sm">
            &larr; Volver al Historial
        </a>
        <div class="d-flex gap-2">
            <a href="<%= request.getContextPath() %>/despacho" class="btn btn-emerald btn-sm">
                + Nueva Venta
            </a>
            <button onclick="window.print();" class="btn btn-cyan btn-sm px-4">
                Imprimir DTE
            </button>
        </div>
    </div>
</div>