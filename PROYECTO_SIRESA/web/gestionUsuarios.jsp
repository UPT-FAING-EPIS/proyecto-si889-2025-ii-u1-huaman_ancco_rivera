<%-- 
    Document   : gestionUsuarios
    Created on : 2 jun. 2025, 11:05:44
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Gestión de Usuarios</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .container h1 { margin-bottom: 20px; }
        .table th, .table td { vertical-align: middle; }
        .action-icons a { margin-right: 10px; font-size: 1.2em;}
        .badge-activo { background-color: #28a745; color: white; }
        .badge-inactivo { background-color: #dc3545; color: white; }
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        int usuarioLogueadoId = -1;

        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
             if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoGU");
                return;
            }
            usuarioLogueadoId = usuarioLogueado.getIdUsuario();
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaGU");
            return;
        }
        
        List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
        if (usuarios == null) {
            usuarios = new ArrayList<>();
        }
    %>

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
        <div class="ml-auto">
             <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center">
            <h1><i class="fas fa-users-cog"></i> Gestión de Usuarios</h1>
            <a href="ControladorUsuario?accion=nuevo" class="btn btn-success"><i class="fas fa-user-plus"></i> Agregar Nuevo Usuario</a>
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
        %>

        <div class="table-responsive">
            <table class="table table-hover table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Usuario</th>
                        <th>Nombre Completo</th>
                        <th>Correo Electrónico</th>
                        <th>Rol</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (usuarios.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="text-center">No hay usuarios registrados.</td>
                        </tr>
                    <% } else {
                        for (Usuario u : usuarios) {
                    %>
                        <tr>
                            <td><%= u.getIdUsuario() %></td>
                            <td><%= u.getNombreUsuario() %></td>
                            <td><%= u.getNombreCompleto() == null ? "" : u.getNombreCompleto() %></td>
                            <td><%= u.getCorreoElectronico() == null ? "" : u.getCorreoElectronico() %></td>
                            <td><%= u.getRol() %></td>
                            <td>
                                <% if (u.isActivo()) { %>
                                    <span class="badge badge-activo">Activo</span>
                                <% } else { %>
                                    <span class="badge badge-inactivo">Inactivo</span>
                                <% } %>
                            </td>
                            <td class="action-icons">
                                <a href="ControladorUsuario?accion=editar&id=<%= u.getIdUsuario() %>" class="text-primary" title="Editar"><i class="fas fa-edit"></i></a>
                                <% if (u.getIdUsuario() != usuarioLogueadoId) { %>
                                    <a href="ControladorUsuario?accion=eliminar&id=<%= u.getIdUsuario() %>" 
                                       class="text-danger" title="Eliminar" 
                                       onclick="return confirm('¿Está seguro de que desea eliminar a este usuario: <%= u.getNombreUsuario() %>? Esta acción no se puede deshacer.');">
                                       <i class="fas fa-trash-alt"></i>
                                    </a>
                                <% } else { %>
                                    <span class="text-muted" title="No puedes eliminar tu propia cuenta"><i class="fas fa-trash-alt"></i></span>
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
                $(".alert").fadeTo(500, 0).slideUp(500, function(){
                    $(this).remove(); 
                });
            }, 5000);
        });
    </script>
</body>
</html>
