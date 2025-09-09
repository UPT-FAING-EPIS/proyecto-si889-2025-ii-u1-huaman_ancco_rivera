<%-- 
    Document   : reporteInspeccionesResultado
    Created on : 2 jun. 2025, 21:14:00
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Reporte: Resultados de Inspección</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f8f9fa; }
        .navbar { margin-bottom: 20px; }
        .report-container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom:20px;}
        .table th { background-color: #343a40; color: white;}
        .chart-container {
            width: 100%;
            max-width: 500px;
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
        
        Map<String, Integer> conteoResultados = (Map<String, Integer>) request.getAttribute("conteoResultadosInspeccion");
        if (conteoResultados == null) {
            conteoResultados = new HashMap<>();
            conteoResultados.putIfAbsent("aprobado", 0);
            conteoResultados.putIfAbsent("rechazado", 0);
        }

        String fechaInicioReporte = (String) request.getAttribute("fechaInicioReporteInspResultado");
        String fechaFinReporte = (String) request.getAttribute("fechaFinReporteInspResultado");
        SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfOriginal = new SimpleDateFormat("yyyy-MM-dd");
        
        String periodoStr = "N/D";
        try {
            if (fechaInicioReporte != null && !fechaInicioReporte.isEmpty() && fechaFinReporte != null && !fechaFinReporte.isEmpty()) {
                periodoStr = "del " + sdfDisplay.format(sdfOriginal.parse(fechaInicioReporte)) + 
                             " al " + sdfDisplay.format(sdfOriginal.parse(fechaFinReporte));
            }
        } catch (Exception e) {
            periodoStr = "(Fechas inválidas)";
        }
        
        List<String> pieLabels = Arrays.asList("Aprobado", "Rechazado");
        List<Integer> pieDataValues = new ArrayList<>();
        pieDataValues.add(conteoResultados.getOrDefault("aprobado", 0));
        pieDataValues.add(conteoResultados.getOrDefault("rechazado", 0));
        
        List<String> pieBackgroundColors = Arrays.asList("rgba(75, 192, 192, 0.7)", "rgba(255, 99, 132, 0.7)");
        List<String> pieBorderColors = Arrays.asList("rgba(75, 192, 192, 1)", "rgba(255, 99, 132, 1)");

        Gson gson = new Gson();
        String jsonPieLabels = gson.toJson(pieLabels);
        String jsonPieDataValues = gson.toJson(pieDataValues);
        String jsonPieBackgroundColors = gson.toJson(pieBackgroundColors);
        String jsonPieBorderColors = gson.toJson(pieBorderColors);
        
        boolean hayDatosParaGrafico = pieDataValues.stream().anyMatch(v -> v > 0);

    %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-info">
        <a class="navbar-brand" href="admin_dashboard.jsp"><i class="fas fa-shield-alt"></i> SIRESA Admin</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="ControladorReporte?accion=mostrarformulario">Reportes</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Resultados Inspección</a></li>
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
                 <h1><i class="fas fa-check-circle"></i> Reporte: Resultados de Inspección</h1>
                 <button onclick="window.print();" class="btn btn-secondary"><i class="fas fa-print"></i> Imprimir Página</button>
            </div>
            <p>Este reporte muestra la cantidad total de inspecciones agrupadas por su resultado (Aprobado/Rechazado) en el periodo <strong><%= periodoStr %></strong>.</p>
            
            <h4 class="mt-4">Tabla de Datos</h4>
            <table class="table table-bordered table-hover table-sm">
                <thead class="thead-dark">
                    <tr>
                        <th>Resultado de Inspección</th>
                        <th>Cantidad</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (conteoResultados.isEmpty() || !hayDatosParaGrafico) { %>
                        <tr>
                            <td colspan="2" class="text-center">No hay datos de inspecciones para el periodo seleccionado.</td>
                        </tr>
                    <% } else { %>
                        <tr>
                            <td>Aprobado</td>
                            <td><%= conteoResultados.getOrDefault("aprobado", 0) %></td>
                        </tr>
                        <tr>
                            <td>Rechazado</td>
                            <td><%= conteoResultados.getOrDefault("rechazado", 0) %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <% if (hayDatosParaGrafico) { %>
        <div class="report-container chart-container">
            <h4 class="text-center">Distribución de Resultados de Inspección</h4>
            <canvas id="inspeccionResultadoPieChart"></canvas>
        </div>
        <% } %>
        
        <div class="text-center mt-3 mb-4"> 
            <a href="ControladorReporte?accion=mostrarformulario" class="btn btn-primary"><i class="fas fa-arrow-left"></i> Volver a Selección de Reportes</a>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <% if (hayDatosParaGrafico) { %>
    <script>
        const pieLabelsInsp = JSON.parse('<%= jsonPieLabels %>');
        const pieDataValuesInsp = JSON.parse('<%= jsonPieDataValues %>');
        const pieBgColorsInsp = JSON.parse('<%= jsonPieBackgroundColors %>');
        const pieBorderColorsInsp = JSON.parse('<%= jsonPieBorderColors %>');

        const pieCtxInsp = document.getElementById('inspeccionResultadoPieChart').getContext('2d');
        const inspeccionPieChart = new Chart(pieCtxInsp, {
            type: 'pie',
            data: {
                labels: pieLabelsInsp,
                datasets: [{
                    label: 'Resultados de Inspección',
                    data: pieDataValuesInsp,
                    backgroundColor: pieBgColorsInsp,
                    borderColor: pieBorderColorsInsp,
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
                        text: 'Resultados de Inspección en el Periodo'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                if (context.parsed !== null) {
                                    label += context.parsed;
                                }
                                let sum = 0;
                                let dataArr = context.chart.data.datasets[0].data;
                                dataArr.map(data => {
                                    sum += data;
                                });
                                let percentage = (context.parsed * 100 / sum).toFixed(2) + '%';
                                label += ' (' + percentage + ')';
                                return label;
                            }
                        }
                    }
                }
            }
        });
    </script>
    <% } %>
</body>
</html>