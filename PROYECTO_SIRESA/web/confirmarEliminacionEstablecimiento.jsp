<%-- 
    Document   : confirmarEliminacionEstablecimiento
    Created on : 3 jun. 2025, 08:57:10
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
        Establecimiento establecimiento = (Establecimiento) request.getAttribute("establecimientoParaEliminar");
        if (establecimiento == null) {
            response.sendRedirect("ControladorEstablecimiento?accion=listar&error=EstNoDispParaConfirmarElim");
            return;
        }
        String tituloPagina = "Confirmar Eliminación - " + establecimiento.getNombre();
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
            margin-top: 30px;
        }
        .form-container h1 { margin-bottom: 10px; color: #dc3545;}
        .establecimiento-info { margin-bottom: 20px; padding: 15px; background-color: #ffeedd; border: 1px solid #ffc107; border-radius: .25rem; }
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoConfirmElim");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaConfirmElim");
            return;
        }
    %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-danger"> <%-- Navbar roja para acción de eliminación --%>
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin - Eliminación</a>
         <div class="ml-auto">
             <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">
                <div class="form-container">
                    <h1><i class="fas fa-exclamation-triangle"></i> Confirmar Eliminación Lógica</h1>
                    <p>Está a punto de eliminar lógicamente (desactivar) el siguiente establecimiento. Esta acción registrará un motivo y el establecimiento ya no aparecerá en las listas públicas.</p>
                    
                    <div class="establecimiento-info">
                        <p><strong>ID Establecimiento:</strong> <%= establecimiento.getIdEstablecimiento() %></p>
                        <p><strong>Nombre:</strong> <%= establecimiento.getNombre() %></p>
                        <p><strong>Dirección:</strong> <%= establecimiento.getDireccion() != null ? establecimiento.getDireccion() : "N/D" %></p>
                        <p><strong>Estado Actual:</strong> <%= establecimiento.getEstado() %></p>
                    </div>
                    <hr>
                     <%
                        String mensajeErrorForm = (String) request.getAttribute("mensajeErrorFormEliminacion");
                        if (mensajeErrorForm != null) {
                    %>
                        <div class="alert alert-danger" role="alert">
                            <%= mensajeErrorForm %>
                        </div>
                    <%
                        }
                    %>
                    <form id="formConfirmarEliminacion" method="POST" action="ControladorEstablecimiento">
                        <input type="hidden" name="accion" value="ejecutareliminacion">
                        <input type="hidden" name="idEstablecimiento" value="<%= establecimiento.getIdEstablecimiento() %>">

                        <div class="form-group">
                            <label for="txtMotivoEliminacion">Motivo de la Eliminación <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="txtMotivoEliminacion" name="txtMotivoEliminacion" rows="3" required placeholder="Describa brevemente por qué se está eliminando este establecimiento."></textarea>
                        </div>
                        
                        <hr>
                        <button type="submit" class="btn btn-danger"><i class="fas fa-trash-alt"></i> Sí, Eliminar Lógicamente</button>
                        <a href="ControladorEstablecimiento?accion=verdetalle&id=<%= establecimiento.getIdEstablecimiento() %>" class="btn btn-secondary">
                            <i class="fas fa-times"></i> No, Cancelar
                        </a>
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