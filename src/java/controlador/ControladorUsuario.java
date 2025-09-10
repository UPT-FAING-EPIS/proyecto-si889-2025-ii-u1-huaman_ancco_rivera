/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import modelo.Usuario;
import modeloDAO.UsuarioDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ControladorUsuario", urlPatterns = {"/ControladorUsuario"})
public class ControladorUsuario extends HttpServlet {
    
    UsuarioDAO dao = new UsuarioDAO();
    
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
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false); 

        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login.jsp?error=AccesoNoAutorizado");
            return;
        }

        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        if (!"admin".equalsIgnoreCase(usuarioLogueado.getRol())) {
            request.setAttribute("mensajeError", "No tiene permisos para acceder a esta sección.");

            switch (usuarioLogueado.getRol().toLowerCase()) {
                case "inspector":
                    response.sendRedirect("inspector_dashboard.jsp?error=AccesoDenegado");
                    break;
                case "ciudadano":
                    response.sendRedirect("ciudadano_dashboard.jsp?error=AccesoDenegado");
                    break;
                default:
                    response.sendRedirect("login.jsp?error=RolDesconocido");
                    break;
            }
            return;
        }


        String accion = request.getParameter("accion");
        String vistaJSP = "";

        if (accion == null) {
            accion = "listar"; 
        }

        switch (accion.toLowerCase()) {
            case "listar":
                List<Usuario> lista = dao.listarTodos();
                request.setAttribute("usuarios", lista);
                request.setAttribute("usuarioLogueadoId", usuarioLogueado.getIdUsuario());
                vistaJSP = "gestionUsuarios.jsp";
                break;
            case "nuevo":
                request.setAttribute("usuarioEditar", new Usuario());
                request.setAttribute("esNuevo", true);
                vistaJSP = "formUsuario.jsp";
                break;
            case "agregar":
                agregarUsuario(request, response);
                return;
            case "editar":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Usuario usuarioEditar = dao.obtenerPorId(id);
                    if (usuarioEditar != null) {
                        request.setAttribute("usuarioEditar", usuarioEditar);
                        request.setAttribute("esNuevo", false);
                        vistaJSP = "formUsuario.jsp";
                    } else {
                        request.setAttribute("mensajeError", "Usuario no encontrado para editar.");
                        vistaJSP = "ControladorUsuario?accion=listar";
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensajeError", "ID de usuario inválido.");
                    vistaJSP = "ControladorUsuario?accion=listar";
                }
                break;
            case "actualizar":
                actualizarUsuario(request, response);
                return;
            case "eliminar":
                eliminarUsuario(request, response);
                return;
            default:
                request.setAttribute("usuarios", dao.listarTodos());
                vistaJSP = "gestionUsuarios.jsp";
                break;
        }
        request.getRequestDispatcher(vistaJSP).forward(request, response);
    }
    
    private void agregarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombreUsuario = request.getParameter("txtNombreUsuario");
        String contrasena = request.getParameter("txtContrasena");
        String nombreCompleto = request.getParameter("txtNombreCompleto");
        String correo = request.getParameter("txtCorreo");
        String rol = request.getParameter("selRol");
        boolean activo = "on".equalsIgnoreCase(request.getParameter("chkActivo"));

        if (nombreUsuario == null || nombreUsuario.trim().isEmpty() ||
            contrasena == null || contrasena.trim().isEmpty() || 
            nombreCompleto == null || nombreCompleto.trim().isEmpty() ||
            rol == null || rol.trim().isEmpty()) {
            request.setAttribute("mensajeError", "Todos los campos marcados con * son obligatorios, incluyendo la contraseña para nuevos usuarios.");
            Usuario usuarioForm = new Usuario();
            usuarioForm.setNombreUsuario(nombreUsuario);
            usuarioForm.setNombreCompleto(nombreCompleto);
            usuarioForm.setCorreoElectronico(correo);
            usuarioForm.setRol(rol);
            usuarioForm.setActivo(activo);
            request.setAttribute("usuarioEditar", usuarioForm);
            request.setAttribute("esNuevo", true);
            request.getRequestDispatcher("formUsuario.jsp").forward(request, response);
            return;
        }
        
        if (dao.obtenerPorNombreUsuario(nombreUsuario) != null) {
            request.setAttribute("mensajeError", "El nombre de usuario '" + nombreUsuario + "' ya existe. Por favor, elija otro.");
             Usuario usuarioForm = new Usuario();
            usuarioForm.setNombreUsuario(nombreUsuario);
            usuarioForm.setNombreCompleto(nombreCompleto);
            usuarioForm.setCorreoElectronico(correo);
            usuarioForm.setRol(rol);
            usuarioForm.setActivo(activo);
            request.setAttribute("usuarioEditar", usuarioForm);
            request.setAttribute("esNuevo", true);
            request.getRequestDispatcher("formUsuario.jsp").forward(request, response);
            return;
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombreUsuario(nombreUsuario);
        nuevoUsuario.setContrasena(contrasena);
        nuevoUsuario.setNombreCompleto(nombreCompleto);
        nuevoUsuario.setCorreoElectronico(correo);
        nuevoUsuario.setRol(rol);
        nuevoUsuario.setActivo(activo);

        if (dao.agregar(nuevoUsuario)) {
            request.getSession().setAttribute("mensajeExito", "Usuario agregado correctamente.");
        } else {
            request.getSession().setAttribute("mensajeError", "Error al agregar el usuario.");
        }
        response.sendRedirect("ControladorUsuario?accion=listar");
    }

    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("idUsuario"));
        String nombreUsuario = request.getParameter("txtNombreUsuario");
        String contrasena = request.getParameter("txtContrasena");
        String nombreCompleto = request.getParameter("txtNombreCompleto");
        String correo = request.getParameter("txtCorreo");
        String rol = request.getParameter("selRol");
        boolean activo = "on".equalsIgnoreCase(request.getParameter("chkActivo"));

        if (nombreUsuario == null || nombreUsuario.trim().isEmpty() ||
            nombreCompleto == null || nombreCompleto.trim().isEmpty() ||
            rol == null || rol.trim().isEmpty()) {
            request.setAttribute("mensajeError", "Los campos Nombre de Usuario, Nombre Completo y Rol son obligatorios.");
            Usuario usuarioForm = dao.obtenerPorId(id); 
            usuarioForm.setNombreUsuario(nombreUsuario);
            usuarioForm.setNombreCompleto(nombreCompleto);
            usuarioForm.setCorreoElectronico(correo);
            usuarioForm.setRol(rol);
            usuarioForm.setActivo(activo);

            request.setAttribute("usuarioEditar", usuarioForm);
            request.setAttribute("esNuevo", false);
            request.getRequestDispatcher("formUsuario.jsp").forward(request, response);
            return;
        }

        Usuario existenteConEseNombre = dao.obtenerPorNombreUsuario(nombreUsuario);
        if (existenteConEseNombre != null && existenteConEseNombre.getIdUsuario() != id) {
            request.setAttribute("mensajeError", "El nombre de usuario '" + nombreUsuario + "' ya está en uso por otro usuario. Por favor, elija otro.");
            Usuario usuarioForm = dao.obtenerPorId(id);
            usuarioForm.setNombreUsuario(nombreUsuario);
            usuarioForm.setNombreCompleto(nombreCompleto);
            usuarioForm.setCorreoElectronico(correo);
            usuarioForm.setRol(rol);
            usuarioForm.setActivo(activo);
            request.setAttribute("usuarioEditar", usuarioForm);
            request.setAttribute("esNuevo", false);
            request.getRequestDispatcher("formUsuario.jsp").forward(request, response);
            return;
        }

        Usuario usuarioActualizar = new Usuario();
        usuarioActualizar.setIdUsuario(id);
        usuarioActualizar.setNombreUsuario(nombreUsuario);
        if (contrasena != null && !contrasena.trim().isEmpty()) {
            usuarioActualizar.setContrasena(contrasena);
        }
        usuarioActualizar.setNombreCompleto(nombreCompleto);
        usuarioActualizar.setCorreoElectronico(correo);
        usuarioActualizar.setRol(rol);
        usuarioActualizar.setActivo(activo);

        if (dao.actualizar(usuarioActualizar)) {
            request.getSession().setAttribute("mensajeExito", "Usuario actualizado correctamente.");
        } else {
            request.getSession().setAttribute("mensajeError", "Error al actualizar el usuario.");
        }
        response.sendRedirect("ControladorUsuario?accion=listar");
    }

    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            HttpSession session = request.getSession(false);
            Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
            if (usuarioLogueado != null && usuarioLogueado.getIdUsuario() == id) {
                request.getSession().setAttribute("mensajeError", "No puedes eliminar tu propia cuenta de administrador mientras estás logueado.");
                response.sendRedirect("ControladorUsuario?accion=listar");
                return;
            }
           

            if (dao.eliminar(id)) {
                request.getSession().setAttribute("mensajeExito", "Usuario eliminado correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error al eliminar el usuario. Puede estar referenciado en otras tablas.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensajeError", "ID de usuario inválido para eliminar.");
        }
        response.sendRedirect("ControladorUsuario?accion=listar");
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
        processRequest(request, response);
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
        return "Short description";
    }// </editor-fold>

}
