package controlador;

import com.google.gson.Gson;
import modelo.Establecimiento;
import modelo.TipoEstablecimiento;
import modelo.Usuario;
import modeloDAO.EstablecimientoDAO;
import modeloDAO.TipoEstablecimientoDAO;
import modelo.HistorialCambioEstado;
import modeloDAO.HistorialCambioEstadoDAO;

import java.util.stream.Collectors;
import java.util.Map;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ControladorEstablecimiento", urlPatterns = {"/ControladorEstablecimiento"})
public class ControladorEstablecimiento extends HttpServlet {

    EstablecimientoDAO establecimientoDAO = new EstablecimientoDAO();
    TipoEstablecimientoDAO tipoEstablecimientoDAO = new TipoEstablecimientoDAO();
    HistorialCambioEstadoDAO historialDAO = new HistorialCambioEstadoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = null;

        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        } else {
            String accionParam = request.getParameter("accion");
            if (!"listar".equalsIgnoreCase(accionParam)) { 
                 response.sendRedirect("login.jsp?error=SesionExpiradaCE");
                 return;
            }
        }

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar"; 
        }

        String vistaJSP = "";

        switch (accion.toLowerCase()) {
            case "listar": 
                listarEstablecimientos(request, response);
                return;

            case "mostrarformregistro": 
                if (usuarioLogueado != null && ("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol()))) {
                    List<TipoEstablecimiento> tipos = tipoEstablecimientoDAO.listarTodos();
                    request.setAttribute("tiposEstablecimiento", tipos);
                    request.setAttribute("establecimiento", new Establecimiento()); 
                    request.setAttribute("esNuevo", true);
                    vistaJSP = "formEstablecimiento.jsp";
                } else {
                    request.setAttribute("mensajeError", "No tiene permisos para registrar establecimientos.");
                    vistaJSP = "listarEstablecimientos.jsp";
                     List<Establecimiento> establecimientos = establecimientoDAO.listarTodos();
                     request.setAttribute("establecimientos", establecimientos);
                }
                break;
                
            case "mostrarformeditar": 
            if (usuarioLogueado != null && ("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol()))) {
                mostrarFormEditarEstablecimiento(request, response);
            } else {
                accesoDenegado(request, response); 
            }
            return;
            
            case "actualizardatos": 
            if (usuarioLogueado != null && ("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol()))) {
                actualizarDatosEstablecimiento(request, response, usuarioLogueado);
            } else {
                accesoDenegado(request, response);
            }
            return;

            case "registrar":
                if (usuarioLogueado != null && ("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol()))) {
                    registrarEstablecimiento(request, response, usuarioLogueado);
                } else {
                    response.sendRedirect("login.jsp?error=AccesoNoAutorizadoRegistroEst");
                }
                return;
            
            case "mostrarmapa":
            mostrarMapaEstablecimientos(request, response);
            return;
                
            case "verdetalle":
                 verDetalleEstablecimiento(request,response);
                 return; 

            case "mostrarformcambiarestado":
                if (usuarioLogueado != null && ("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol()))) {
                    mostrarFormCambiarEstado(request, response);
                } else {
                     response.sendRedirect("login.jsp?error=AccesoDenegadoCambioEstado");
                }
                return;
            
            case "actualizarestado":
                 if (usuarioLogueado != null && ("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol()))) {
                    actualizarEstadoEstablecimiento(request, response, usuarioLogueado);
                } else {
                     response.sendRedirect("login.jsp?error=AccesoDenegadoCambioEstadoProc");
                }
                return;
                
            case "solicitareliminacion":
            if (usuarioLogueado != null && "admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                mostrarFormConfirmarEliminacion(request, response);
            } else {
                accesoDenegado(request, response);
            }
            return;

            case "ejecutareliminacion":
            if (usuarioLogueado != null && "admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                ejecutarEliminacionLogica(request, response, usuarioLogueado);
            } else {
                accesoDenegado(request, response);
            }
            return;
                
            case "verhistorial":
            if (usuarioLogueado != null && "admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                verHistorialEstablecimiento(request, response);
            } else {
                 request.getSession().setAttribute("mensajeError", "No tiene permisos para ver el historial de cambios.");
                 response.sendRedirect("ControladorEstablecimiento?accion=listar");
            }
            return;

            default:
                listarEstablecimientos(request, response); 
                return;
        }
        if (!vistaJSP.isEmpty()) {
            request.getRequestDispatcher(vistaJSP).forward(request, response);
        }
    }
    
    private void mostrarFormConfirmarEliminacion(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int idEstablecimiento = Integer.parseInt(request.getParameter("idEstablecimiento"));
        Establecimiento establecimiento = establecimientoDAO.obtenerPorId(idEstablecimiento); 

        if (establecimiento != null && establecimiento.isActivo()) { 
            request.setAttribute("establecimientoParaEliminar", establecimiento);
            request.getRequestDispatcher("confirmarEliminacionEstablecimiento.jsp").forward(request, response);
        } else {
            if (establecimiento != null && !establecimiento.isActivo()){
                 request.getSession().setAttribute("mensajeError", "El establecimiento (ID: " + idEstablecimiento + ") ya está eliminado/inactivo.");
            } else {
                 request.getSession().setAttribute("mensajeError", "Establecimiento no encontrado (ID: " + idEstablecimiento + ") para eliminar.");
            }
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
        }
    } catch (NumberFormatException e) {
        request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido para eliminación.");
        response.sendRedirect("ControladorEstablecimiento?accion=listar");
    }
}

private void ejecutarEliminacionLogica(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogueadoAdmin)
        throws ServletException, IOException {
    int idEstablecimiento = 0;
    try {
        idEstablecimiento = Integer.parseInt(request.getParameter("idEstablecimiento"));
        String motivoEliminacion = request.getParameter("txtMotivoEliminacion");

        if (motivoEliminacion == null || motivoEliminacion.trim().isEmpty()) {
            request.setAttribute("mensajeErrorFormEliminacion", "Debe ingresar un motivo para la eliminación.");
            Establecimiento establecimiento = establecimientoDAO.obtenerPorId(idEstablecimiento);
            if (establecimiento != null) {
                request.setAttribute("establecimientoParaEliminar", establecimiento);
                request.getRequestDispatcher("confirmarEliminacionEstablecimiento.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("mensajeError", "Establecimiento no encontrado al intentar validar motivo de eliminación.");
                response.sendRedirect("ControladorEstablecimiento?accion=listar");
            }
            return;
        }

        Establecimiento est = establecimientoDAO.obtenerPorId(idEstablecimiento);
        String nombreEst = (est != null) ? est.getNombre() : "ID " + idEstablecimiento;


        if (establecimientoDAO.softDelete(idEstablecimiento, usuarioLogueadoAdmin.getIdUsuario(), motivoEliminacion)) {
            request.getSession().setAttribute("mensajeExito", "Establecimiento '" + nombreEst + "' eliminado lógicamente con éxito.");
        } else {
            request.getSession().setAttribute("mensajeError", "Error al eliminar lógicamente el establecimiento '" + nombreEst + "'. Verifique si ya estaba inactivo o si hay un problema con el historial.");
        }
    } catch (NumberFormatException e) {
        request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido durante la ejecución de la eliminación.");
    } catch (Exception e) {
        request.getSession().setAttribute("mensajeError", "Ocurrió un error inesperado durante la eliminación: " + e.getMessage());
        e.printStackTrace();
    }
    response.sendRedirect("ControladorEstablecimiento?accion=listar");
}
    
    private void mostrarFormEditarEstablecimiento(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int idEstablecimiento = Integer.parseInt(request.getParameter("idEstablecimiento"));
        Establecimiento establecimiento = establecimientoDAO.obtenerPorId(idEstablecimiento);

        if (establecimiento != null) {
            List<TipoEstablecimiento> tipos = tipoEstablecimientoDAO.listarTodos();
            request.setAttribute("tiposEstablecimiento", tipos);
            request.setAttribute("establecimiento", establecimiento);
            request.setAttribute("esNuevo", false);
            request.getRequestDispatcher("formEstablecimiento.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("mensajeError", "Establecimiento no encontrado (ID: " + idEstablecimiento + ") para editar.");
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
        }
    } catch (NumberFormatException e) {
        request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido para editar.");
        response.sendRedirect("ControladorEstablecimiento?accion=listar");
    }
}
    
    private void accesoDenegado(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.getSession().setAttribute("mensajeError", "No tiene permisos para realizar esta acción.");
        Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        String redirectTo = "ControladorEstablecimiento?accion=listar";
        if (usuarioLogueado != null) {
            switch (usuarioLogueado.getRol().toLowerCase()) {
                case "admin": 
                    redirectTo = "admin_dashboard.jsp"; 
                    break;
                case "inspector": 
                    redirectTo = "inspector_dashboard.jsp"; 
                    break;
                case "ciudadano": 
                    redirectTo = "ciudadano_dashboard.jsp"; 
                    break;
            }
        }
        response.sendRedirect(redirectTo + "?error=AccesoDenegadoEst"); 
    }

private void actualizarDatosEstablecimiento(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogueado)
        throws ServletException, IOException {
    int idEstablecimiento = 0;
    try {
        idEstablecimiento = Integer.parseInt(request.getParameter("idEstablecimiento"));

        Establecimiento estActualizar = new Establecimiento();
        estActualizar.setIdEstablecimiento(idEstablecimiento);
        estActualizar.setNombre(request.getParameter("txtNombre"));
        estActualizar.setDireccion(request.getParameter("txtDireccion"));
        estActualizar.setIdTipoEstablecimiento(Integer.parseInt(request.getParameter("selTipoEstablecimiento")));
        estActualizar.setContactoNombre(request.getParameter("txtContactoNombre"));
        estActualizar.setContactoTelefono(request.getParameter("txtContactoTelefono"));
        estActualizar.setContactoEmail(request.getParameter("txtContactoEmail"));

        String latStr = request.getParameter("txtLatitud");
        String lonStr = request.getParameter("txtLongitud");
        if (latStr != null && !latStr.trim().isEmpty()) {
            estActualizar.setLatitud(new BigDecimal(latStr.trim().replace(",", ".")));
        } else {
            estActualizar.setLatitud(null);
        }
        if (lonStr != null && !lonStr.trim().isEmpty()) {
            estActualizar.setLongitud(new BigDecimal(lonStr.trim().replace(",", ".")));
        } else {
            estActualizar.setLongitud(null);
        }

        if (estActualizar.getNombre() == null || estActualizar.getNombre().trim().isEmpty() ||
            estActualizar.getIdTipoEstablecimiento() == 0) {
            request.setAttribute("mensajeError", "Nombre y Tipo de Establecimiento son obligatorios.");
            List<TipoEstablecimiento> tipos = tipoEstablecimientoDAO.listarTodos();
            request.setAttribute("tiposEstablecimiento", tipos);
            request.setAttribute("establecimiento", estActualizar); 
            request.setAttribute("esNuevo", false);
            request.getRequestDispatcher("formEstablecimiento.jsp").forward(request, response);
            return;
        }

        if (establecimientoDAO.actualizar(estActualizar)) {
            request.getSession().setAttribute("mensajeExito", "Datos del establecimiento '" + estActualizar.getNombre() + "' actualizados exitosamente.");
            response.sendRedirect("ControladorEstablecimiento?accion=verdetalle&id=" + idEstablecimiento); 
        } else {
            request.getSession().setAttribute("mensajeError", "Error al actualizar los datos del establecimiento.");
            response.sendRedirect("ControladorEstablecimiento?accion=mostrarformeditar&idEstablecimiento=" + idEstablecimiento); 
        }
    } catch (NumberFormatException e) {
        request.getSession().setAttribute("mensajeError", "Error en el formato de los datos numéricos al actualizar: " + e.getMessage());
         if (idEstablecimiento > 0) {
            response.sendRedirect("ControladorEstablecimiento?accion=mostrarformeditar&idEstablecimiento=" + idEstablecimiento);
         } else {
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
         }
    } catch (Exception e) {
        request.getSession().setAttribute("mensajeError", "Ocurrió un error inesperado al actualizar: " + e.getMessage());
        if (idEstablecimiento > 0) {
            response.sendRedirect("ControladorEstablecimiento?accion=mostrarformeditar&idEstablecimiento=" + idEstablecimiento);
         } else {
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
         }
    }
}
    
    
    private void listarEstablecimientos(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String filtroNombre = request.getParameter("filtroNombre");
    String filtroTipoStr = request.getParameter("filtroTipo");
    String filtroEstado = request.getParameter("filtroEstado");

    Map<String, Object> filtros = new java.util.HashMap<>();
    if (filtroNombre != null && !filtroNombre.trim().isEmpty()) {
        filtros.put("nombre", filtroNombre.trim());
    }
    if (filtroTipoStr != null && !filtroTipoStr.trim().isEmpty()) {
        try {
            filtros.put("idTipoEstablecimiento", Integer.parseInt(filtroTipoStr));
        } catch (NumberFormatException e) {
            System.err.println("Valor de filtroTipo inválido: " + filtroTipoStr);
        }
    }
    if (filtroEstado != null && !filtroEstado.trim().isEmpty()) {
        filtros.put("estado", filtroEstado.trim());
    }

    List<Establecimiento> establecimientos = establecimientoDAO.listarFiltrado(filtros);
    request.setAttribute("establecimientos", establecimientos);

    List<TipoEstablecimiento> tipos = tipoEstablecimientoDAO.listarTodos();
    request.setAttribute("tiposEstablecimiento", tipos);
    
    request.setAttribute("filtroNombreActual", filtroNombre);
    request.setAttribute("filtroTipoActual", filtroTipoStr);
    request.setAttribute("filtroEstadoActual", filtroEstado);


    request.getRequestDispatcher("listarEstablecimientos.jsp").forward(request, response);
}
    
    private void verHistorialEstablecimiento(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int idEstablecimiento = Integer.parseInt(request.getParameter("idEstablecimiento"));

        Establecimiento establecimiento = establecimientoDAO.obtenerPorId(idEstablecimiento); 
        if (establecimiento == null) {
            request.getSession().setAttribute("mensajeError", "Establecimiento no encontrado (ID: " + idEstablecimiento + ") para ver su historial.");
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
            return;
        }

        List<HistorialCambioEstado> historial = historialDAO.obtenerHistorialPorEstablecimiento(idEstablecimiento);

        request.setAttribute("establecimiento", establecimiento); 
        request.setAttribute("historial", historial);
        request.getRequestDispatcher("historialEstablecimiento.jsp").forward(request, response);

    } catch (NumberFormatException e) {
        request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido para ver historial.");
        response.sendRedirect("ControladorEstablecimiento?accion=listar");
    } catch (Exception e) {
        request.getSession().setAttribute("mensajeError", "Error al cargar el historial del establecimiento: " + e.getMessage());
        response.sendRedirect("ControladorEstablecimiento?accion=listar");
    }
}

    private void registrarEstablecimiento(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogueado)
            throws ServletException, IOException {
        Establecimiento nuevoEst = new Establecimiento();
        try {
            nuevoEst.setNombre(request.getParameter("txtNombre"));
            nuevoEst.setDireccion(request.getParameter("txtDireccion"));
            nuevoEst.setIdTipoEstablecimiento(Integer.parseInt(request.getParameter("selTipoEstablecimiento")));
            nuevoEst.setContactoNombre(request.getParameter("txtContactoNombre"));
            nuevoEst.setContactoTelefono(request.getParameter("txtContactoTelefono"));
            nuevoEst.setContactoEmail(request.getParameter("txtContactoEmail"));
            
            String latStr = request.getParameter("txtLatitud");
            String lonStr = request.getParameter("txtLongitud");
            if (latStr != null && !latStr.trim().isEmpty()) nuevoEst.setLatitud(new BigDecimal(latStr.trim()));
            if (lonStr != null && !lonStr.trim().isEmpty()) nuevoEst.setLongitud(new BigDecimal(lonStr.trim()));

            nuevoEst.setEstado("en proceso");
            nuevoEst.setIdUsuarioRegistro(usuarioLogueado.getIdUsuario());

            if (nuevoEst.getNombre() == null || nuevoEst.getNombre().trim().isEmpty() ||
                nuevoEst.getIdTipoEstablecimiento() == 0) {
                request.setAttribute("mensajeError", "Nombre y Tipo de Establecimiento son obligatorios.");
                List<TipoEstablecimiento> tipos = tipoEstablecimientoDAO.listarTodos();
                request.setAttribute("tiposEstablecimiento", tipos);
                request.setAttribute("establecimiento", nuevoEst);
                request.setAttribute("esNuevo", true);
                request.getRequestDispatcher("formEstablecimiento.jsp").forward(request, response);
                return;
            }

            if (establecimientoDAO.agregar(nuevoEst)) {
                request.getSession().setAttribute("mensajeExito", "Establecimiento '" + nuevoEst.getNombre() + "' registrado exitosamente. Estado: En Proceso.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error al registrar el establecimiento.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensajeError", "Error en el formato de los datos numéricos: " + e.getMessage());

        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Ocurrió un error inesperado: " + e.getMessage());

        }
        response.sendRedirect("ControladorEstablecimiento?accion=listar");
    }
    
        private void verDetalleEstablecimiento(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Establecimiento est = establecimientoDAO.obtenerPorId(id); 

            if (est != null) {
                request.setAttribute("establecimiento", est);
                request.getRequestDispatcher("detalleEstablecimiento.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("mensajeError", "Establecimiento no encontrado (ID: " + id + ").");
                response.sendRedirect("ControladorEstablecimiento?accion=listar");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido para ver detalles.");
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error al cargar detalles del establecimiento: " + e.getMessage());
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
        }
    }
    
private void mostrarMapaEstablecimientos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Establecimiento> todosLosEstablecimientos = establecimientoDAO.listarTodos();

        List<Establecimiento> establecimientosParaMapa = todosLosEstablecimientos.stream()
                .filter(e -> e.getLatitud() != null && e.getLongitud() != null)
                .map(e -> {
                    Establecimiento simpleEst = new Establecimiento();
                    simpleEst.setIdEstablecimiento(e.getIdEstablecimiento());
                    simpleEst.setNombre(e.getNombre());
                    simpleEst.setLatitud(e.getLatitud());
                    simpleEst.setLongitud(e.getLongitud());
                    simpleEst.setEstado(e.getEstado());
                    simpleEst.setDireccion(e.getDireccion());
                    return simpleEst;
                })
                .collect(Collectors.toList());

        Gson gson = new Gson();
        String jsonEstablecimientos = gson.toJson(establecimientosParaMapa);

        request.setAttribute("jsonEstablecimientos", jsonEstablecimientos);
        
        request.getRequestDispatcher("mapaEstablecimientos.jsp").forward(request, response);
    }
        
    private void mostrarFormCambiarEstado(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    try {
        int idEst = Integer.parseInt(request.getParameter("idEstablecimiento"));
        Establecimiento est = establecimientoDAO.obtenerPorId(idEst);
        if (est != null) {
            request.setAttribute("establecimiento", est);
            request.getRequestDispatcher("formCambiarEstadoEstablecimiento.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("mensajeError", "Establecimiento no encontrado para cambiar estado (ID: " + idEst + ").");
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
        }
    } catch (NumberFormatException e) {
         request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido para cambio de estado.");
        response.sendRedirect("ControladorEstablecimiento?accion=listar");
    }
}
    
    private void actualizarEstadoEstablecimiento(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogueado)
    throws ServletException, IOException {
    try {
        int idEstablecimiento = Integer.parseInt(request.getParameter("idEstablecimiento"));
        String nuevoEstado = request.getParameter("selNuevoEstado");
        String motivo = request.getParameter("txtMotivoCambio");

        if (nuevoEstado == null || nuevoEstado.trim().isEmpty()) {
            request.getSession().setAttribute("mensajeErrorFormCambioEstado", "Debe seleccionar un nuevo estado.");
            response.sendRedirect("ControladorEstablecimiento?accion=mostrarformcambiarestado&idEstablecimiento=" + idEstablecimiento);
            return;
        }
        if (motivo == null || motivo.trim().isEmpty()) {
             request.getSession().setAttribute("mensajeErrorFormCambioEstado", "Debe ingresar un motivo para el cambio de estado.");
             response.sendRedirect("ControladorEstablecimiento?accion=mostrarformcambiarestado&idEstablecimiento=" + idEstablecimiento);
            return;
        }
        
        Establecimiento estActual = establecimientoDAO.obtenerPorId(idEstablecimiento);
        if (estActual != null && estActual.getEstado().equalsIgnoreCase(nuevoEstado)) {
            request.getSession().setAttribute("mensajeErrorFormCambioEstado", "El nuevo estado seleccionado es el mismo que el estado actual del establecimiento.");
            response.sendRedirect("ControladorEstablecimiento?accion=mostrarformcambiarestado&idEstablecimiento=" + idEstablecimiento);
            return;
        }


        if (establecimientoDAO.actualizarEstado(idEstablecimiento, nuevoEstado, usuarioLogueado.getIdUsuario(), motivo)) {
            request.getSession().setAttribute("mensajeExito", "Estado del establecimiento ID " + idEstablecimiento + " actualizado correctamente a '" + nuevoEstado + "'.");
        } else {
            request.getSession().setAttribute("mensajeError", "Error al actualizar el estado del establecimiento ID " + idEstablecimiento + ".");
        }
    } catch (NumberFormatException e) {
        request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido al procesar cambio de estado.");
    } catch (Exception e) {
        request.getSession().setAttribute("mensajeError", "Error inesperado al actualizar estado: " + e.getMessage());
    }
    response.sendRedirect("ControladorEstablecimiento?accion=listar");
}


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestionar establecimientos";
    }
}
