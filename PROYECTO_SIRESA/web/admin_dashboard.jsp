<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Dashboard Administrador</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .card-link { text-decoration: none; color: inherit; }
        .card-link .card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            height: 100%;
        }
        .card-link .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        .card-body {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .card-title { margin-top: 10px; }
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario userLogueado = null;
        String nombreUsuario = "Invitado";

        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            userLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            if (!"admin".equalsIgnoreCase(userLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegado");
                return;
            }
            nombreUsuario = userLogueado.getNombreCompleto() != null && !userLogueado.getNombreCompleto().isEmpty() ? userLogueado.getNombreCompleto() : userLogueado.getNombreUsuario();
        } else {
            response.sendRedirect("login.jsp?error=SesionExpirada");
            return;
        }
    %>

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <span class="navbar-text text-white mr-3">
                        Bienvenido, <%= nombreUsuario %>
                    </span>
                </li>
                <li class="nav-item">
                    <a class="btn btn-danger" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="jumbotron bg-light p-4 mb-4">
            <h1 class="display-5"><i class="fas fa-tachometer-alt"></i> Panel de Administración</h1>
            <p class="lead">Gestione los recursos del sistema desde esta interfaz.</p>
        </div>

        <%
            String mensajeErrorGeneral = (String) request.getParameter("error");
            if (mensajeErrorGeneral != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <% if("AccesoDenegado".equals(mensajeErrorGeneral)) { %>
                    Acceso denegado a la sección solicitada.
                <% } else { %>
                    <%= mensajeErrorGeneral %>
                <% } %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        <%
            }
            String mensajeExitoGeneral = (String) session.getAttribute("mensajeExito");
            if (mensajeExitoGeneral != null) {
        %>
             <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= mensajeExitoGeneral %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        <%
                session.removeAttribute("mensajeExito");
            }
        %>

        <div class="row">
            <div class="col-md-4 mb-4">
                 <a href="ControladorUsuario?accion=listar" class="card-link">
                    <div class="card text-center">
                        <div class="card-body">
                            <div>
                                <i class="fas fa-users fa-3x text-primary mb-2"></i>
                                <h5 class="card-title">Gestionar Usuarios</h5>
                            </div>
                            <p class="card-text">Administrar cuentas de todos los roles del sistema.</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-md-4 mb-4">
                 <a href="ControladorEstablecimiento?accion=listar" class="card-link">
                    <div class="card text-center">
                        <div class="card-body">
                             <div>
                                <i class="fas fa-store-alt fa-3x text-success mb-2"></i>
                                <h5 class="card-title">Gestionar Establecimientos</h5>
                            </div>
                            <p class="card-text">Ver, registrar y actualizar estado de establecimientos.</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-md-4 mb-4">
                 <a href="ControladorEstablecimiento?accion=mostrarmapa" class="card-link">
                    <div class="card text-center">
                        <div class="card-body">
                            <div>
                                <i class="fas fa-map-marked-alt fa-3x text-danger mb-2"></i>
                                <h5 class="card-title">Mapa de Establecimientos</h5>
                            </div>
                            <p class="card-text">Visualizar establecimientos en el mapa geográfico.</p>
                        </div>
                    </div>
                </a>
            </div>
             <div class="col-md-4 mb-4">
                 <a href="ControladorReporte?accion=mostrarformulario" class="card-link">
                    <div class="card text-center">
                        <div class="card-body">
                            <div>
                                <i class="fas fa-chart-line fa-3x text-info mb-2"></i>
                                <h5 class="card-title">Generar Reportes</h5>
                            </div>
                            <p class="card-text">Visualizar estadísticas y reportes del sistema.</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-md-4 mb-4">
                 <a href="ControladorAuditoria?accion=verCambiosRecientes" class="card-link">
                    <div class="card text-center">
                        <div class="card-body">
                            <div>
                                <i class="fas fa-history fa-3x text-secondary mb-2"></i>
                                <h5 class="card-title">Ver Historial de Cambios</h5>
                            </div>
                            <p class="card-text">Auditar modificaciones recientes en los establecimientos.</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>