/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import modelo.Establecimiento;
import modelo.Usuario;
import modeloDAO.EstablecimientoDAO;
import modelo.Inspeccion; 
import modeloDAO.InspeccionDAO; 
import modeloDAO.UsuarioDAO;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;

@WebServlet(name = "ControladorReporte", urlPatterns = {"/ControladorReporte"})
public class ControladorReporte extends HttpServlet {

    EstablecimientoDAO establecimientoDAO = new EstablecimientoDAO();
    InspeccionDAO inspeccionDAO = new InspeccionDAO(); 
    UsuarioDAO usuarioDAO = new UsuarioDAO(); 

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = null;

        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
            if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoReportes");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaReportes");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "mostrarFormulario";
        }

        switch (accion.toLowerCase()) {
            case "mostrarformulario":
            List<Usuario> inspectores = usuarioDAO.listarInspectores();
            request.setAttribute("listaInspectores", inspectores);
            request.getRequestDispatcher("formReportes.jsp").forward(request, response);
            break;
            case "generarreporteporestado":
                generarReportePorEstado(request, response);
                break;
            case "generarreporteporperiodo":
                generarReportePorPeriodo(request, response);
                break;
            case "generarreporteinspeccionesresultado":
            generarReporteInspeccionesResultado(request, response);
            break;
        case "generarreporteinspeccionesdetallado":
            generarReporteInspeccionesDetallado(request, response);
            break;
              
            default:
                request.getRequestDispatcher("formReportes.jsp").forward(request, response);
                break;
        }
    }
    
    private void generarReporteInspeccionesResultado(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String fechaInicioStr = request.getParameter("fechaInicioInspeccionResultado");
    String fechaFinStr = request.getParameter("fechaFinInspeccionResultado");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    if (fechaInicioStr == null || fechaInicioStr.isEmpty() || fechaFinStr == null || fechaFinStr.isEmpty()) {
        request.setAttribute("mensajeErrorReporte", "Debe seleccionar ambas fechas para el reporte de resultados de inspección.");
        List<Usuario> inspectores = usuarioDAO.listarInspectores();
        request.setAttribute("listaInspectores", inspectores);
        request.getRequestDispatcher("formReportes.jsp").forward(request, response);
        return;
    }

    try {
        Date fechaInicio = sdf.parse(fechaInicioStr);
        Date fechaFin = sdf.parse(fechaFinStr);

        if (fechaInicio.after(fechaFin)) {
            request.setAttribute("mensajeErrorReporte", "La fecha de inicio no puede ser posterior a la fecha de fin para el reporte de resultados.");
            List<Usuario> inspectores = usuarioDAO.listarInspectores();
            request.setAttribute("listaInspectores", inspectores);
            request.getRequestDispatcher("formReportes.jsp").forward(request, response);
            return;
        }

        Map<String, Integer> conteoResultados = inspeccionDAO.contarInspeccionesPorResultadoEnPeriodo(fechaInicio, fechaFin);
        request.setAttribute("conteoResultadosInspeccion", conteoResultados);
        request.setAttribute("fechaInicioReporteInspResultado", fechaInicioStr);
        request.setAttribute("fechaFinReporteInspResultado", fechaFinStr);
        request.getRequestDispatcher("reporteInspeccionesResultado.jsp").forward(request, response);

    } catch (ParseException e) {
        request.setAttribute("mensajeErrorReporte", "Formato de fecha inválido para el reporte de resultados. Utilice AAAA-MM-DD.");
        List<Usuario> inspectores = usuarioDAO.listarInspectores();
        request.setAttribute("listaInspectores", inspectores);
        request.getRequestDispatcher("formReportes.jsp").forward(request, response);
    }
}

private void generarReporteInspeccionesDetallado(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String fechaInicioStr = request.getParameter("fechaInicioInspeccionDetalle"); 
    String fechaFinStr = request.getParameter("fechaFinInspeccionDetalle");
    String idInspectorStr = request.getParameter("filtroInspector");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    if (fechaInicioStr == null || fechaInicioStr.isEmpty() || fechaFinStr == null || fechaFinStr.isEmpty()) {
        request.setAttribute("mensajeErrorReporte", "Debe seleccionar ambas fechas para el reporte detallado de inspecciones.");
        List<Usuario> inspectores = usuarioDAO.listarInspectores();
        request.setAttribute("listaInspectores", inspectores);
        request.getRequestDispatcher("formReportes.jsp").forward(request, response);
        return;
    }

    try {
        Date fechaInicio = sdf.parse(fechaInicioStr);
        Date fechaFin = sdf.parse(fechaFinStr);
        int idInspector = 0;

        if (idInspectorStr != null && !idInspectorStr.isEmpty() && !idInspectorStr.equals("0") && !idInspectorStr.equals("-1")) {
            try {
                idInspector = Integer.parseInt(idInspectorStr);
            } catch (NumberFormatException e) {
                System.err.println("ID de inspector inválido: " + idInspectorStr + ". Mostrando todos.");
            }
        }


        if (fechaInicio.after(fechaFin)) {
            request.setAttribute("mensajeErrorReporte", "La fecha de inicio no puede ser posterior a la fecha de fin para el reporte detallado.");
            List<Usuario> inspectores = usuarioDAO.listarInspectores();
            request.setAttribute("listaInspectores", inspectores);
            request.getRequestDispatcher("formReportes.jsp").forward(request, response);
            return;
        }

        List<Inspeccion> inspecciones = inspeccionDAO.listarInspeccionesPorPeriodo(fechaInicio, fechaFin, idInspector);
        request.setAttribute("inspeccionesDetalladas", inspecciones);
        request.setAttribute("fechaInicioReporteInspDetalle", fechaInicioStr);
        request.setAttribute("fechaFinReporteInspDetalle", fechaFinStr);

        if(idInspector > 0){
             Usuario inspectorSeleccionado = usuarioDAO.obtenerPorId(idInspector);
             if(inspectorSeleccionado != null){
                 request.setAttribute("nombreInspectorFiltrado", inspectorSeleccionado.getNombreCompleto());
             }
        }
        request.setAttribute("idInspectorFiltrado", idInspector);

        request.getRequestDispatcher("reporteInspeccionesDetallado.jsp").forward(request, response);

    } catch (ParseException e) {
        request.setAttribute("mensajeErrorReporte", "Formato de fecha inválido para el reporte detallado. Utilice AAAA-MM-DD.");
        List<Usuario> inspectores = usuarioDAO.listarInspectores();
        request.setAttribute("listaInspectores", inspectores);
        request.getRequestDispatcher("formReportes.jsp").forward(request, response);
    }
}
    
    private void generarReportePorEstado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Integer> conteo = establecimientoDAO.contarEstablecimientosPorEstado();
        request.setAttribute("conteoPorEstado", conteo);
        request.getRequestDispatcher("reportePorEstado.jsp").forward(request, response);
    }

    private void generarReportePorPeriodo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fechaInicioStr = request.getParameter("fechaInicio");
        String fechaFinStr = request.getParameter("fechaFin");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        if (fechaInicioStr == null || fechaInicioStr.isEmpty() || fechaFinStr == null || fechaFinStr.isEmpty()) {
            request.setAttribute("mensajeErrorReporte", "Debe seleccionar ambas fechas para el reporte por período.");
            request.getRequestDispatcher("formReportes.jsp").forward(request, response);
            return;
        }

        try {
            Date fechaInicioUtil = sdf.parse(fechaInicioStr);
            Date fechaFinUtil = sdf.parse(fechaFinStr);

            if (fechaInicioUtil.after(fechaFinUtil)) {
                request.setAttribute("mensajeErrorReporte", "La fecha de inicio no puede ser posterior a la fecha de fin.");
                request.getRequestDispatcher("formReportes.jsp").forward(request, response);
                return;
            }

            List<Establecimiento> establecimientos = establecimientoDAO.listarEstablecimientosPorFechaRegistro(fechaInicioUtil, fechaFinUtil);
            request.setAttribute("establecimientosPeriodo", establecimientos);
            
            Map<java.sql.Date, Integer> conteoPorDia = establecimientoDAO.contarEstablecimientosPorDiaEnPeriodo(fechaInicioUtil, fechaFinUtil);
            
            List<String> chartLabelsPeriodo = new ArrayList<>();
            List<Integer> chartDataValuesPeriodo = new ArrayList<>();
            SimpleDateFormat sdfChartLabels = new SimpleDateFormat("dd/MM/yyyy"); 


            for (Map.Entry<java.sql.Date, Integer> entry : conteoPorDia.entrySet()) {
                chartLabelsPeriodo.add(sdfChartLabels.format(entry.getKey()));
                chartDataValuesPeriodo.add(entry.getValue());
            }
            
            request.setAttribute("chartLabelsPeriodo", chartLabelsPeriodo);
            request.setAttribute("chartDataValuesPeriodo", chartDataValuesPeriodo);
            
            request.setAttribute("fechaInicioReporte", fechaInicioStr);
            request.setAttribute("fechaFinReporte", fechaFinStr);
            
            request.getRequestDispatcher("reportePorPeriodo.jsp").forward(request, response);

        } catch (ParseException e) {
            request.setAttribute("mensajeErrorReporte", "Formato de fecha inválido. Utilice AAAA-MM-DD.");
            request.getRequestDispatcher("formReportes.jsp").forward(request, response);
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
        return "Servlet para la generación de reportes";
    }
}