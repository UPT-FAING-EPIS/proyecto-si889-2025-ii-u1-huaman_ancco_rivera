/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import interfaces.CRUDHistorialCambioEstado;
import modelo.HistorialCambioEstado;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HistorialCambioEstadoDAO implements CRUDHistorialCambioEstado {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    
    @Override
    public List<HistorialCambioEstado> listarCambiosRecientes(int limite) {
        List<HistorialCambioEstado> historialReciente = new ArrayList<>();
        String sql = "SELECT hc.*, u.nombre_completo AS nombre_usuario_modifico, e.nombre AS nombre_establecimiento " +
                     "FROM historial_cambios_estado hc " +
                     "JOIN usuarios u ON hc.id_usuario_modifico = u.id_usuario " +
                     "JOIN establecimientos e ON hc.id_establecimiento = e.id_establecimiento " +
                     "ORDER BY hc.fecha_cambio DESC " +
                     "LIMIT ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, limite);
            rs = ps.executeQuery();
            while (rs.next()) {
                HistorialCambioEstado cambio = new HistorialCambioEstado();
                cambio.setIdHistorial(rs.getInt("id_historial"));
                cambio.setIdEstablecimiento(rs.getInt("id_establecimiento"));
                cambio.setNombreEstablecimiento(rs.getString("nombre_establecimiento")); 
                cambio.setIdUsuarioModifico(rs.getInt("id_usuario_modifico"));
                cambio.setFechaCambio(rs.getTimestamp("fecha_cambio"));
                cambio.setEstadoAnterior(rs.getString("estado_anterior"));
                cambio.setEstadoNuevo(rs.getString("estado_nuevo"));
                cambio.setMotivoCambio(rs.getString("motivo_cambio"));
                cambio.setNombreUsuarioModifico(rs.getString("nombre_usuario_modifico"));
                historialReciente.add(cambio);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar cambios recientes del historial: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return historialReciente;
    }
    
    @Override
    public List<HistorialCambioEstado> obtenerHistorialPorEstablecimiento(int idEstablecimiento) {
        List<HistorialCambioEstado> historial = new ArrayList<>();
        String sql = "SELECT hc.*, u.nombre_completo AS nombre_usuario_modifico " +
                     "FROM historial_cambios_estado hc " +
                     "JOIN usuarios u ON hc.id_usuario_modifico = u.id_usuario " +
                     "WHERE hc.id_establecimiento = ? " +
                     "ORDER BY hc.fecha_cambio DESC";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEstablecimiento);
            rs = ps.executeQuery();
            while (rs.next()) {
                HistorialCambioEstado cambio = new HistorialCambioEstado();
                cambio.setIdHistorial(rs.getInt("id_historial"));
                cambio.setIdEstablecimiento(rs.getInt("id_establecimiento"));
                cambio.setIdUsuarioModifico(rs.getInt("id_usuario_modifico"));
                cambio.setFechaCambio(rs.getTimestamp("fecha_cambio"));
                cambio.setEstadoAnterior(rs.getString("estado_anterior"));
                cambio.setEstadoNuevo(rs.getString("estado_nuevo"));
                cambio.setMotivoCambio(rs.getString("motivo_cambio"));
                cambio.setNombreUsuarioModifico(rs.getString("nombre_usuario_modifico"));
                historial.add(cambio);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener historial de cambios: " + e.getMessage());
            // e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return historial;
    }

    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos JDBC en HistorialCambioEstadoDAO: " + e.getMessage());
        }
    }
}