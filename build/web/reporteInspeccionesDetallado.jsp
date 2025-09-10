<%-- 
    Document   : reporteInspeccionesDetallado
    Created on : 2 jun. 2025, 21:16:08
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Inspeccion"%>
<%@page import="modelo.Establecimiento"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Reporte Detallado de Inspecciones</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .report-container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .table th { background-color: #343a40; color: white; font-size: 0.9rem; }
        .table td { font-size: 0.85rem; vertical-align: middle; }
        .resultado-aprobado { color: #28a745; font-weight: bold; }
        .resultado-rechazado { color: #dc3545; font-weight: bold; }
        .observaciones-cell { max-width: 300px; word-wrap: break-word; }
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoReporteView");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaReporteView");
            return;
        }
        
        List<Inspeccion> inspecciones = (List<Inspeccion>) request.getAttribute("inspeccionesDetalladas");
        if (inspecciones == null) {
            inspecciones = new ArrayList<>();
        }
        
        String fechaInicioReporte = (String) request.getAttribute("fechaInicioReporteInspDetalle");
        String fechaFinReporte = (String) request.getAttribute("fechaFinReporteInspDetalle");
        String nombreInspectorFiltrado = (String) request.getAttribute("nombreInspectorFiltrado");
        

        SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfOriginal = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat sdfTablaFechaInspeccion = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfTablaFechaRegistro = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        
        String periodoStr = "N/D";
        String filtroInspectorStr = "";

        try {
            if (fechaInicioReporte != null && !fechaInicioReporte.isEmpty() && fechaFinReporte != null && !fechaFinReporte.isEmpty()) {
                periodoStr = "del " + sdfDisplay.format(sdfOriginal.parse(fechaInicioReporte)) + 
                             " al " + sdfDisplay.format(sdfOriginal.parse(fechaFinReporte));
            }
        } catch (Exception e) {
            periodoStr = "(Fechas inválidas)";
        }

        if (nombreInspectorFiltrado != null && !nombreInspectorFiltrado.isEmpty()){
            filtroInspectorStr = " para el Inspector: <strong>" + nombreInspectorFiltrado + "</strong>";
        } else {
            filtroInspectorStr = " para <strong>Todos los Inspectores</strong>";
        }

    %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-info">
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="ControladorReporte?accion=mostrarformulario">Reportes</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Detalle Inspecciones</a></li>
            </ul>
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="report-container">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <h1><i class="fas fa-list-check"></i> Reporte Detallado de Inspecciones</h1>
                    <p class="lead">Inspecciones realizadas <%= periodoStr %><%= filtroInspectorStr %>.</p>
                </div>
                <button onclick="window.print();" class="btn btn-secondary"><i class="fas fa-print"></i> Imprimir Página</button>
            </div>
            
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm">
                    <thead class="thead-dark">
                        <tr>
                            <th>ID Insp.</th>
                            <th>Fecha Inspección</th>
                            <th>Establecimiento</th>
                            <th>Inspector</th>
                            <th>Resultado</th>
                            <th class="observaciones-cell">Observaciones</th>
                            <th>Reg. Sistema</th>
                            <%-- <th>Acciones</th> --%>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (inspecciones.isEmpty()) { %>
                            <tr>
                                <td colspan="7" class="text-center">No se encontraron inspecciones para los criterios seleccionados.</td>
                            </tr>
                        <% } else {
                            for (Inspeccion insp : inspecciones) {
                                String claseResultado = "";
                                if ("aprobado".equalsIgnoreCase(insp.getResultado())) claseResultado = "resultado-aprobado";
                                else if ("rechazado".equalsIgnoreCase(insp.getResultado())) claseResultado = "resultado-rechazado";
                        %>
                            <tr>
                                <td><%= insp.getIdInspeccion() %></td>
                                <td><%= insp.getFechaInspeccion() != null ? sdfTablaFechaInspeccion.format(insp.getFechaInspeccion()) : "N/A" %></td>
                                <td>
                                    <a href="ControladorEstablecimiento?accion=verdetalle&id=<%= insp.getIdEstablecimiento() %>" title="Ver detalle del establecimiento">
                                        <%= insp.getNombreEstablecimiento() != null ? insp.getNombreEstablecimiento() : "ID: " + insp.getIdEstablecimiento() %>
                                    </a>
                                </td>
                                <td><%= insp.getNombreInspector() != null ? insp.getNombreInspector() : "N/A" %></td>
                                <td><span class="<%= claseResultado %>"><%= insp.getResultado() %></span></td>
                                <td class="observaciones-cell"><%= insp.getObservaciones() != null ? insp.getObservaciones() : "" %></td>
                                <td><%= insp.getFechaRegistroSistema() != null ? sdfTablaFechaRegistro.format(insp.getFechaRegistroSistema()) : "N/A" %></td>
                            </tr>
                        <%  } 
                           } %>
                    </tbody>
                </table>
            </div>
             <div class="text-right mt-3">
                <a href="ControladorReporte?accion=mostrarformulario" class="btn btn-primary"><i class="fas fa-arrow-left"></i> Volver a Selección de Reportes</a>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>