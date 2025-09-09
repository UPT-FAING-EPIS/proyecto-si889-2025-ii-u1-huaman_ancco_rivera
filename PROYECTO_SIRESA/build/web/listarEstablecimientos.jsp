<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Establecimiento"%>
<%@page import="modelo.TipoEstablecimiento"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Lista de Establecimientos</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .container-fluid h1 { margin-bottom: 10px; } 
        .filter-form {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .table th, .table td { vertical-align: middle; font-size: 0.9rem;}
        .action-icons a { margin-right: 8px; font-size: 1.1em;}
        .estado-aprobado { background-color: #28a745 !important; color: white; padding: .3em .6em; border-radius: .25rem; }
        .estado-rechazado { background-color: #dc3545 !important; color: white; padding: .3em .6em; border-radius: .25rem; }
        .estado-en-proceso { background-color: #ffc107 !important; color: black; padding: .3em .6em; border-radius: .25rem; }
        .table-responsive { margin-top: 20px; }
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        String rolUsuarioLogueado = "";
        boolean puedeRegistrar = false;
        boolean puedeCambiarEstado = false;

        String brandLink = "login.jsp";
        String userDashboardLink = "login.jsp"; 
        String navBarColor = "bg-dark";

        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            rolUsuarioLogueado = usuarioLogueado.getRol().toLowerCase();
            if ("admin".equals(rolUsuarioLogueado)) {
                puedeRegistrar = true;
                puedeCambiarEstado = true;
                brandLink = "admin_dashboard.jsp";
                userDashboardLink = "admin_dashboard.jsp";
                navBarColor = "bg-primary";
            } else if ("inspector".equals(rolUsuarioLogueado)) {
                puedeRegistrar = true;
                puedeCambiarEstado = true;
                brandLink = "inspector_dashboard.jsp";
                userDashboardLink = "inspector_dashboard.jsp";
                navBarColor = "bg-success"; 
            } else if ("ciudadano".equals(rolUsuarioLogueado)) {
                brandLink = "ciudadano_dashboard.jsp";
                userDashboardLink = "ciudadano_dashboard.jsp";
                navBarColor = "bg-secondary";
            }
        }
        List<Establecimiento> establecimientos = (List<Establecimiento>) request.getAttribute("establecimientos");
        if (establecimientos == null) establecimientos = new ArrayList<>();
        
        List<TipoEstablecimiento> tiposEstablecimiento = (List<TipoEstablecimiento>) request.getAttribute("tiposEstablecimiento");
        if (tiposEstablecimiento == null) tiposEstablecimiento = new ArrayList<>();

        String filtroNombre = request.getParameter("filtroNombre") != null ? request.getParameter("filtroNombre") : "";
        String filtroTipo = request.getParameter("filtroTipo") != null ? request.getParameter("filtroTipo") : "";
        String filtroEstado = request.getParameter("filtroEstado") != null ? request.getParameter("filtroEstado") : "";

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>

    <nav class="navbar navbar-expand-lg navbar-dark <%= navBarColor %>"> 
        <%-- Usar brandLink definido arriba --%>
        <a class="navbar-brand" href="<%= brandLink %>"><i class="fas fa-home"></i> SIRESA</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                 <% if (usuarioLogueado != null) { %>
                    <%-- Usar userDashboardLink definido arriba --%>
                    <li class="nav-item"><a class="nav-link" href="<%= userDashboardLink %>">Mi Dashboard</a></li>
                <% } %>
                <li class="nav-item active"><a class="nav-link" href="ControladorEstablecimiento?accion=listar">Ver Establecimientos</a></li>
            </ul>
            <ul class="navbar-nav ml-auto">
                <% if (usuarioLogueado != null) { %>
                    <li class="nav-item">
                        <span class="navbar-text text-white mr-3">
                            Hola, <%= usuarioLogueado.getNombreCompleto() != null ? usuarioLogueado.getNombreCompleto() : usuarioLogueado.getNombreUsuario() %>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-light btn-sm" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Salir</a>
                    </li>
                <% } else { %>
                     <li class="nav-item">
                        <a class="btn btn-outline-light btn-sm" href="login.jsp"><i class="fas fa-sign-in-alt"></i> Iniciar Sesión</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center">
            <h1><i class="fas fa-list-ul"></i> Lista de Establecimientos Registrados</h1>
            <% if (puedeRegistrar) { %>
                <a href="ControladorEstablecimiento?accion=mostrarformregistro" class="btn btn-success">
                    <i class="fas fa-plus-circle"></i> Registrar Nuevo Establecimiento
                </a>
            <% } %>
        </div>
        <hr>

        <form method="GET" action="ControladorEstablecimiento" class="filter-form">
            <input type="hidden" name="accion" value="listar">
            <div class="form-row align-items-end">
                <div class="form-group col-md-4">
                    <label for="filtroNombre">Buscar por Nombre</label>
                    <input type="text" class="form-control form-control-sm" id="filtroNombre" name="filtroNombre" value="<%= filtroNombre %>" placeholder="Nombre del establecimiento...">
                </div>
                <div class="form-group col-md-3">
                    <label for="filtroTipo">Filtrar por Tipo</label>
                    <select class="form-control form-control-sm" id="filtroTipo" name="filtroTipo">
                        <option value="">Todos los Tipos</option>
                        <% for (TipoEstablecimiento tipo : tiposEstablecimiento) { %>
                            <option value="<%= tipo.getIdTipoEstablecimiento() %>" 
                                    <%= String.valueOf(tipo.getIdTipoEstablecimiento()).equals(filtroTipo) ? "selected" : "" %>>
                                <%= tipo.getNombreTipo() %>
                            </option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group col-md-3">
                    <label for="filtroEstado">Filtrar por Estado</label>
                    <select class="form-control form-control-sm" id="filtroEstado" name="filtroEstado">
                        <option value="">Todos los Estados</option>
                        <option value="aprobado" <%= "aprobado".equals(filtroEstado) ? "selected" : "" %>>Aprobado</option>
                        <option value="rechazado" <%= "rechazado".equals(filtroEstado) ? "selected" : "" %>>Rechazado</option>
                        <option value="en proceso" <%= "en proceso".equals(filtroEstado) ? "selected" : "" %>>En Proceso</option>
                    </select>
                </div>
                <div class="form-group col-md-2">
                    <button type="submit" class="btn btn-primary btn-sm btn-block"><i class="fas fa-search"></i> Filtrar</button>
                </div>
            </div>
        </form>

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
        %>

        <div class="table-responsive">
            <table class="table table-hover table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Tipo</th>
                        <th>Dirección</th>
                        <th>Estado</th>
                        <th>Fecha Reg.</th>
                        <th>Registrado por</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (establecimientos.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="text-center">No hay establecimientos que coincidan con los criterios de búsqueda o no hay registros.</td>
                        </tr>
                    <% } else {
                        for (Establecimiento est : establecimientos) {
                            String claseEstado = "";
                            String textoEstado = est.getEstado();
                            if ("aprobado".equalsIgnoreCase(est.getEstado())) claseEstado = "estado-aprobado";
                            else if ("rechazado".equalsIgnoreCase(est.getEstado())) claseEstado = "estado-rechazado";
                            else if ("en proceso".equalsIgnoreCase(est.getEstado())) claseEstado = "estado-en-proceso";
                            else textoEstado = est.getEstado() != null ? est.getEstado() : "No definido";
                    %>
                        <tr>
                            <td><%= est.getIdEstablecimiento() %></td>
                            <td><%= est.getNombre() %></td>
                            <td><%= est.getNombreTipoEstablecimiento() != null ? est.getNombreTipoEstablecimiento() : "N/A" %></td>
                            <td><%= est.getDireccion() != null ? est.getDireccion() : "N/A" %></td>
                            <td><span class="<%= claseEstado %>"><%= textoEstado %></span></td>
                            <td><%= est.getFechaRegistro() != null ? sdf.format(est.getFechaRegistro()) : "N/A" %></td>
                            <td><%= est.getNombreUsuarioRegistro() != null ? est.getNombreUsuarioRegistro() : "Sistema" %></td>
                            <td class="action-icons">
                                <a href="ControladorEstablecimiento?accion=verdetalle&id=<%= est.getIdEstablecimiento() %>" class="text-info" title="Ver Detalles"><i class="fas fa-eye"></i></a>
                                <a href="ControladorInspeccion?accion=listarporestablecimiento&idEstablecimiento=<%= est.getIdEstablecimiento() %>" class="text-primary" title="Ver Inspecciones"><i class="fas fa-clipboard-list"></i></a>
                                <% if (puedeCambiarEstado) { %>
                                    <a href="ControladorInspeccion?accion=mostrarformregistro&idEstablecimiento=<%= est.getIdEstablecimiento() %>" class="text-success" title="Registrar Inspección"><i class="fas fa-file-medical-alt"></i></a>
                                    <a href="ControladorEstablecimiento?accion=mostrarformcambiarestado&idEstablecimiento=<%= est.getIdEstablecimiento() %>" class="text-warning" title="Cambiar Estado Establecimiento"><i class="fas fa-exchange-alt"></i></a>
                                <% } %>
                                <% if ("admin".equalsIgnoreCase(rolUsuarioLogueado)) { %>
                                    <a href="ControladorEstablecimiento?accion=verhistorial&idEstablecimiento=<%= est.getIdEstablecimiento() %>" class="text-secondary" title="Ver Historial de Cambios"><i class="fas fa-history"></i></a>
                                    <a href="ControladorEstablecimiento?accion=solicitareliminacion&idEstablecimiento=<%= est.getIdEstablecimiento() %>" 
                                        class="text-danger" 
                                        title="Eliminar Establecimiento" 
                                        onclick="return confirm('¿Está seguro de que desea iniciar el proceso para eliminar lógicamente el establecimiento \"<%= est.getNombre().replace("\"", "'") %>\"? Se le pedirá un motivo.');">
                                        <i class="fas fa-trash-alt"></i>
                                     </a>
                                <% } %>
                                <% if (puedeCambiarEstado) { // La variable 'puedeCambiarEstado' ya existe y cubre admin/inspector %>
                                    <a href="ControladorEstablecimiento?accion=mostrarformeditar&idEstablecimiento=<%= est.getIdEstablecimiento() %>" class="text-primary" title="Editar Establecimiento"><i class="fas fa-edit"></i></a>
                                <% } %>
                            </td>
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