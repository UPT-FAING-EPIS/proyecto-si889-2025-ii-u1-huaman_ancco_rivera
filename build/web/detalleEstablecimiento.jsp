<%-- 
    Document   : detalleEstablecimiento
    Created on : 2 jun. 2025, 13:18:27
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Establecimiento"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Establecimiento establecimiento = (Establecimiento) request.getAttribute("establecimiento");

        if (establecimiento == null) {
            out.println("<p>Error: Establecimiento no encontrado. Serás redirigido.</p>");
            response.setHeader("Refresh", "3;url=ControladorEstablecimiento?accion=listar");
            return;
        }
        
        String tituloPagina = "Detalles del Establecimiento: " + establecimiento.getNombre();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        String rolUsuarioLogueado = "";
        boolean puedeGestionarEstado = false;
        boolean puedeVerHistorial = false;
        boolean puedeEditarEstablecimiento = false;

        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            rolUsuarioLogueado = usuarioLogueado.getRol().toLowerCase();
            if ("admin".equals(rolUsuarioLogueado)) {
                puedeGestionarEstado = true;
                puedeVerHistorial = true;
                puedeEditarEstablecimiento = true;
            } else if ("inspector".equals(rolUsuarioLogueado)) {
                puedeGestionarEstado = true;
            }
        }
        
        boolean tieneCoordenadas = establecimiento.getLatitud() != null && establecimiento.getLongitud() != null;
    %>
    <title>SIRESA - <%= tituloPagina %></title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .container-fluid h1 { margin-bottom: 10px; }
        .container-fluid .lead { margin-bottom: 20px; font-size: 1.1em; color: #6c757d;}
        .detail-card {
            background-color: #fff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .detail-section-title {
            margin-top: 20px;
            margin-bottom: 10px;
            font-size: 1.3em;
            color: #007bff;
            border-bottom: 1px solid #007bff30;
            padding-bottom: 8px;
        }
        .detail-item strong { display: inline-block; min-width: 180px; color: #495057;}
        .detail-item span { color: #212529; }
        .actions-bar { margin-top: 25px; padding-top:15px; border-top: 1px solid #dee2e6;}
        .actions-bar .btn { margin-right: 10px; margin-bottom: 10px;}
        .estado-aprobado { color: #28a745; font-weight: bold; }
        .estado-rechazado { color: #dc3545; font-weight: bold; }
        .estado-en-proceso { color: #ffc107; font-weight: bold; }
        #mapDetail {
            height: 300px;
            width: 100%;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <%
        String dashboardLink = "ControladorEstablecimiento?accion=listar"; 
        String navBarColor = "bg-dark";
        if (usuarioLogueado != null) {
            if ("admin".equals(rolUsuarioLogueado)) {
                dashboardLink = "admin_dashboard.jsp"; navBarColor = "bg-primary";
            } else if ("inspector".equals(rolUsuarioLogueado)) {
                dashboardLink = "inspector_dashboard.jsp"; navBarColor = "bg-success";
            } else if ("ciudadano".equals(rolUsuarioLogueado)) {
                 dashboardLink = "ciudadano_dashboard.jsp"; navBarColor = "bg-secondary";
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaDetalleEst");
            return;
        }
    %>
    <nav class="navbar navbar-expand-lg navbar-dark <%= navBarColor %>">
        <a class="navbar-brand" href="<%= dashboardLink %>"><i class="fas fa-building"></i> SIRESA</a>
         <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="ControladorEstablecimiento?accion=listar">Establecimientos</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Detalle: <%= establecimiento.getNombre() %></a></li>
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
                <h1><i class="fas fa-info-circle"></i> Detalles del Establecimiento</h1>
                <p class="lead" id="nombreEstablecimiento"><%= establecimiento.getNombre() %></p>
            </div>
            <a href="ControladorEstablecimiento?accion=listar" class="btn btn-outline-secondary"><i class="fas fa-arrow-left"></i> Volver a la Lista</a>
        </div>
        <hr>
        
        <%
            String mensajeExito = (String) session.getAttribute("mensajeExito");
            if (mensajeExito != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= mensajeExito %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
        <%
                session.removeAttribute("mensajeExito");
            }
            String mensajeError = (String) session.getAttribute("mensajeError");
            if (mensajeError != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= mensajeError %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
        <%
                session.removeAttribute("mensajeError");
            }
        %>

        <div class="row">
            <div class="col-lg-8">
                <div class="detail-card">
                    <div class="detail-section-title">Información General</div>
                    <p class="detail-item"><strong>ID Establecimiento:</strong> <span><%= establecimiento.getIdEstablecimiento() %></span></p>
                    <p class="detail-item"><strong>Nombre:</strong> <span><%= establecimiento.getNombre() %></span></p>
                    <p class="detail-item"><strong>Dirección:</strong> <span><%= establecimiento.getDireccion() != null ? establecimiento.getDireccion() : "N/D" %></span></p>
                    <p class="detail-item"><strong>Tipo:</strong> <span><%= establecimiento.getNombreTipoEstablecimiento() != null ? establecimiento.getNombreTipoEstablecimiento() : "N/D" %></span></p>
                    <p class="detail-item"><strong>Estado Actual:</strong> 
                        <span class="font-weight-bold 
                            <% if ("aprobado".equalsIgnoreCase(establecimiento.getEstado())) out.print("estado-aprobado");
                               else if ("rechazado".equalsIgnoreCase(establecimiento.getEstado())) out.print("estado-rechazado");
                               else if ("en proceso".equalsIgnoreCase(establecimiento.getEstado())) out.print("estado-en-proceso"); %>
                            "><%= establecimiento.getEstado() %></span>
                    </p>
                    <p class="detail-item"><strong>Fecha de Registro:</strong> <span><%= establecimiento.getFechaRegistro() != null ? sdf.format(establecimiento.getFechaRegistro()) : "N/D" %></span></p>
                    <p class="detail-item"><strong>Registrado por:</strong> <span><%= establecimiento.getNombreUsuarioRegistro() != null ? establecimiento.getNombreUsuarioRegistro() : "Sistema" %></span></p>

                    <div class="detail-section-title">Información de Contacto</div>
                    <p class="detail-item"><strong>Nombre Contacto:</strong> <span><%= establecimiento.getContactoNombre() != null ? establecimiento.getContactoNombre() : "N/D" %></span></p>
                    <p class="detail-item"><strong>Teléfono Contacto:</strong> <span><%= establecimiento.getContactoTelefono() != null ? establecimiento.getContactoTelefono() : "N/D" %></span></p>
                    <p class="detail-item"><strong>Email Contacto:</strong> <span><%= establecimiento.getContactoEmail() != null ? establecimiento.getContactoEmail() : "N/D" %></span></p>
                    

                    <div class="detail-section-title">Ubicación Geográfica</div>
                    <p class="detail-item"><strong>Latitud:</strong> <span id="detLat"><%= establecimiento.getLatitud() != null ? establecimiento.getLatitud().toPlainString() : "N/D" %></span></p>
                    <p class="detail-item"><strong>Longitud:</strong> <span id="detLng"><%= establecimiento.getLongitud() != null ? establecimiento.getLongitud().toPlainString() : "N/D" %></span></p>
                    
                    <% if (tieneCoordenadas) { %>
                        <div id="mapDetail"></div> 
                    <% } else { %>
                        <p class="text-muted"><small>No hay coordenadas registradas para mostrar en el mapa.</small></p>
                    <% } %>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="detail-card">
                    <div class="detail-section-title">Acciones Disponibles</div>
                    <div class="actions-bar">
                        <a href="ControladorInspeccion?accion=listarporestablecimiento&idEstablecimiento=<%= establecimiento.getIdEstablecimiento() %>" class="btn btn-info btn-block"><i class="fas fa-clipboard-list"></i> Ver Inspecciones</a>
                        
                        <% if (puedeGestionarEstado) { %>
                            <a href="ControladorInspeccion?accion=mostrarformregistro&idEstablecimiento=<%= establecimiento.getIdEstablecimiento() %>" class="btn btn-success btn-block"><i class="fas fa-file-medical-alt"></i> Registrar Inspección</a>
                            <a href="ControladorEstablecimiento?accion=mostrarformcambiarestado&idEstablecimiento=<%= establecimiento.getIdEstablecimiento() %>" class="btn btn-warning btn-block"><i class="fas fa-exchange-alt"></i> Cambiar Estado</a>
                        <% } %>

                        <% if (puedeVerHistorial) { %>
                             <a href="ControladorEstablecimiento?accion=verhistorial&idEstablecimiento=<%= establecimiento.getIdEstablecimiento() %>" class="btn btn-secondary btn-block"><i class="fas fa-history"></i> Ver Historial de Cambios</a>
                        <% } %>
                        
                        <% if (puedeEditarEstablecimiento) { %>
                            <a href="ControladorEstablecimiento?accion=mostrarformeditar&idEstablecimiento=<%= establecimiento.getIdEstablecimiento() %>" class="btn btn-primary btn-block"><i class="fas fa-edit"></i> Editar Datos del Establecimiento</a>
                        <% } %>
                        
                        <% if ("admin".equalsIgnoreCase(rolUsuarioLogueado)) { %>
                            <a href="ControladorEstablecimiento?accion=solicitareliminacion&idEstablecimiento=<%= establecimiento.getIdEstablecimiento() %>" 
                               class="btn btn-danger btn-block" 
                               onclick="return confirm('¿Está seguro de que desea iniciar el proceso para eliminar lógicamente este establecimiento? Se le pedirá un motivo.');">
                               <i class="fas fa-trash-alt"></i> Eliminar Establecimiento
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <% if (tieneCoordenadas) { %>
    <script>
        let mapDetailInstance;
        let markerDetail;
        const estLat = parseFloat('<%= establecimiento.getLatitud().toPlainString() %>');
        const estLng = parseFloat('<%= establecimiento.getLongitud().toPlainString() %>');

        function initMapDetail() {
            mapDetailInstance = new google.maps.Map(document.getElementById("mapDetail"), {
                center: { lat: estLat, lng: estLng },
                zoom: 16, 
                mapTypeControl: false,
                streetViewControl: false,
                zoomControl: true,
                scrollwheel: false, 
                disableDoubleClickZoom: true,
                draggable: false 
            });

            markerDetail = new google.maps.Marker({
                position: { lat: estLat, lng: estLng },
                map: mapDetailInstance,
                title: '<%= establecimiento.getNombre() %>'
            });
        }
    </script>
    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCF37ZcGIG5_Gce3EQXm1ehCNddZbkv_ZY&callback=initMapDetail"></script>
    <% } %>
</body>
</html>