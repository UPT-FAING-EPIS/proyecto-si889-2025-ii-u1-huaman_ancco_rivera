<%-- 
    Document   : formEstablecimiento
    Created on : 2 jun. 2025, 12:09:00
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.TipoEstablecimiento"%>
<%@page import="modelo.Establecimiento"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.math.BigDecimal"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Establecimiento establecimiento = (Establecimiento) request.getAttribute("establecimiento");
        Boolean esNuevoObj = (Boolean) request.getAttribute("esNuevo");
        boolean esNuevo = (esNuevoObj != null) ? esNuevoObj.booleanValue() : (establecimiento == null || establecimiento.getIdEstablecimiento() == 0);

        if (establecimiento == null) { 
            establecimiento = new Establecimiento();
        }
        
        String tituloPagina = esNuevo ? "Registrar Nuevo Establecimiento" : "Editar Establecimiento: " + establecimiento.getNombre();
        String accionForm = esNuevo ? "registrar" : "actualizardatos"; 

        List<TipoEstablecimiento> tiposEstablecimiento = (List<TipoEstablecimiento>) request.getAttribute("tiposEstablecimiento");
        if (tiposEstablecimiento == null) tiposEstablecimiento = new ArrayList<>();
        
        // Para los campos de BigDecimal, obtener como String o vacío
        String latitudStr = (establecimiento.getLatitud() != null) ? establecimiento.getLatitud().toPlainString() : "";
        String longitudStr = (establecimiento.getLongitud() != null) ? establecimiento.getLongitud().toPlainString() : "";

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
        .form-section-title {
            margin-top: 20px;
            margin-bottom: 15px;
            font-size: 1.2em;
            color: #007bff;
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
        }
        #mapPicker { 
            height: 350px;
            width: 100%;
            margin-bottom: 15px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <%
        HttpSession sesion = request.getSession(false);
        Usuario usuarioLogueado = null;
        if (sesion != null && sesion.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
            if (!("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol()))) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoFormEst");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaFormEst");
            return;
        }
        String dashboardLink = "admin".equals(usuarioLogueado.getRol()) ? "admin_dashboard.jsp" : "inspector_dashboard.jsp";
        String navBarColor = "admin".equals(usuarioLogueado.getRol()) ? "bg-primary" : "bg-success";
    %>
    <nav class="navbar navbar-expand-lg navbar-dark <%= navBarColor %>">
        <a class="navbar-brand" href="<%= dashboardLink %>"><i class="fas fa-store"></i> SIRESA Establecimientos</a>
         <div class="ml-auto">
             <a class="btn btn-outline-light" href="ControladorLogin?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container mt-4 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-10 col-lg-8">
                <div class="form-container">
                    <h1><i class="fas <%= esNuevo ? "fa-plus-circle" : "fa-edit" %>"></i> <%= tituloPagina %></h1>
                    <%
                        String mensajeError = (String) request.getAttribute("mensajeError");
                        if (mensajeError == null) { 
                            mensajeError = (String) session.getAttribute("mensajeErrorFormEst");
                            if(mensajeError != null) session.removeAttribute("mensajeErrorFormEst");
                        }
                        if (mensajeError != null) {
                    %>
                        <div class="alert alert-danger" role="alert"><%= mensajeError %></div>
                    <% } %>

                    <form id="formEstablecimiento" method="POST" action="ControladorEstablecimiento">
                        <input type="hidden" name="accion" value="<%= accionForm %>">
                        <% if (!esNuevo) { %>
                            <input type="hidden" name="idEstablecimiento" value="<%= establecimiento.getIdEstablecimiento() %>">
                        <% } %>

                        <div class="form-section-title">Datos del Establecimiento</div>
                        <div class="form-row">
                            <div class="form-group col-md-8">
                                <label for="txtNombre">Nombre del Establecimiento <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="txtNombre" name="txtNombre" 
                                       value="<%= establecimiento.getNombre() != null ? establecimiento.getNombre() : "" %>" required>
                            </div>
                            <div class="form-group col-md-4">
                                <label for="selTipoEstablecimiento">Tipo de Establecimiento <span class="text-danger">*</span></label>
                                <select class="form-control" id="selTipoEstablecimiento" name="selTipoEstablecimiento" required>
                                    <option value="">Seleccione un tipo...</option>
                                    <% for (TipoEstablecimiento tipo : tiposEstablecimiento) { %>
                                        <option value="<%= tipo.getIdTipoEstablecimiento() %>" 
                                                <%= (establecimiento.getIdTipoEstablecimiento() == tipo.getIdTipoEstablecimiento() ? "selected" : "") %>>
                                            <%= tipo.getNombreTipo() %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="txtDireccion">Dirección Completa</label>
                            <textarea class="form-control" id="txtDireccion" name="txtDireccion" rows="2"><%= establecimiento.getDireccion() != null ? establecimiento.getDireccion() : "" %></textarea>
                        </div>

                        <div class="form-section-title">Información de Contacto</div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="txtContactoNombre">Nombre del Contacto</label>
                                <input type="text" class="form-control" id="txtContactoNombre" name="txtContactoNombre"
                                       value="<%= establecimiento.getContactoNombre() != null ? establecimiento.getContactoNombre() : "" %>">
                            </div>
                            <div class="form-group col-md-6">
                                <label for="txtContactoTelefono">Teléfono de Contacto</label>
                                <input type="tel" class="form-control" id="txtContactoTelefono" name="txtContactoTelefono"
                                       value="<%= establecimiento.getContactoTelefono() != null ? establecimiento.getContactoTelefono() : "" %>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="txtContactoEmail">Email de Contacto</label>
                            <input type="email" class="form-control" id="txtContactoEmail" name="txtContactoEmail"
                                   value="<%= establecimiento.getContactoEmail() != null ? establecimiento.getContactoEmail() : "" %>">
                        </div>
                        
                        <div class="form-section-title">Ubicación Geográfica</div>
                        <p><small class="text-muted">Haga clic en el mapa para seleccionar la ubicación (esto intentará rellenar la dirección) o ingrese las coordenadas manualmente.</small></p>
                        <div id="mapPicker"></div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="txtLatitud">Latitud</label>
                                <input type="text" class="form-control" id="txtLatitud" name="txtLatitud" placeholder="Ej: -18.0146"
                                       value="<%= latitudStr %>">
                            </div>
                            <div class="form-group col-md-6">
                                <label for="txtLongitud">Longitud</label>
                                <input type="text" class="form-control" id="txtLongitud" name="txtLongitud" placeholder="Ej: -70.2513"
                                       value="<%= longitudStr %>">
                            </div>
                        </div>
                        <hr>
                        <button type="submit" class="btn btn-primary"><i class="fas <%= esNuevo ? "fa-plus-circle" : "fa-save" %>"></i> <%= esNuevo ? "Registrar Establecimiento" : "Guardar Cambios" %></button>
                        <a href="ControladorEstablecimiento?accion=<%= esNuevo ? "listar" : ("verdetalle&id=" + establecimiento.getIdEstablecimiento()) %>" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Cancelar
                        </a>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
        let mapPickerInstance;
        let markerPicker;
        let geocoder;
        const defaultPickerCenter = { lat: -18.0146, lng: -70.2513 };
        const initialPickerZoom = 13;

        const latInput = document.getElementById('txtLatitud');
        const lngInput = document.getElementById('txtLongitud');
        const direccionInput = document.getElementById('txtDireccion');
        const esNuevoForm = <%= esNuevo %>;

        function initMapPicker() {
            let currentLat = parseFloat(latInput.value.replace(",",".")) || defaultPickerCenter.lat; 
            let currentLng = parseFloat(lngInput.value.replace(",",".")) || defaultPickerCenter.lng;
            let currentZoom = (latInput.value && lngInput.value && !isNaN(currentLat) && !isNaN(currentLng)) ? 17 : initialPickerZoom;


            mapPickerInstance = new google.maps.Map(document.getElementById("mapPicker"), {
                center: { lat: currentLat, lng: currentLng },
                zoom: currentZoom,
                mapTypeControl: true,
                streetViewControl: false,
                draggableCursor: 'pointer'
            });

            geocoder = new google.maps.Geocoder();

            markerPicker = new google.maps.Marker({
                position: { lat: currentLat, lng: currentLng },
                map: (latInput.value && lngInput.value && !isNaN(currentLat) && !isNaN(currentLng)) ? mapPickerInstance : null, 
                draggable: true
            });

            mapPickerInstance.addListener("click", (mapsMouseEvent) => {
                updateMarkerAndInputs(mapsMouseEvent.latLng);
            });

            markerPicker.addListener("dragend", () => {
                updateMarkerAndInputs(markerPicker.getPosition());
            });
            
             if (latInput.value && lngInput.value && !isNaN(currentLat) && !isNaN(currentLng)) {
                markerPicker.setMap(mapPickerInstance);
            }
        }

        function updateMarkerAndInputs(latLng) {
            latInput.value = latLng.lat().toFixed(6);
            lngInput.value = latLng.lng().toFixed(6);
            
            markerPicker.setPosition(latLng);
            markerPicker.setMap(mapPickerInstance);
            mapPickerInstance.panTo(latLng);
            geocodeLatLng(latLng);
        }

        function geocodeLatLng(latLng) {
            geocoder.geocode({ 'location': latLng }, (results, status) => {
                if (status === 'OK') {
                    if (results[0]) {
                            direccionInput.value = results[0].formatted_address;
                    } else {
                        console.warn('No se encontraron resultados de dirección para reverse geocoding.');
                    }
                } else {
                    console.warn('Geocoder falló debido a: ' + status);
                }
            });
        }

        latInput.addEventListener('change', updateMapFromInputs);
        lngInput.addEventListener('change', updateMapFromInputs);

        function updateMapFromInputs() {
            const lat = parseFloat(latInput.value.replace(",","."));
            const lng = parseFloat(lngInput.value.replace(",","."));
            if (!isNaN(lat) && !isNaN(lng)) {
                const newPos = {lat: lat, lng: lng};
                markerPicker.setPosition(newPos);
                markerPicker.setMap(mapPickerInstance);
                mapPickerInstance.panTo(newPos);
                if(mapPickerInstance.getZoom() < 15) mapPickerInstance.setZoom(15);
            } else {
                markerPicker.setMap(null);
            }
        }
    </script>
    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCF37ZcGIG5_Gce3EQXm1ehCNddZbkv_ZY&libraries=geocoding&callback=initMapPicker"></script>

</body>
</html>