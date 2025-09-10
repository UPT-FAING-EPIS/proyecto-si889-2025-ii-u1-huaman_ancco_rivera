<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIRESA - Mapa de Establecimientos</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body, html { height: 100%; margin: 0; padding: 0; }
        #map-container { display: flex; flex-direction: column; height: 100%; }
        .navbar { flex-shrink: 0; }
        #map { flex-grow: 1; width: 100%; background-color: #e5e3df; }
    </style>
</head>
<body>
    <%
        String jsonEstablecimientos = (String) request.getAttribute("jsonEstablecimientos");
        if (jsonEstablecimientos == null || jsonEstablecimientos.trim().isEmpty()) {
            jsonEstablecimientos = "[]"; 
        }
    %>
    <div id="map-container">
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <a class="navbar-brand" href="login.jsp"><i class="fas fa-map-marked-alt"></i> SIRESA Mapas</a>
             <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="ControladorEstablecimiento?accion=listar">Ver Lista</a>
                </li>
            </ul>
        </nav>

        <div id="map"></div>
    </div>

    <script>
        function getMarkerColor(estado) {
            let color = '#007bff'; 
            if (estado) {
                switch (estado.toLowerCase()) {
                    case 'aprobado': color = '#28a745'; break;
                    case 'rechazado': color = '#dc3545'; break;
                    case 'en proceso': color = '#ffc107'; break;
                }
            }
            return color;
        }

        function initMap() {
            const establecimientosData = <%= jsonEstablecimientos %>;
            
            const map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: -18.0146, lng: -70.2513 },
                zoom: 13
            });

            if (establecimientosData && establecimientosData.length > 0) {
                const bounds = new google.maps.LatLngBounds();
                let markersAdded = 0;

                for (const est of establecimientosData) {
                    const lat = parseFloat(est.latitud);
                    const lng = parseFloat(est.longitud);

                    if (!isNaN(lat) && !isNaN(lng)) {
                        new google.maps.Marker({
                            position: { lat: lat, lng: lng },
                            map: map,
                            title: est.nombre || 'Establecimiento',
                            icon: {
                                path: google.maps.SymbolPath.CIRCLE,
                                fillColor: getMarkerColor(est.estado),
                                fillOpacity: 1.0,
                                scale: 8,
                                strokeColor: 'white',
                                strokeWeight: 1.5,
                            }
                        });
                        bounds.extend({ lat: lat, lng: lng });
                        markersAdded++;
                    }
                }
                
                if (markersAdded > 0) {
                    map.fitBounds(bounds);
                    if (markersAdded === 1) {
                       map.setZoom(16);
                    }
                }
            }
        }
    </script>
    
    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCF37ZcGIG5_Gce3EQXm1ehCNddZbkv_ZY&callback=initMap"></script>

</body>
</html>