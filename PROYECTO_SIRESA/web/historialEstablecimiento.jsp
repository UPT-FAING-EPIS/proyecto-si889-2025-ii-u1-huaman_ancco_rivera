<%-- 
    Document   : historialEstablecimiento
    Created on : 2 jun. 2025, 12:40:31
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Establecimiento"%>
<%@page import="modelo.HistorialCambioEstado"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Establecimiento establecimiento = (Establecimiento) request.getAttribute("establecimiento");
        List<HistorialCambioEstado> historial = (List<HistorialCambioEstado>) request.getAttribute("historial");
        if (establecimiento == null) {
            response.sendRedirect("ControladorEstablecimiento?accion=listar&error=EstNoEncontradoParaHist");
            return;
        }
        if (historial == null) {
            historial = new ArrayList<>();
        }
        String tituloPagina = "Historial de Cambios - " + establecimiento.getNombre();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    %>
    <title>SIRESA - <%= tituloPagina %></title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .container h1 { margin-bottom: 10px; }
        .container .lead { margin-bottom: 20px; font-size: 1.1em; color: #6c757d;}
        .table th, .table td { vertical-align: middle; font-size: 0.9rem;}
        .table-responsive { margin-top: 20px; }
        .estado-aprobado { color: #28a745; font-weight: bold; }
        .estado-rechazado { color: #dc3545; font-weight: bold; }
        .estado-en-proceso { color: #ffc107; font-weight: bold; }
        .badge-custom { padding: .4em .6em; font-size: 90%;}
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                 response.sendRedirect("login.jsp?error=AccesoDenegadoHistorial");
                 return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaHistorial");
            return;
        }
        String dashboardLink = "admin_dashboard.jsp";
    %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
        <a class="navbar-brand" href="<%= dashboardLink %>"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
         <div class="ml-auto">
             <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1><i class="fas fa-history"></i> Historial de Cambios de Estado</h1>
                <p class="lead">Establecimiento: <strong><%= establecimiento.getNombre() %></strong> (ID: <%= establecimiento.getIdEstablecimiento() %>)</p>
            </div>
            <a href="ControladorEstablecimiento?accion=listar" class="btn btn-info"><i class="fas fa-list"></i> Volver a la Lista</a>
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
                        <th>Estado Anterior</th>
                        <th>Estado Nuevo</th>
                        <th>Modificado Por</th>
                        <th>Motivo del Cambio</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (historial.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center">No hay historial de cambios de estado para este establecimiento.</td>
                        </tr>
                    <% } else {
                        int contador = 1;
                        for (HistorialCambioEstado cambio : historial) {
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
