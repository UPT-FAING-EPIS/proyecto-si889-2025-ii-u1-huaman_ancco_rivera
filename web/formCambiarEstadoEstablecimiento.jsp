<%-- 
    Document   : formCambiarEstadoEstablecimiento
    Created on : 2 jun. 2025, 12:23:17
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Establecimiento"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Establecimiento establecimiento = (Establecimiento) request.getAttribute("establecimiento");
        if (establecimiento == null) {
            response.sendRedirect("ControladorEstablecimiento?accion=listar&error=EstNoEncontradoParaEstado");
            return;
        }
        String tituloPagina = "Cambiar Estado del Establecimiento";
    %>
    <title>SIRESA - <%= tituloPagina %></title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .form-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-container h1 { margin-bottom: 10px;}
        .establecimiento-info { margin-bottom: 20px; padding: 15px; background-color: #e9ecef; border-radius: .25rem; }
        .establecimiento-info strong { display: inline-block; min-width: 150px;}
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            if (!("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol()))) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoFormCambioEst");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaFormCambioEst");
            return;
        }
        String dashboardLink = "";
        String navBarColor = "bg-warning";
        if ("admin".equals(usuarioLogueado.getRol())) {
            dashboardLink = "admin_dashboard.jsp";
            navBarColor = "bg-primary";
        } else if ("inspector".equals(usuarioLogueado.getRol())) {
            dashboardLink = "inspector_dashboard.jsp";
            navBarColor = "bg-success";
        }
    %>
    <nav class="navbar navbar-expand-lg navbar-dark <%= navBarColor %>">
        <a class="navbar-brand" href="<%= dashboardLink %>"><i class="fas fa-tachometer-alt"></i> SIRESA</a>
         <div class="ml-auto">
             <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container mt-4 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">
                <div class="form-container">
                    <h1><i class="fas fa-exchange-alt"></i> <%= tituloPagina %></h1>
                    
                    <div class="establecimiento-info">
                        <p><strong>ID Establecimiento:</strong> <%= establecimiento.getIdEstablecimiento() %></p>
                        <p><strong>Nombre:</strong> <%= establecimiento.getNombre() %></p>
                        <p><strong>Estado Actual:</strong> <span class="font-weight-bold 
                            <% if ("aprobado".equalsIgnoreCase(establecimiento.getEstado())) out.print("text-success");
                               else if ("rechazado".equalsIgnoreCase(establecimiento.getEstado())) out.print("text-danger");
                               else if ("en proceso".equalsIgnoreCase(establecimiento.getEstado())) out.print("text-warning"); %>
                            "><%= establecimiento.getEstado() %></span>
                        </p>
                    </div>
                    <hr>
                    <%
                        String mensajeErrorForm = (String) session.getAttribute("mensajeErrorFormCambioEstado");
                        if (mensajeErrorForm != null) {
                    %>
                        <div class="alert alert-danger" role="alert">
                            <%= mensajeErrorForm %>
                        </div>
                    <%
                            session.removeAttribute("mensajeErrorFormCambioEstado");
                        }
                    %>
                    <form id="formCambiarEstado" method="POST" action="ControladorEstablecimiento">
                        <input type="hidden" name="accion" value="actualizarestado">
                        <input type="hidden" name="idEstablecimiento" value="<%= establecimiento.getIdEstablecimiento() %>">

                        <div class="form-group">
                            <label for="selNuevoEstado">Seleccione el Nuevo Estado <span class="text-danger">*</span></label>
                            <select class="form-control" id="selNuevoEstado" name="selNuevoEstado" required>
                                <option value="">Seleccione...</option>
                                <option value="aprobado" <%= "aprobado".equals(establecimiento.getEstado()) ? "disabled" : "" %>>Aprobado</option>
                                <option value="rechazado" <%= "rechazado".equals(establecimiento.getEstado()) ? "disabled" : "" %>>Rechazado</option>
                                <option value="en proceso" <%= "en proceso".equals(establecimiento.getEstado()) ? "disabled" : "" %>>En Proceso</option>
                            </select>
                            <small class="form-text text-muted">No puede seleccionar el estado actual.</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="txtMotivoCambio">Motivo del Cambio <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="txtMotivoCambio" name="txtMotivoCambio" rows="3" required placeholder="Describa brevemente la razón del cambio de estado. Esta información quedará en el historial."></textarea>
                        </div>
                        
                        <hr>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-check-circle"></i> Guardar Cambio de Estado</button>
                        <a href="ControladorEstablecimiento?accion=listar" class="btn btn-secondary"><i class="fas fa-times"></i> Cancelar</a>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
