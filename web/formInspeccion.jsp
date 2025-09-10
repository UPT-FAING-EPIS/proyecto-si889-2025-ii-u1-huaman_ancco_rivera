<%-- 
    Document   : formInspeccion
    Created on : 2 jun. 2025, 13:09:25
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Establecimiento"%>
<%@page import="modelo.Inspeccion"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Establecimiento establecimiento = (Establecimiento) request.getAttribute("establecimiento");
        Inspeccion inspeccion = (Inspeccion) request.getAttribute("inspeccion");
        String fechaActual = (String) request.getAttribute("fechaActual");

        if (establecimiento == null) {
            response.sendRedirect("ControladorEstablecimiento?accion=listar&error=EstNoEncontradoParaInsp");
            return;
        }
        if (inspeccion == null) {
            inspeccion = new Inspeccion();
        }
        if (fechaActual == null) {
            fechaActual = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        
        String tituloPagina = "Registrar Inspección";
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
                response.sendRedirect("login.jsp?error=AccesoDenegadoFormInsp");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaFormInsp");
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
        <a class="navbar-brand" href="<%= dashboardLink %>"><i class="fas fa-clipboard-list"></i> SIRESA Inspección</a>
         <div class="ml-auto">
             <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container mt-4 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">
                <div class="form-container">
                    <h1><i class="fas fa-file-medical-alt"></i> <%= tituloPagina %></h1>
                    
                    <div class="establecimiento-info">
                        <p><strong>Establecimiento:</strong> <%= establecimiento.getNombre() %></p>
                        <p><strong>Dirección:</strong> <%= establecimiento.getDireccion() != null ? establecimiento.getDireccion() : "N/A" %></p>
                        <p><strong>ID:</strong> <%= establecimiento.getIdEstablecimiento() %></p>
                    </div>
                    <hr>
                    <%
                        String mensajeErrorForm = (String) session.getAttribute("mensajeErrorFormInspeccion"); 
                        if (mensajeErrorForm == null) { 
                            mensajeErrorForm = (String) request.getAttribute("mensajeError");
                        }
                        if (mensajeErrorForm != null) {
                    %>
                        <div class="alert alert-danger" role="alert">
                            <%= mensajeErrorForm %>
                        </div>
                    <%
                            if (session.getAttribute("mensajeErrorFormInspeccion") != null) {
                                session.removeAttribute("mensajeErrorFormInspeccion");
                            }
                        }
                    %>
                    <form id="formInspeccion" method="POST" action="ControladorInspeccion">
                        <input type="hidden" name="accion" value="registrar">
                        <input type="hidden" name="idEstablecimiento" value="<%= establecimiento.getIdEstablecimiento() %>">

                        <div class="form-group">
                            <label for="txtFechaInspeccion">Fecha de Inspección <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="txtFechaInspeccion" name="txtFechaInspeccion" 
                                   value="<%= inspeccion.getFechaInspeccion() != null ? new SimpleDateFormat("yyyy-MM-dd").format(inspeccion.getFechaInspeccion()) : fechaActual %>" 
                                   required>
                        </div>
                        
                        <div class="form-group">
                            <label for="selResultado">Resultado de la Inspección <span class="text-danger">*</span></label>
                            <select class="form-control" id="selResultado" name="selResultado" required>
                                <option value="">Seleccione un resultado...</option>
                                <option value="aprobado" <%= "aprobado".equals(inspeccion.getResultado()) ? "selected" : "" %>>Aprobado</option>
                                <option value="rechazado" <%= "rechazado".equals(inspeccion.getResultado()) ? "selected" : "" %>>Rechazado</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="txtObservaciones">Observaciones</label>
                            <textarea class="form-control" id="txtObservaciones" name="txtObservaciones" rows="4" placeholder="Detalle aquí los hallazgos, incumplimientos, recomendaciones, etc."><%= inspeccion.getObservaciones() != null ? inspeccion.getObservaciones() : "" %></textarea>
                        </div>
                        
                        <hr>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Registrar Inspección</button>
                        <a href="ControladorEstablecimiento?accion=verdetalle&id=<%= establecimiento.getIdEstablecimiento() %>" class="btn btn-secondary"><i class="fas fa-times"></i> Cancelar</a>
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
