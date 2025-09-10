/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package interfaces;

import modelo.Usuario;
import java.util.List; 

public interface CRUDUsuario {

    public Usuario validarUsuario(String nombreUsuario, String contrasena);

     public List<Usuario> listarTodos();
     public Usuario obtenerPorId(int id);
     public boolean agregar(Usuario usuario);
     public boolean actualizar(Usuario usuario);
     public boolean eliminar(int id);
     public Usuario obtenerPorNombreUsuario(String nombreUsuario); 
}
