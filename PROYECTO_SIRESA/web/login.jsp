<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Iniciar Sesión</title>
    
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            color: #e0e0e0;
            background-color: #242c3c;
            background-image: linear-gradient(135deg, #1c222e 0%, #2a3140 80%);
        }

        .page-logo {
            position: fixed;
            top: 25px;
            left: 30px;
            width: 100px;
            height: auto;
            z-index: 1000;
        }

        .main-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
            padding: 15px;
        }

        .login-card {
            background-color: rgba(47, 54, 71, 0.5); 
            border: 1px solid #3b4354;
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 420px;
        }

        .login-title {
            text-align: center;
            font-size: 2.2rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: 1px;
            margin-bottom: 1.5rem;
        }
        .login-title i, .btn-login, .form-control:focus {
            --accent-color: #f0b90b; 
        }
        .login-title i {
            color: var(--accent-color);
        }

        .form-group label {
            font-weight: 600;
            color: #b0b0b0;
            font-size: 0.9rem;
        }
        
        .form-control {
            background-color: #2a3140;
            color: #f1f1f1;
            border: 1px solid #4a5264;
            border-radius: 8px;
            padding: 1.25rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: #2a3140;
            color: #f1f1f1;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(240, 185, 11, 0.25);
        }

        .form-control::placeholder {
            color: #777;
        }

        .btn-login {
            background-color: var(--accent-color);
            border: none;
            border-radius: 8px;
            padding: 15px;
            font-size: 1rem;
            font-weight: 700;
            color: #121212; 
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(240, 185, 11, 0.2);
        }

        .btn-login:hover {
            background-color: #ffca2c;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(240, 185, 11, 0.3);
        }
        
        .alert-custom {
            font-size: 0.9rem;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <img src="img/logo-regional.png" alt="Logo Región Tacna" class="page-logo">

    <div class="main-container">
        <div class="login-card">
            <h2 class="login-title"><i class="fas fa-shield-alt"></i> SIRESA</h2>

            <%
                String mensajeError = (String) request.getAttribute("mensajeError");
                if (mensajeError != null) {
            %>
                <div class="alert alert-danger alert-custom" role="alert">
                    <%= mensajeError %>
                </div>
            <%
                }
                String mensajeLogout = (String) request.getParameter("logout");
                if (mensajeLogout != null && mensajeLogout.equals("true")) {
            %>
                <div class="alert alert-success alert-custom" role="alert">
                    Has cerrado sesión correctamente.
                </div>
            <%
                }
            %>

            <form method="POST" action="ControladorLogin">
                <div class="form-group">
                    <label for="txtUsuario">Usuario</label>
                    <input type="text" class="form-control" id="txtUsuario" name="txtUsuario" placeholder="Nombre de usuario" required autofocus>
                </div>
                <div class="form-group">
                    <label for="txtPassword">Contraseña</label>
                    <input type="password" class="form-control" id="txtPassword" name="txtPassword" placeholder="Contraseña" required>
                </div>
                <button type="submit" class="btn btn-login btn-block mt-4">Iniciar Sesión</button>
            </form>
            <div class="text-center mt-4">
                <small style="color: #888;">Sistema de Revisión de Establecimientos de Salud Alimentaria</small>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>