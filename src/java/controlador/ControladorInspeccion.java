/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import modelo.Establecimiento;
import modelo.Inspeccion;
import modelo.Usuario;
import modeloDAO.EstablecimientoDAO;
import modeloDAO.InspeccionDAO;
import modeloDAO.UsuarioDAO;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import util.EmailService;
import util.GeneradorActa;
import util.GeneradorNotificaciones;

@WebServlet(name = "ControladorInspeccion", urlPatterns = {"/ControladorInspeccion"})
public class ControladorInspeccion extends HttpServlet {

    InspeccionDAO inspeccionDAO = new InspeccionDAO();
    EstablecimientoDAO establecimientoDAO = new EstablecimientoDAO();
    UsuarioDAO usuarioDAO = new UsuarioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = null;

        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaCI");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) {
            response.sendRedirect("ControladorEstablecimiento?accion=listar&error=AccionInspeccionNoEspecificada");
            return;
        }

        String vistaJSP = "";

        switch (accion.toLowerCase()) {
            case "mostrarformregistro":
                if ("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol())) {
                    mostrarFormRegistroInspeccion(request, response);
                } else {
                    accesoDenegado(request, response);
                }
                return;

            case "registrar": 
                if ("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol())) {
                    registrarInspeccion(request, response, usuarioLogueado);
                } else {
                    accesoDenegado(request, response);
                }
                return;

            case "listarporestablecimiento":
                 if ("admin".equalsIgnoreCase(usuarioLogueado.getRol()) || "inspector".equalsIgnoreCase(usuarioLogueado.getRol()) || "ciudadano".equalsIgnoreCase(usuarioLogueado.getRol())) {
                    listarInspeccionesPorEstablecimiento(request, response);
                } else {
                    accesoDenegado(request, response);
                }
                return;

            default:
                response.sendRedirect("ControladorEstablecimiento?accion=listar&error=AccionInspeccionInvalida");
                return;
        }
    }
    
    private void accesoDenegado(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.getSession().setAttribute("mensajeError", "No tiene permisos para realizar esta acción de inspección.");
        Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        String redirectTo = "ControladorEstablecimiento?accion=listar";
        if (usuarioLogueado != null) {
            switch (usuarioLogueado.getRol().toLowerCase()) {
                case "admin": redirectTo = "admin_dashboard.jsp"; break;
                case "inspector": redirectTo = "inspector_dashboard.jsp"; break;
                case "ciudadano": redirectTo = "ciudadano_dashboard.jsp"; break;
            }
        }
        response.sendRedirect(redirectTo + "?error=AccesoDenegadoInspeccion");
    }


    private void mostrarFormRegistroInspeccion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idEstablecimiento = Integer.parseInt(request.getParameter("idEstablecimiento"));
            Establecimiento establecimiento = establecimientoDAO.obtenerPorId(idEstablecimiento);

            if (establecimiento != null) {
                request.setAttribute("establecimiento", establecimiento);
                request.setAttribute("inspeccion", new Inspeccion()); 
                SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
                request.setAttribute("fechaActual", sdfInput.format(new Date()));
                request.getRequestDispatcher("formInspeccion.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("mensajeError", "Establecimiento no encontrado (ID: " + idEstablecimiento + ") para registrar inspección.");
                response.sendRedirect("ControladorEstablecimiento?accion=listar");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido.");
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
        }
    }

    private void registrarInspeccion(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogueadoInspector)
        throws ServletException, IOException {
    int idEstablecimiento = 0;
    String redirectURL = "ControladorEstablecimiento?accion=listar";

    try {
        idEstablecimiento = Integer.parseInt(request.getParameter("idEstablecimiento"));
        redirectURL = "ControladorInspeccion?accion=listarporestablecimiento&idEstablecimiento=" + idEstablecimiento;

        String fechaStr = request.getParameter("txtFechaInspeccion");
        String observaciones = request.getParameter("txtObservaciones");
        String resultadoInspeccion = request.getParameter("selResultado");

        if (fechaStr == null || fechaStr.trim().isEmpty() ||
            resultadoInspeccion == null || resultadoInspeccion.trim().isEmpty()) {
            request.getSession().setAttribute("mensajeError", "Fecha de inspección y resultado son obligatorios.");
            Establecimiento est = establecimientoDAO.obtenerPorId(idEstablecimiento);
            request.setAttribute("establecimiento", est);
            Inspeccion inspForm = new Inspeccion();
            inspForm.setObservaciones(observaciones);
            inspForm.setResultado(resultadoInspeccion);
            try {
                if(fechaStr != null && !fechaStr.trim().isEmpty()) inspForm.setFechaInspeccion(new SimpleDateFormat("yyyy-MM-dd").parse(fechaStr));
            } catch (ParseException e) { /* ignore */ }

            request.setAttribute("inspeccion", inspForm);
            SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
            request.setAttribute("fechaActual", fechaStr);
            request.getRequestDispatcher("formInspeccion.jsp").forward(request, response);
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date fechaInspeccionDate = sdf.parse(fechaStr);

        Inspeccion nuevaInspeccion = new Inspeccion();
        nuevaInspeccion.setIdEstablecimiento(idEstablecimiento);
        nuevaInspeccion.setIdInspector(usuarioLogueadoInspector.getIdUsuario());
        nuevaInspeccion.setFechaInspeccion(fechaInspeccionDate);
        nuevaInspeccion.setObservaciones(observaciones);
        nuevaInspeccion.setResultado(resultadoInspeccion);

        if (inspeccionDAO.agregar(nuevaInspeccion)) {
            
            request.getSession().setAttribute("mensajeExito", "Inspección registrada exitosamente.");

            Establecimiento establecimientoInspeccionado = establecimientoDAO.obtenerPorId(idEstablecimiento);
            if (establecimientoInspeccionado == null) {
                request.getSession().setAttribute("mensajeError", "No se pudo encontrar el establecimiento para actualizar faltas/estado.");
                response.sendRedirect(redirectURL);
                return;
            }

            String contactoEmailEstablecimiento = establecimientoInspeccionado.getContactoEmail();
            String nombreEstablecimiento = establecimientoInspeccionado.getNombre();
            String urlBase = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
            String linkDetalles = urlBase + "/ControladorEstablecimiento?accion=verdetalle&id=" + idEstablecimiento;

            if ("rechazado".equalsIgnoreCase(resultadoInspeccion)) {
                int nuevoNumeroFaltas = establecimientoDAO.incrementarFaltasYObtenerActual(idEstablecimiento);
                establecimientoInspeccionado.setNumeroFaltas(nuevoNumeroFaltas); 

                String asuntoCorreoEst = "";
                String cuerpoCorreoEstHTML = "";
                boolean enviarCorreoClausuraAdmin = false;

                if (nuevoNumeroFaltas < 3) {
                    asuntoCorreoEst = "SIRESA: Notificación de Advertencia Sanitaria - " + nombreEstablecimiento;
                    cuerpoCorreoEstHTML = GeneradorNotificaciones.generarAdvertenciaHTML(nuevaInspeccion, establecimientoInspeccionado, nuevoNumeroFaltas, linkDetalles);
                } else if (nuevoNumeroFaltas == 3) {
                    asuntoCorreoEst = "NOTIFICACIÓN DE CLAUSURA: ACTA DE OPERATIVO - " + establecimientoInspeccionado.getNombre();
                        cuerpoCorreoEstHTML = GeneradorActa.generarActaDeClausuraHTML(nuevaInspeccion, establecimientoInspeccionado);
                    enviarCorreoClausuraAdmin = true; 
                   
                } else { 
                     asuntoCorreoEst = "SIRESA: Notificación de Incumplimiento Reiterado - " + nombreEstablecimiento;
                     cuerpoCorreoEstHTML = String.format(
                        "<html><body><h3>Notificación de Incumplimiento Reiterado</h3>" +
                        "<p>Estimado responsable del establecimiento <strong>%s</strong> (ID: %d),</p>" +
                        "<p>Le informamos que una inspección realizada el %s ha resultado nuevamente en <strong>RECHAZADO</strong>.</p>" +
                        "<p><strong>Observaciones:</strong> %s</p>" +
                        "<p>Su establecimiento cuenta con <strong>%d faltas</strong> y ya se ha emitido una orden de cierre. Es imperativo que regularice su situación.</p>" +
                        "<p>Puede ver más detalles en: <a href=\"%s\">Detalles del Establecimiento</a></p>" +
                        "<p>Atentamente,<br/>El equipo de SIRESA</p></body></html>",
                        nombreEstablecimiento, idEstablecimiento, sdf.format(fechaInspeccionDate), observaciones, nuevoNumeroFaltas, linkDetalles
                    );
                    enviarCorreoClausuraAdmin = true;
                }

                if (contactoEmailEstablecimiento != null && !contactoEmailEstablecimiento.isEmpty()) {
                    EmailService.enviarCorreo(contactoEmailEstablecimiento, asuntoCorreoEst, cuerpoCorreoEstHTML);
                }
                
                String motivoCambioEstadoGeneral = "Inspección con resultado RECHAZADO. Observaciones: " + (observaciones.length() > 100 ? observaciones.substring(0,100)+"..." : observaciones);
                establecimientoDAO.actualizarEstado(idEstablecimiento, "rechazado", usuarioLogueadoInspector.getIdUsuario(), motivoCambioEstadoGeneral);
                request.getSession().setAttribute("mensajeAdvertencia", "Establecimiento marcado como RECHAZADO. Se han enviado notificaciones de sanción/cierre según corresponda. Faltas acumuladas: " + nuevoNumeroFaltas);


            } else if ("aprobado".equalsIgnoreCase(resultadoInspeccion)) {
                establecimientoDAO.resetFaltas(idEstablecimiento);
                String motivoCambioEstadoGeneral = "Inspección con resultado APROBADO. Observaciones: " + (observaciones.length() > 100 ? observaciones.substring(0,100)+"..." : observaciones);
                establecimientoDAO.actualizarEstado(idEstablecimiento, "aprobado", usuarioLogueadoInspector.getIdUsuario(), motivoCambioEstadoGeneral);
                request.getSession().setAttribute("mensajeExito", "Inspección registrada y estado del establecimiento actualizado a APROBADO. Faltas reseteadas.");

              
                if (contactoEmailEstablecimiento != null && !contactoEmailEstablecimiento.isEmpty()) {
                     String asuntoAprobado = "SIRESA: Inspección Aprobada - " + nombreEstablecimiento;
                     String cuerpoAprobadoHTML = String.format(
                        "<html><body><h3>Inspección Aprobada</h3>" +
                        "<p>Estimado responsable del establecimiento <strong>%s</strong> (ID: %d),</p>" +
                        "<p>Nos complace informarle que la inspección realizada el %s ha resultado en <strong>APROBADO</strong>.</p>" +
                        "<p><strong>Observaciones (si las hubiera):</strong> %s</p>" +
                        "<p>Su contador de faltas ha sido reseteado. ¡Gracias por su cooperación!</p>" +
                        "<p>Puede ver más detalles en: <a href=\"%s\">Detalles del Establecimiento</a></p>" +
                        "<p>Atentamente,<br/>El equipo de SIRESA</p></body></html>",
                        nombreEstablecimiento, idEstablecimiento, sdf.format(fechaInspeccionDate), observaciones, linkDetalles
                    );
                    EmailService.enviarCorreo(contactoEmailEstablecimiento, asuntoAprobado, cuerpoAprobadoHTML);
                }
            }
           

        } else { 
            request.getSession().setAttribute("mensajeError", "Error al registrar la inspección.");
        }
    } catch (NumberFormatException e) {
        request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido al registrar inspección.");
    } catch (ParseException e) {
        request.getSession().setAttribute("mensajeError", "Formato de fecha de inspección inválido. Use yyyy-MM-dd.");
    } catch (Exception e) {
        request.getSession().setAttribute("mensajeError", "Ocurrió un error inesperado: " + e.getMessage());
        e.printStackTrace(); 
    }
    response.sendRedirect(redirectURL);
}

    
    private void listarInspeccionesPorEstablecimiento(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idEstablecimiento = Integer.parseInt(request.getParameter("idEstablecimiento"));
            Establecimiento establecimiento = establecimientoDAO.obtenerPorId(idEstablecimiento);

            if (establecimiento != null) {
                List<Inspeccion> inspecciones = inspeccionDAO.listarPorEstablecimiento(idEstablecimiento);
                request.setAttribute("establecimiento", establecimiento);
                request.setAttribute("inspecciones", inspecciones);
                request.getRequestDispatcher("listarInspecciones.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("mensajeError", "Establecimiento no encontrado (ID: " + idEstablecimiento + ") para listar sus inspecciones.");
                response.sendRedirect("ControladorEstablecimiento?accion=listar");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensajeError", "ID de establecimiento inválido para listar inspecciones.");
            response.sendRedirect("ControladorEstablecimiento?accion=listar");
        }
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
        return "Servlet para gestionar las inspecciones de los establecimientos";
    }
}