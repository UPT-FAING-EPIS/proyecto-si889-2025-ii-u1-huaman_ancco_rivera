<%-- 
    Document   : formUsuario
    Created on : 2 jun. 2025, 11:06:30
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Usuario usuarioEditar = (Usuario) request.getAttribute("usuarioEditar");
        boolean esNuevo = (Boolean) request.getAttribute("esNuevo");
        String tituloPagina = esNuevo ? "Agregar Nuevo Usuario" : "Editar Usuario";
        String accionForm = esNuevo ? "agregar" : "actualizar";
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
        .form-container h1 { margin-bottom: 25px;}
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoForm");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaForm");
            return;
        }
    %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
         <div class="ml-auto">
             <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">
                <div class="form-container">
                    <h1><i class="fas <%= esNuevo ? "fa-user-plus" : "fa-user-edit" %>"></i> <%= tituloPagina %></h1>
                     <%-- Mostrar mensajes de error del formulario --%>
                    <%
                        String mensajeError = (String) request.getAttribute("mensajeError");
                        if (mensajeError != null) {
                    %>
                        <div class="alert alert-danger" role="alert">
                            <%= mensajeError %>
                        </div>
                    <%
                        }
                    %>
                    <form id="formUsuario" method="POST" action="ControladorUsuario">
                        <input type="hidden" name="accion" value="<%= accionForm %>">
                        <% if (!esNuevo) { %>
                            <input type="hidden" name="idUsuario" value="<%= usuarioEditar.getIdUsuario() %>">
                        <% } %>

                        <div class="form-group">
                            <label for="txtNombreUsuario">Nombre de Usuario <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="txtNombreUsuario" name="txtNombreUsuario" 
                                   value="<%= usuarioEditar != null && usuarioEditar.getNombreUsuario() != null ? usuarioEditar.getNombreUsuario() : "" %>" 
                                   required <%= !esNuevo && usuarioEditar.getNombreUsuario().equals("admin") ? "readonly" : "" %> >
                            <% if(!esNuevo && usuarioEditar.getNombreUsuario().equals("admin")) { %>
                                <small class="form-text text-muted">El nombre de usuario 'admin' no se puede modificar.</small>
                            <% } %>
                        </div>

                        <div class="form-group">
                            <label for="txtContrasena">Contraseña <% if(esNuevo){ %><span class="text-danger">*</span><% } %></label>
                            <input type="password" class="form-control" id="txtContrasena" name="txtContrasena" 
                                   placeholder="<%=(esNuevo ? "Ingrese contraseña" : "Dejar en blanco para no cambiar")%>" 
                                   <%= (esNuevo ? "required" : "") %>>
                            <% if(!esNuevo){ %> <small class="form-text text-muted">Dejar en blanco si no desea cambiar la contraseña actual.</small> <% } %>
                        </div>
                        
                        <div class="form-group">
                            <label for="txtConfirmarContrasena">Confirmar Contraseña <% if(esNuevo){ %><span class="text-danger">*</span><% } %></label>
                            <input type="password" class="form-control" id="txtConfirmarContrasena" name="txtConfirmarContrasena"
                                   placeholder="<%=(esNuevo ? "Repita la contraseña" : "Repita la nueva contraseña si la ingresó")%>"
                                   <%= (esNuevo ? "required" : "") %>>
                        </div>


                        <div class="form-group">
                            <label for="txtNombreCompleto">Nombre Completo <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="txtNombreCompleto" name="txtNombreCompleto" 
                                   value="<%= usuarioEditar != null && usuarioEditar.getNombreCompleto() != null ? usuarioEditar.getNombreCompleto() : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label for="txtCorreo">Correo Electrónico</label>
                            <input type="email" class="form-control" id="txtCorreo" name="txtCorreo" 
                                   value="<%= usuarioEditar != null && usuarioEditar.getCorreoElectronico() != null ? usuarioEditar.getCorreoElectronico() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="selRol">Rol <span class="text-danger">*</span></label>
                            <select class="form-control" id="selRol" name="selRol" required 
                                    <%= !esNuevo && usuarioEditar.getNombreUsuario().equals("admin") ? "disabled" : "" %>>
                                <option value="admin" <%= (usuarioEditar != null && "admin".equals(usuarioEditar.getRol())) ? "selected" : "" %>>Administrador</option>
                                <option value="inspector" <%= (usuarioEditar != null && "inspector".equals(usuarioEditar.getRol())) ? "selected" : "" %>>Inspector</option>
                                <option value="ciudadano" <%= (usuarioEditar != null && "ciudadano".equals(usuarioEditar.getRol())) ? "selected" : "" %>>Ciudadano</option>
                            </select>
                            <% if(!esNuevo && usuarioEditar.getNombreUsuario().equals("admin")) { %>
                                <input type="hidden" name="selRol" value="admin"/> <small class="form-text text-muted">El rol del usuario 'admin' no se puede modificar.</small>
                            <% } %>
                        </div>

                        <div class="form-group form-check">
                            <input type="checkbox" class="form-check-input" id="chkActivo" name="chkActivo" 
                                   <%= (esNuevo || (usuarioEditar != null && usuarioEditar.isActivo())) ? "checked" : "" %>
                                   <%= !esNuevo && usuarioEditar.getNombreUsuario().equals("admin") ? "disabled onclick='return false;'" : "" %>>
                            <label class="form-check-label" for="chkActivo">Activo</label>
                             <% if(!esNuevo && usuarioEditar.getNombreUsuario().equals("admin")) { %>
                                <input type="hidden" name="chkActivo" value="on"/> <small class="form-text text-muted d-block">El usuario 'admin' principal no puede ser desactivado.</small>
                            <% } %>
                        </div>
                        <hr>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> <%= esNuevo ? "Guardar Usuario" : "Actualizar Usuario" %></button>
                        <a href="ControladorUsuario?accion=listar" class="btn btn-secondary"><i class="fas fa-times"></i> Cancelar</a>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        document.getElementById('formUsuario').addEventListener('submit', function(event) {
            var password = document.getElementById('txtContrasena').value;
            var confirmPassword = document.getElementById('txtConfirmarContrasena').value;
            var esNuevo = <%= esNuevo %>;

            if (password !== confirmPassword) {
                alert('Las contraseñas no coinciden.');
                event.preventDefault();
                return false;
            }

            if (esNuevo && password.trim() === '') {
                 alert('El campo contraseña es obligatorio para nuevos usuarios.');
                event.preventDefault(); 
                return false;
            }
            return true;
        });
    </script>
</body>
</html>
