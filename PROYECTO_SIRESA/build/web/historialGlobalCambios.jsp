<%-- 
    Document   : historialGlobalCambios
    Created on : 2 jun. 2025, 21:25:57
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.HistorialCambioEstado"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Historial Global de Cambios de Estado</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .container-fluid h1 { margin-bottom: 10px; }
        .container-fluid .lead { margin-bottom: 20px; font-size: 1.1em; color: #6c757d;}
        .table th { background-color: #343a40; color: white; font-size: 0.9rem; }
        .table td { font-size: 0.85rem; vertical-align: middle; }
        .table-responsive { margin-top: 20px; }
        .estado-aprobado { color: #28a745; font-weight: bold; }
        .estado-rechazado { color: #dc3545; font-weight: bold; }
        .estado-en-proceso { color: #ffc107; font-weight: bold; }
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        if (sesion != null && session.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoHistGlobal");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaHistGlobal");
            return;
        }
        
        List<HistorialCambioEstado> cambiosRecientes = (List<HistorialCambioEstado>) request.getAttribute("cambiosRecientes");
        if (cambiosRecientes == null) {
            cambiosRecientes = new ArrayList<>();
        }
        Integer limiteMostrado = (Integer) request.getAttribute("limiteMostrado");
        if(limiteMostrado == null) limiteMostrado = 0;

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp">Dashboard</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Historial Global</a></li>
            </ul>
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1><i class="fas fa-archive"></i> Historial Global de Cambios de Estado</h1>
                <p class="lead">Mostrando los últimos <%= limiteMostrado %> cambios registrados en el sistema.</p>
            </div>
             <a href="admin_dashboard.jsp" class="btn btn-info"><i class="fas fa-tachometer-alt"></i> Volver al Dashboard</a>
        </div>
        <hr>

        <%
            String mensajeError = (String) session.getAttribute("mensajeError");
            if (mensajeError != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= mensajeError %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        <%
                session.removeAttribute("mensajeError");
            }
        %>

        <div class="table-responsive">
            <table class="table table-hover table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>#</th>
                        <th>Fecha del Cambio</th>
                        <th>Establecimiento (ID)</th>
                        <th>Estado Anterior</th>
                        <th>Estado Nuevo</th>
                        <th>Modificado Por</th>
                        <th>Motivo del Cambio</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (cambiosRecientes.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="text-center">No hay historial de cambios de estado registrados recientemente.</td>
                        </tr>
                    <% } else {
                        int contador = 1;
                        for (HistorialCambioEstado cambio : cambiosRecientes) {
                            String claseAnterior = "";
                            if ("aprobado".equalsIgnoreCase(cambio.getEstadoAnterior())) claseAnterior = "estado-aprobado";
                            else if ("rechazado".equalsIgnoreCase(cambio.getEstadoAnterior())) claseAnterior = "estado-rechazado";
                            else if ("en proceso".equalsIgnoreCase(cambio.getEstadoAnterior())) claseAnterior = "estado-en-proceso";

                            String claseNueva = "";
                            if ("aprobado".equalsIgnoreCase(cambio.getEstadoNuevo())) claseNueva = "estado-aprobado";
                            else if ("rechazado".equalsIgnoreCase(cambio.getEstadoNuevo())) claseNueva = "estado-rechazado";
                            else if ("en proceso".equalsIgnoreCase(cambio.getEstadoNuevo())) claseNueva = "estado-en-proceso";
                    %>
                        <tr>
                            <td><%= contador++ %></td>
                            <td><%= sdf.format(cambio.getFechaCambio()) %></td>
                            <td>
                                <a href="ControladorEstablecimiento?accion=verdetalle&id=<%= cambio.getIdEstablecimiento() %>" title="Ver detalle del establecimiento">
                                    <%= cambio.getNombreEstablecimiento() != null ? cambio.getNombreEstablecimiento() : "Establecimiento" %>
                                </a>
                                (<%= cambio.getIdEstablecimiento() %>)
                            </td>
                            <td><span class="badge badge-pill badge-light <%= claseAnterior %>"><%= cambio.getEstadoAnterior() != null ? cambio.getEstadoAnterior() : "N/A" %></span></td>
                            <td><span class="badge badge-pill badge-light <%= claseNueva %>"><%= cambio.getEstadoNuevo() %></span></td>
                            <td><%= cambio.getNombreUsuarioModifico() %></td>
                            <td><%= cambio.getMotivoCambio() %></td>
                        </tr>
                    <%  } 
                       } %>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>