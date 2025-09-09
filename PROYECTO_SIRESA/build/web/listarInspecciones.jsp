<%-- 
    Document   : listarInspecciones
    Created on : 2 jun. 2025, 13:10:13
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Establecimiento"%>
<%@page import="modelo.Inspeccion"%>
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
        List<Inspeccion> inspecciones = (List<Inspeccion>) request.getAttribute("inspecciones");

        if (establecimiento == null) {
            response.sendRedirect("ControladorEstablecimiento?accion=listar&error=EstNoEncontradoParaListInsp");
            return;
        }
        if (inspecciones == null) {
            inspecciones = new ArrayList<>();
        }
        
        String tituloPagina = "Inspecciones - " + establecimiento.getNombre();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdtf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    %>
    <title>SIRESA - <%= tituloPagina %></title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .container-fluid h1 { margin-bottom: 10px; }
        .container-fluid .lead { margin-bottom: 20px; font-size: 1.1em; color: #6c757d;}
        .table th, .table td { vertical-align: middle; font-size: 0.9rem;}
        .table-responsive { margin-top: 20px; }
        .resultado-aprobado { color: #28a745; font-weight: bold; }
        .resultado-rechazado { color: #dc3545; font-weight: bold; }
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        String rolUsuarioLogueado = "";
        boolean puedeRegistrarInspeccion = false;

        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            rolUsuarioLogueado = usuarioLogueado.getRol().toLowerCase();
            if ("admin".equals(rolUsuarioLogueado) || "inspector".equals(rolUsuarioLogueado)) {
                puedeRegistrarInspeccion = true;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaListInsp");
            return;
        }
        
        String dashboardLink = "ControladorEstablecimiento?accion=listar";
        String navBarColor = "bg-info";
        if (usuarioLogueado != null) {
            if ("admin".equals(rolUsuarioLogueado)) {
                dashboardLink = "admin_dashboard.jsp";
                navBarColor = "bg-primary";
            } else if ("inspector".equals(rolUsuarioLogueado)) {
                dashboardLink = "inspector_dashboard.jsp";
                navBarColor = "bg-success";
            } else if ("ciudadano".equals(rolUsuarioLogueado)) {
                 dashboardLink = "ciudadano_dashboard.jsp";
                 navBarColor = "bg-secondary";
            }
        }
    %>
    <nav class="navbar navbar-expand-lg navbar-dark <%= navBarColor %>">
        <a class="navbar-brand" href="<%= dashboardLink %>"><i class="fas fa-clipboard-check"></i> SIRESA</a>
         <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="ControladorEstablecimiento?accion=listar">Establecimientos</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Inspecciones de: <%= establecimiento.getNombre() %></a></li>
            </ul>
            <ul class="navbar-nav ml-auto">
                <% if (usuarioLogueado != null) { %>
                    <li class="nav-item">
                        <span class="navbar-text text-white mr-3">
                            <%= usuarioLogueado.getNombreCompleto() != null ? usuarioLogueado.getNombreCompleto() : usuarioLogueado.getNombreUsuario() %>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-light btn-sm" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Salir</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1><i class="fas fa-tasks"></i> Lista de Inspecciones</h1>
                <p class="lead">Establecimiento: <strong><%= establecimiento.getNombre() %></strong> (ID: <%= establecimiento.getIdEstablecimiento() %>) - Estado Actual: <strong><%= establecimiento.getEstado() %></strong></p>
            </div>
            <div>
            <% if (puedeRegistrarInspeccion) { %>
                <a href="ControladorInspeccion?accion=mostrarformregistro&idEstablecimiento=<%= establecimiento.getIdEstablecimiento() %>" class="btn btn-success mb-2">
                    <i class="fas fa-plus"></i> Registrar Nueva Inspección
                </a>
            <% } %>
            <a href="ControladorEstablecimiento?accion=verdetalle&id=<%= establecimiento.getIdEstablecimiento() %>" class="btn btn-info mb-2">
                <i class="fas fa-arrow-left"></i> Volver a Detalles del Establecimiento
            </a>
            </div>
        </div>
        <hr>

        <%
            String mensajeExito = (String) session.getAttribute("mensajeExito");
            if (mensajeExito != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= mensajeExito %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        <%
                session.removeAttribute("mensajeExito");
            }
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
            String mensajeAdvertencia = (String) session.getAttribute("mensajeAdvertencia");
            if (mensajeAdvertencia != null) {
        %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <%= mensajeAdvertencia %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        <%
                session.removeAttribute("mensajeAdvertencia");
            }
        %>

        <div class="table-responsive">
            <table class="table table-hover table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>ID Insp.</th>
                        <th>Fecha Inspección</th>
                        <th>Inspector</th>
                        <th>Resultado</th>
                        <th>Observaciones</th>
                        <th>Registrado en Sistema</th>
                        <%-- <th>Acciones</th> --%>
                    </tr>
                </thead>
                <tbody>
                    <% if (inspecciones.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center">No hay inspecciones registradas para este establecimiento.</td>
                        </tr>
                    <% } else {
                        for (Inspeccion insp : inspecciones) {
                            String claseResultado = "";
                            if ("aprobado".equalsIgnoreCase(insp.getResultado())) claseResultado = "resultado-aprobado";
                            else if ("rechazado".equalsIgnoreCase(insp.getResultado())) claseResultado = "resultado-rechazado";
                    %>
                        <tr>
                            <td><%= insp.getIdInspeccion() %></td>
                            <td><%= insp.getFechaInspeccion() != null ? sdf.format(insp.getFechaInspeccion()) : "N/A" %></td>
                            <td><%= insp.getNombreInspector() != null ? insp.getNombreInspector() : "N/A" %></td>
                            <td><span class="<%= claseResultado %>"><%= insp.getResultado() %></span></td>
                            <td><%= insp.getObservaciones() != null ? insp.getObservaciones() : "" %></td>
                            <td><%= insp.getFechaRegistroSistema() != null ? sdtf.format(insp.getFechaRegistroSistema()) : "N/A" %></td>
                            
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
     <script>
        $(document).ready(function() {
            window.setTimeout(function() {
                $(".alert").fadeTo(500, 0).slideUp(500, function(){ $(this).remove(); });
            }, 7000);
        });
    </script>
</body>
</html>