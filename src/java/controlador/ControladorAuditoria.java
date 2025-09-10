/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import modelo.HistorialCambioEstado;
import modelo.Usuario;
import modeloDAO.HistorialCambioEstadoDAO;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ControladorAuditoria", urlPatterns = {"/ControladorAuditoria"})
public class ControladorAuditoria extends HttpServlet {

    HistorialCambioEstadoDAO historialDAO = new HistorialCambioEstadoDAO();
    private static final int LIMITE_CAMBIOS_RECIENTES = 50;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = null;

        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
            if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
                response.sendRedirect("login.jsp?error=AccesoDenegadoAuditoria");
                return;
            }
        } else {
            response.sendRedirect("login.jsp?error=SesionExpiradaAuditoria");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null || accion.isEmpty()) {
            accion = "verCambiosRecientes";
        }

        switch (accion.toLowerCase()) {
            case "vercambiosrecientes":
                mostrarCambiosRecientes(request, response);
                break;
            default:
                mostrarCambiosRecientes(request, response);
                break;
        }
    }

    private void mostrarCambiosRecientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<HistorialCambioEstado> cambiosRecientes = historialDAO.listarCambiosRecientes(LIMITE_CAMBIOS_RECIENTES);
        request.setAttribute("cambiosRecientes", cambiosRecientes);
        request.setAttribute("limiteMostrado", LIMITE_CAMBIOS_RECIENTES);
        request.getRequestDispatcher("historialGlobalCambios.jsp").forward(request, response);
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
        return "Servlet para Auditoría y Visualización de Historial Global de Cambios";
    }
}