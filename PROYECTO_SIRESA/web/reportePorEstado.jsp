<%-- 
    Document   : reportePorEstado
    Created on : 2 jun. 2025, 13:40:19
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Arrays"%> 
<%@page import="java.util.List"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.ArrayList"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Reporte por Estado con Gráficos</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <%-- 1. Incluir Chart.js --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .report-container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom:20px;}
        .table th { background-color: #343a40; color: white;}
        .chart-container {
            width: 100%;
            max-width: 600px; 
            margin: 20px auto; 
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
        
        Map<String, Integer> conteoPorEstado = (Map<String, Integer>) request.getAttribute("conteoPorEstado");
        if (conteoPorEstado == null) {
            conteoPorEstado = new HashMap<>();
        }
        
        List<String> labels = Arrays.asList("Aprobado", "En Proceso", "Rechazado"); 
        List<Integer> dataValues = new ArrayList<>();
        List<String> backgroundColors = Arrays.asList("rgba(75, 192, 192, 0.7)", "rgba(255, 206, 86, 0.7)", "rgba(255, 99, 132, 0.7)");
        List<String> borderColors = Arrays.asList("rgba(75, 192, 192, 1)", "rgba(255, 206, 86, 1)", "rgba(255, 99, 132, 1)");
        
        for(String label : labels){
            dataValues.add(conteoPorEstado.getOrDefault(label.toLowerCase(), 0)); 
        }

        Gson gson = new Gson();
        String jsonLabels = gson.toJson(labels);
        String jsonDataValues = gson.toJson(dataValues);
        String jsonBackgroundColors = gson.toJson(backgroundColors);
        String jsonBorderColors = gson.toJson(borderColors);

    %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-info">
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="ControladorReporte?accion=mostrarformulario">Reportes</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Por Estado (Gráficos)</a></li>
            </ul>
             <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="report-container">
            <div class="d-flex justify-content-between align-items-center mb-3">
                 <h1><i class="fas fa-chart-pie"></i> Reporte: Establecimientos por Estado</h1>
                 <button onclick="window.print();" class="btn btn-secondary"><i class="fas fa-print"></i> Imprimir Página</button>
            </div>
            <p>Este reporte muestra la cantidad total de establecimientos agrupados por su estado actual, presentado en tabla y gráficos.</p>
            
            <h4 class="mt-4">Tabla de Datos</h4>
            <table class="table table-bordered table-hover table-sm">
                <thead class="thead-dark">
                    <tr>
                        <th>Estado del Establecimiento</th>
                        <th>Cantidad</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (conteoPorEstado.isEmpty() && dataValues.stream().allMatch(v -> v == 0)) { %>
                        <tr>
                            <td colspan="2" class="text-center">No hay datos disponibles para este reporte.</td>
                        </tr>
                    <% } else {
                        for(int i = 0; i < labels.size(); i++) {
                    %>
                        <tr>
                            <td><%= labels.get(i) %></td>
                            <td><%= dataValues.get(i) %></td>
                        </tr>
                    <%      }
                       } %>
                </tbody>
            </table>
        </div>

        <div class="row">
            <div class="col-lg-6">
                <div class="report-container chart-container">
                    <h4 class="text-center">Gráfico de Pie</h4>
                    <canvas id="pieChartEstado"></canvas>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="report-container chart-container">
                    <h4 class="text-center">Gráfico de Barras</h4>
                    <canvas id="barChartEstado"></canvas>
                </div>
            </div>
        </div>
        
        <div class="text-center mt-3 mb-4">
            <a href="ControladorReporte?accion=mostrarformulario" class="btn btn-primary"><i class="fas fa-arrow-left"></i> Volver a Selección de Reportes</a>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        const chartLabels = JSON.parse('<%= jsonLabels %>');
        const chartDataValues = JSON.parse('<%= jsonDataValues %>');
        const chartBackgroundColors = JSON.parse('<%= jsonBackgroundColors %>');
        const chartBorderColors = JSON.parse('<%= jsonBorderColors %>');

        const pieCtx = document.getElementById('pieChartEstado').getContext('2d');
        const pieChart = new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: chartLabels,
                datasets: [{
                    label: 'Establecimientos por Estado',
                    data: chartDataValues,
                    backgroundColor: chartBackgroundColors,
                    borderColor: chartBorderColors,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true, 
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'Distribución de Establecimientos por Estado'
                    }
                }
            }
        });

        const barCtx = document.getElementById('barChartEstado').getContext('2d');
        const barChart = new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: chartLabels,
                datasets: [{
                    label: 'Cantidad de Establecimientos',
                    data: chartDataValues,
                    backgroundColor: chartBackgroundColors, 
                    borderColor: chartBorderColors,
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
                    }
                },
                plugins: {
                    legend: {
                        display: false, 
                    },
                    title: {
                        display: true,
                        text: 'Cantidad de Establecimientos por Estado'
                    }
                }
            }
        });
    </script>
</body>
</html>