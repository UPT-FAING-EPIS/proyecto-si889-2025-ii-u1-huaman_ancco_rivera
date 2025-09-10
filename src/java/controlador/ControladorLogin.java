/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Usuario;
import modeloDAO.UsuarioDAO;
/**
 *
 * @author ASUS
 */
@WebServlet(name = "ControladorLogin", urlPatterns = {"/ControladorLogin"})
public class ControladorLogin extends HttpServlet {
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    Usuario usuario = new Usuario();
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String accion = request.getParameter("accion"); 

        if (accion != null && accion.equalsIgnoreCase("logout")) {
            HttpSession session = request.getSession(false); 
            if (session != null) {
                session.invalidate(); 
            }
            response.sendRedirect("login.jsp?logout=true");
            return; 
        }
        
        String nombreUser = request.getParameter("txtUsuario");
        String passUser = request.getParameter("txtPassword");

        usuario = usuarioDAO.validarUsuario(nombreUser, passUser);

        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usuario); 
            session.setAttribute("nombreUsuario", usuario.getNombreUsuario()); 
            session.setAttribute("rolUsuario", usuario.getRol());

            // Redirigir según el rol
            switch (usuario.getRol().toLowerCase()) {
                case "admin":
                    request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response); 
                    break;
                case "inspector":
                    request.getRequestDispatcher("inspector_dashboard.jsp").forward(request, response);
                    break;
                case "ciudadano":
                    request.getRequestDispatcher("ciudadano_dashboard.jsp").forward(request, response);
                    break;
                default:
                    request.setAttribute("mensajeError", "Rol de usuario no reconocido.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    break;
            }
        } else { 
            request.setAttribute("mensajeError", "Usuario o contraseña incorrectos. Intente de nuevo.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion != null && accion.equalsIgnoreCase("logout")) {
            processRequest(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet para manejar el login y logout de usuarios";
    }// </editor-fold>

}
