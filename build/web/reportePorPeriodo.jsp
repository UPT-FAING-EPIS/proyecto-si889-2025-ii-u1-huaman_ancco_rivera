<%-- 
    Document   : reportePorPeriodo
    Created on : 2 jun. 2025, 13:40:58
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Establecimiento"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.google.gson.Gson"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Reporte por Periodo con Gráfico</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
     <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .report-container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px;}
        .table th { background-color: #343a40; color: white; font-size: 0.9rem;}
        .table td {font-size: 0.85rem;}
        .estado-aprobado { background-color: #28a745 !important; color: white; padding: .3em .6em; border-radius: .25rem; }
        .estado-rechazado { background-color: #dc3545 !important; color: white; padding: .3em .6em; border-radius: .25rem; }
        .estado-en-proceso { background-color: #ffc107 !important; color: black; padding: .3em .6em; border-radius: .25rem; }
        
        .bar-chart-container {
            width: 100%;
            max-width: 900px; 
            margin: 30px auto; 
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fff;
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
                response.sendRedirect("login.jsp?error=AccesoDenegadoReporteView");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaReporteView");
            return;
        }
        
        List<Establecimiento> establecimientos = (List<Establecimiento>) request.getAttribute("establecimientosPeriodo");
        if (establecimientos == null) establecimientos = new ArrayList<>();
        
        String fechaInicioReporte = (String) request.getAttribute("fechaInicioReporte");
        String fechaFinReporte = (String) request.getAttribute("fechaFinReporte");
        SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfOriginal = new SimpleDateFormat("yyyy-MM-dd");
        
        String periodoStr = "";
        try {
            if (fechaInicioReporte != null && fechaFinReporte != null) {
                periodoStr = "del " + sdfDisplay.format(sdfOriginal.parse(fechaInicioReporte)) + 
                             " al " + sdfDisplay.format(sdfOriginal.parse(fechaFinReporte));
            }
        } catch (Exception e) {
            periodoStr = "(Fechas inválidas)";
        }

        SimpleDateFormat sdfTabla = new SimpleDateFormat("dd/MM/yyyy HH:mm");

        List<String> chartLabels = (List<String>) request.getAttribute("chartLabelsPeriodo");
        List<Integer> chartData = (List<Integer>) request.getAttribute("chartDataValuesPeriodo");

        Gson gson = new Gson();
        String jsonChartLabels = gson.toJson(chartLabels != null ? chartLabels : new ArrayList<String>());
        String jsonChartData = gson.toJson(chartData != null ? chartData : new ArrayList<Integer>());
    %>
     <nav class="navbar navbar-expand-lg navbar-dark bg-info">
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="ControladorReporte?accion=mostrarformulario">Reportes</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Por Periodo (Gráfico)</a></li>
            </ul>
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container-fluid mt-4"> 
        <div class="report-container">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1><i class="fas fa-calendar-check"></i> Reporte: Establecimientos Registrados por Periodo</h1>
                <button onclick="window.print();" class="btn btn-secondary"><i class="fas fa-print"></i> Imprimir Página</button>
            </div>
            <p>Este reporte muestra los establecimientos registrados en el sistema <%= periodoStr %>.</p>
            
            <h4 class="mt-4">Tabla de Datos Detallada</h4>
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm">
                    <thead class="thead-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Tipo</th>
                            <th>Dirección</th>
                            <th>Estado</th>
                            <th>Fecha de Registro</th>
                            <th>Registrado por</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (establecimientos.isEmpty()) { %>
                            <tr>
                                <td colspan="7" class="text-center">No se encontraron establecimientos registrados en el periodo seleccionado.</td>
                            </tr>
                        <% } else {
                            for (Establecimiento est : establecimientos) {
                                String claseEstado = "";
                                String textoEstado = est.getEstado();
                                if ("aprobado".equalsIgnoreCase(est.getEstado())) claseEstado = "estado-aprobado";
                                else if ("rechazado".equalsIgnoreCase(est.getEstado())) claseEstado = "estado-rechazado";
                                else if ("en proceso".equalsIgnoreCase(est.getEstado())) claseEstado = "estado-en-proceso";
                        %>
                            <tr>
                                <td><%= est.getIdEstablecimiento() %></td>
                                <td><%= est.getNombre() %></td>
                                <td><%= est.getNombreTipoEstablecimiento() != null ? est.getNombreTipoEstablecimiento() : "N/A" %></td>
                                <td><%= est.getDireccion() != null ? est.getDireccion() : "N/A" %></td>
                                <td><span class="<%= claseEstado %>"><%= textoEstado %></span></td>
                                <td><%= est.getFechaRegistro() != null ? sdfTabla.format(est.getFechaRegistro()) : "N/A" %></td>
                                <td><%= est.getNombreUsuarioRegistro() != null ? est.getNombreUsuarioRegistro() : "Sistema" %></td>
                            </tr>
                        <%  } 
                           } %>
                    </tbody>
                </table>
            </div>

            <% if (chartLabels != null && !chartLabels.isEmpty() && chartData != null && !chartData.isEmpty() && chartData.stream().anyMatch(d -> d > 0)) { %>
                <div class="bar-chart-container"> 
                    <h4 class="text-center mt-4">Establecimientos Registrados por Día</h4>
                    <canvas id="barChartPeriodo"></canvas>
                </div>
            <% } else if (fechaInicioReporte != null){ %> 
                <div class="alert alert-info mt-3" role="alert">
                  No hay datos de registro para graficar en el periodo seleccionado.
                </div>
            <% } %>
            
             <div class="text-right mt-4">
                <a href="ControladorReporte?accion=mostrarformulario" class="btn btn-primary"><i class="fas fa-arrow-left"></i> Volver a Selección de Reportes</a>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <% if (chartLabels != null && !chartLabels.isEmpty() && chartData != null && !chartData.isEmpty() && chartData.stream().anyMatch(d -> d > 0)) { %>
    <script>
        const barLabelsPeriodo = JSON.parse('<%= jsonChartLabels %>');
        const barDataPeriodo = JSON.parse('<%= jsonChartData %>');

        const barCtxPeriodo = document.getElementById('barChartPeriodo').getContext('2d');
        const barChartPeriodo = new Chart(barCtxPeriodo, {
            type: 'bar',
            data: {
                labels: barLabelsPeriodo,
                datasets: [{
                    label: 'Establecimientos Registrados',
                    data: barDataPeriodo,
                    backgroundColor: 'rgba(54, 162, 235, 0.7)', 
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1 
                        }
                    },
                    x: {
                        ticks: {
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: true, 
                        position: 'top'
                    },
                    title: {
                        display: true,
                        text: 'Cantidad de Nuevos Establecimientos Registrados por Día'
                    }
                }
            }
        });
    </script>
    <% } %>
</body>
</html>