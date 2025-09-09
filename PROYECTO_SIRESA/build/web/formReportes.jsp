<%-- 
    Document   : formReportes
    Created on : 2 jun. 2025, 13:39:41
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Selección de Reportes</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .container h1 { margin-bottom: 20px; }
        .report-card {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .report-card h5 {
            color: #007bff;
        }
        .report-card p {
            flex-grow: 1;
        }
        .report-card form {
            margin-top: auto; 
        }
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoReportForm");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaReportForm");
            return;
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fechaHoy = sdf.format(new Date());
        String inicioDeMes = new SimpleDateFormat("yyyy-MM-01").format(new Date());

        List<Usuario> listaInspectores = (List<Usuario>) request.getAttribute("listaInspectores");
        if (listaInspectores == null) {
            listaInspectores = new ArrayList<>();
        }
    %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-info">
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp">Dashboard</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Reportes</a></li>
            </ul>
            <ul class="navbar-nav ml-auto">
                 <li class="nav-item">
                    <span class="navbar-text text-white mr-3">
                        Admin: <%= usuarioLogueado.getNombreCompleto() != null ? usuarioLogueado.getNombreCompleto() : usuarioLogueado.getNombreUsuario() %>
                    </span>
                </li>
                <li class="nav-item">
                    <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container mt-4">
        <h1><i class="fas fa-chart-pie"></i> Generación de Reportes</h1>
        <p class="lead">Seleccione el tipo de reporte que desea generar y configure los parámetros necesarios.</p>
        <hr>

        <%
            String mensajeErrorReporte = (String) request.getAttribute("mensajeErrorReporte");
            if (mensajeErrorReporte != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= mensajeErrorReporte %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        <%
            }
        %>

        <div class="row">
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="report-card">
                    <h5><i class="fas fa-tags"></i> Establecimientos por Estado</h5>
                    <p>Muestra la cantidad de establecimientos agrupados por su estado actual.</p>
                    <form method="POST" action="ControladorReporte">
                        <input type="hidden" name="accion" value="generarreporteporestado">
                        <button type="submit" class="btn btn-primary btn-block"><i class="fas fa-play-circle"></i> Generar</button>
                    </form>
                </div>
            </div>

            <div class="col-md-6 col-lg-4 mb-4">
                <div class="report-card">
                    <h5><i class="fas fa-calendar-alt"></i> Establecimientos por Periodo</h5>
                    <p>Lista establecimientos registrados dentro de un rango de fechas.</p>
                    <form method="POST" action="ControladorReporte">
                        <input type="hidden" name="accion" value="generarreporteporperiodo">
                        <div class="form-group">
                            <label for="fechaInicioEst" class="small">Fecha de Inicio:</label>
                            <input type="date" class="form-control form-control-sm" id="fechaInicioEst" name="fechaInicio" value="<%= inicioDeMes %>" required>
                        </div>
                        <div class="form-group">
                            <label for="fechaFinEst" class="small">Fecha de Fin:</label>
                            <input type="date" class="form-control form-control-sm" id="fechaFinEst" name="fechaFin" value="<%= fechaHoy %>" required>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block"><i class="fas fa-play-circle"></i> Generar</button>
                    </form>
                </div>
            </div>

            <div class="col-md-6 col-lg-4 mb-4">
                <div class="report-card">
                    <h5><i class="fas fa-chart-bar"></i> Resultados de Inspección</h5>
                    <p>Muestra la cantidad de inspecciones por resultado (Aprobado/Rechazado) en un periodo.</p>
                    <form method="POST" action="ControladorReporte">
                        <input type="hidden" name="accion" value="generarreporteinspeccionesresultado">
                        <div class="form-group">
                            <label for="fechaInicioInspResultado" class="small">Fecha de Inicio Inspección:</label>
                            <input type="date" class="form-control form-control-sm" id="fechaInicioInspResultado" name="fechaInicioInspeccionResultado" value="<%= inicioDeMes %>" required>
                        </div>
                        <div class="form-group">
                            <label for="fechaFinInspResultado" class="small">Fecha de Fin Inspección:</label>
                            <input type="date" class="form-control form-control-sm" id="fechaFinInspResultado" name="fechaFinInspeccionResultado" value="<%= fechaHoy %>" required>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block"><i class="fas fa-play-circle"></i> Generar</button>
                    </form>
                </div>
            </div>

            <div class="col-md-6 col-lg-4 mb-4">
                <div class="report-card">
                    <h5><i class="fas fa-tasks"></i> Detalle de Inspecciones</h5>
                    <p>Lista detallada de inspecciones realizadas en un periodo, opcionalmente filtradas por inspector.</p>
                    <form method="POST" action="ControladorReporte">
                        <input type="hidden" name="accion" value="generarreporteinspeccionesdetallado">
                        <div class="form-group">
                            <label for="fechaInicioInspDetalle" class="small">Fecha de Inicio Inspección:</label>
                            <input type="date" class="form-control form-control-sm" id="fechaInicioInspDetalle" name="fechaInicioInspeccionDetalle" value="<%= inicioDeMes %>" required>
                        </div>
                        <div class="form-group">
                            <label for="fechaFinInspDetalle" class="small">Fecha de Fin Inspección:</label>
                            <input type="date" class="form-control form-control-sm" id="fechaFinInspDetalle" name="fechaFinInspeccionDetalle" value="<%= fechaHoy %>" required>
                        </div>
                        <div class="form-group">
                            <label for="filtroInspector" class="small">Filtrar por Inspector (Opcional):</label>
                            <select class="form-control form-control-sm" id="filtroInspector" name="filtroInspector">
                                <option value="0">Todos los Inspectores</option>
                                <% for (Usuario inspector : listaInspectores) { %>
                                    <option value="<%= inspector.getIdUsuario() %>"><%= inspector.getNombreCompleto() != null ? inspector.getNombreCompleto() : inspector.getNombreUsuario() %></option>
                                <% } %>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block"><i class="fas fa-play-circle"></i> Generar</button>
                    </form>
                </div>
            </div>

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