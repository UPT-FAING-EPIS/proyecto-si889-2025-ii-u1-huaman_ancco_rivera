/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import interfaces.CRUDUsuario;
import modelo.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO implements CRUDUsuario {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public Usuario validarUsuario(String nombreUsuario, String contrasena) {
        Usuario usr = null;
        String sql = "SELECT * FROM usuarios WHERE nombre_usuario = ? AND contrasena = ? AND activo = TRUE";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, nombreUsuario);
            ps.setString(2, contrasena);
            rs = ps.executeQuery();

            if (rs.next()) {
                usr = new Usuario();
                usr.setIdUsuario(rs.getInt("id_usuario"));
                usr.setNombreUsuario(rs.getString("nombre_usuario"));
                usr.setRol(rs.getString("rol"));
                usr.setNombreCompleto(rs.getString("nombre_completo"));
                usr.setCorreoElectronico(rs.getString("correo_electronico"));
                usr.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                usr.setActivo(rs.getBoolean("activo"));
            }
        } catch (SQLException e) {
            System.err.println("Error al validar usuario: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return usr;
    }

    @Override
    public List<Usuario> listarTodos() {
        List<Usuario> listaUsuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY nombre_completo ASC";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Usuario usr = new Usuario();
                usr.setIdUsuario(rs.getInt("id_usuario"));
                usr.setNombreUsuario(rs.getString("nombre_usuario"));
                usr.setRol(rs.getString("rol"));
                usr.setNombreCompleto(rs.getString("nombre_completo"));
                usr.setCorreoElectronico(rs.getString("correo_electronico"));
                usr.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                usr.setActivo(rs.getBoolean("activo"));
                listaUsuarios.add(usr);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return listaUsuarios;
    }

    @Override
    public Usuario obtenerPorId(int id) {
        Usuario usr = null;
        String sql = "SELECT * FROM usuarios WHERE id_usuario = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                usr = new Usuario();
                usr.setIdUsuario(rs.getInt("id_usuario"));
                usr.setNombreUsuario(rs.getString("nombre_usuario"));
                usr.setRol(rs.getString("rol"));
                usr.setNombreCompleto(rs.getString("nombre_completo"));
                usr.setCorreoElectronico(rs.getString("correo_electronico"));
                usr.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                usr.setActivo(rs.getBoolean("activo"));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuario por ID: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return usr;
    }
    
    public List<Usuario> listarInspectores() {
        List<Usuario> listaInspectores = new ArrayList<>();
        String sql = "SELECT id_usuario, nombre_usuario, nombre_completo FROM usuarios WHERE rol = 'inspector' AND activo = TRUE ORDER BY nombre_completo ASC";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Usuario usr = new Usuario();
                usr.setIdUsuario(rs.getInt("id_usuario"));
                usr.setNombreUsuario(rs.getString("nombre_usuario"));
                usr.setNombreCompleto(rs.getString("nombre_completo"));
                listaInspectores.add(usr);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar inspectores: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return listaInspectores;
    }

    @Override
    public Usuario obtenerPorNombreUsuario(String nombreUsuario) {
        Usuario usr = null;
        String sql = "SELECT * FROM usuarios WHERE nombre_usuario = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, nombreUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                usr = new Usuario();
                usr.setIdUsuario(rs.getInt("id_usuario"));
                usr.setNombreUsuario(rs.getString("nombre_usuario"));
                usr.setRol(rs.getString("rol"));
                usr.setNombreCompleto(rs.getString("nombre_completo"));
                usr.setCorreoElectronico(rs.getString("correo_electronico"));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuario por nombre de usuario: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return usr;
    }

    @Override
    public boolean agregar(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre_usuario, contrasena, rol, nombre_completo, correo_electronico, activo) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, usuario.getNombreUsuario());
            ps.setString(2, usuario.getContrasena());
            ps.setString(3, usuario.getRol());
            ps.setString(4, usuario.getNombreCompleto());
            ps.setString(5, usuario.getCorreoElectronico());
            ps.setBoolean(6, usuario.isActivo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al agregar usuario: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos();
        }
    }

    @Override
    public boolean actualizar(Usuario usuario) {
        String sql;
        boolean actualizaPassword = usuario.getContrasena() != null && !usuario.getContrasena().trim().isEmpty();

        if (actualizaPassword) {
            sql = "UPDATE usuarios SET nombre_usuario = ?, contrasena = ?, rol = ?, nombre_completo = ?, correo_electronico = ?, activo = ? WHERE id_usuario = ?";
        } else {
            sql = "UPDATE usuarios SET nombre_usuario = ?, rol = ?, nombre_completo = ?, correo_electronico = ?, activo = ? WHERE id_usuario = ?";
        }
        
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, usuario.getNombreUsuario());
            
            int paramIndex = 2;
            if (actualizaPassword) {
                ps.setString(paramIndex++, usuario.getContrasena());
            }
            ps.setString(paramIndex++, usuario.getRol());
            ps.setString(paramIndex++, usuario.getNombreCompleto());
            ps.setString(paramIndex++, usuario.getCorreoElectronico());
            ps.setBoolean(paramIndex++, usuario.isActivo());
            ps.setInt(paramIndex++, usuario.getIdUsuario());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar usuario: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos();
        }
    }

    @Override
    public boolean eliminar(int id) {
        String sql = "DELETE FROM usuarios WHERE id_usuario = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar usuario: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos();
        }
    }

    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos JDBC: " + e.getMessage());
        }
    }
}