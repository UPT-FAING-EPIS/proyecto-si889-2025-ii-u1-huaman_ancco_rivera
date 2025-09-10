<%-- 
    Document   : inspecto_dashboard
    Created on : 2 jun. 2025, 10:36:53
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Dashboard Inspector</title>
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
            if (!"inspector".equalsIgnoreCase(userLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegado");
                return;
            }
            nombreUsuario = userLogueado.getNombreCompleto() != null && !userLogueado.getNombreCompleto().isEmpty() ? userLogueado.getNombreCompleto() : userLogueado.getNombreUsuario();
        } else {
            response.sendRedirect("login.jsp?error=SesionExpirada");
            return;
        }
    %>

    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <a class="navbar-brand" href="inspector_dashboard.jsp"><i class="fas fa-clipboard-check"></i> SIRESA Inspector</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <span class="navbar-text text-white mr-3">
                        Inspector: <%= nombreUsuario %>
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
            <h1 class="display-5"><i class="fas fa-tasks"></i> Panel de Inspector</h1>
            <p class="lead">Realice sus tareas de inspección y registro de establecimientos.</p>
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
                 <a href="ControladorEstablecimiento?accion=mostrarformregistro" class="card-link">
                    <div class="card text-center">
                        <div class="card-body">
                            <div>
                                <i class="fas fa-plus-circle fa-3x text-primary mb-2"></i>
                                <h5 class="card-title">Registrar Nuevo Establecimiento</h5>
                            </div>
                            <p class="card-text">Dar de alta nuevos establecimientos en el sistema.</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-md-4 mb-4">
                 <a href="ControladorEstablecimiento?accion=listar" class="card-link">
                    <div class="card text-center">
                        <div class="card-body">
                            <div>
                                <i class="fas fa-list-alt fa-3x text-info mb-2"></i>
                                <h5 class="card-title">Ver Establecimientos</h5>
                            </div>
                            <p class="card-text">Consultar la lista y estado de los establecimientos.</p>
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
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
