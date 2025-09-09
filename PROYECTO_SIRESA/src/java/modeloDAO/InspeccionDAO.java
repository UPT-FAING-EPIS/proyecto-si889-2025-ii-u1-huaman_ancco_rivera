/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import interfaces.CRUDInspeccion;
import modelo.Inspeccion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InspeccionDAO implements CRUDInspeccion {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public boolean agregar(Inspeccion inspeccion) {
        String sql = "INSERT INTO inspecciones (id_establecimiento, id_inspector, fecha_inspeccion, observaciones, resultado) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, inspeccion.getIdEstablecimiento());
            ps.setInt(2, inspeccion.getIdInspector());

            if (inspeccion.getFechaInspeccion() != null) {
                ps.setTimestamp(3, new Timestamp(inspeccion.getFechaInspeccion().getTime()));
            } else {
                ps.setNull(3, java.sql.Types.TIMESTAMP); 
            }
            
            ps.setString(4, inspeccion.getObservaciones());
            ps.setString(5, inspeccion.getResultado());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al agregar inspección: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos();
        }
    }

    @Override
    public List<Inspeccion> listarPorEstablecimiento(int idEstablecimiento) {
        List<Inspeccion> listaInspecciones = new ArrayList<>();
        String sql = "SELECT i.*, u.nombre_completo AS nombre_inspector, e.nombre AS nombre_establecimiento " +
                     "FROM inspecciones i " +
                     "JOIN usuarios u ON i.id_inspector = u.id_usuario " +
                     "JOIN establecimientos e ON i.id_establecimiento = e.id_establecimiento " +
                     "WHERE i.id_establecimiento = ? " +
                     "ORDER BY i.fecha_inspeccion DESC, i.fecha_registro_sistema DESC";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEstablecimiento);
            rs = ps.executeQuery();
            while (rs.next()) {
                Inspeccion insp = new Inspeccion();
                insp.setIdInspeccion(rs.getInt("id_inspeccion"));
                insp.setIdEstablecimiento(rs.getInt("id_establecimiento"));
                insp.setIdInspector(rs.getInt("id_inspector"));
                insp.setFechaInspeccion(rs.getTimestamp("fecha_inspeccion")); // Timestamp se puede asignar a java.util.Date
                insp.setObservaciones(rs.getString("observaciones"));
                insp.setResultado(rs.getString("resultado"));
                insp.setFechaRegistroSistema(rs.getTimestamp("fecha_registro_sistema"));
                

                insp.setNombreInspector(rs.getString("nombre_inspector"));
                insp.setNombreEstablecimiento(rs.getString("nombre_establecimiento"));
                
                listaInspecciones.add(insp);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar inspecciones por establecimiento: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return listaInspecciones;
    }

    @Override
    public List<Inspeccion> listarPorInspector(int idInspector) {
        List<Inspeccion> listaInspecciones = new ArrayList<>();
        String sql = "SELECT i.*, u.nombre_completo AS nombre_inspector, e.nombre AS nombre_establecimiento " +
                     "FROM inspecciones i " +
                     "JOIN usuarios u ON i.id_inspector = u.id_usuario " +
                     "JOIN establecimientos e ON i.id_establecimiento = e.id_establecimiento " +
                     "WHERE i.id_inspector = ? " +
                     "ORDER BY i.fecha_inspeccion DESC, i.fecha_registro_sistema DESC";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idInspector);
            rs = ps.executeQuery();
            while (rs.next()) {
                Inspeccion insp = new Inspeccion();
                insp.setIdInspeccion(rs.getInt("id_inspeccion"));
                insp.setIdEstablecimiento(rs.getInt("id_establecimiento"));
                insp.setIdInspector(rs.getInt("id_inspector"));
                insp.setFechaInspeccion(rs.getTimestamp("fecha_inspeccion"));
                insp.setObservaciones(rs.getString("observaciones"));
                insp.setResultado(rs.getString("resultado"));
                insp.setFechaRegistroSistema(rs.getTimestamp("fecha_registro_sistema"));
                
                insp.setNombreInspector(rs.getString("nombre_inspector"));
                insp.setNombreEstablecimiento(rs.getString("nombre_establecimiento"));
                
                listaInspecciones.add(insp);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar inspecciones por inspector: " + e.getMessage());

        } finally {
            cerrarRecursos();
        }
        return listaInspecciones;
    }

    public Map<String, Integer> contarInspeccionesPorResultadoEnPeriodo(Date fechaInicio, Date fechaFin) {
        Map<String, Integer> conteoPorResultado = new HashMap<>();
        String sql = "SELECT resultado, COUNT(*) AS cantidad " +
                     "FROM inspecciones " +
                     "WHERE DATE(fecha_inspeccion) BETWEEN ? AND ? " + 
                     "GROUP BY resultado";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(fechaInicio.getTime()));
            ps.setDate(2, new java.sql.Date(fechaFin.getTime()));
            
            rs = ps.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString("resultado");
                if (resultado != null) { 
                    conteoPorResultado.put(resultado, rs.getInt("cantidad"));
                }
            }
            conteoPorResultado.putIfAbsent("aprobado", 0);
            conteoPorResultado.putIfAbsent("rechazado", 0);

        } catch (SQLException e) {
            System.err.println("Error al contar inspecciones por resultado en período: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return conteoPorResultado;
    }
    
    public List<Inspeccion> listarInspeccionesPorPeriodo(Date fechaInicio, Date fechaFin, int idInspector) {
        List<Inspeccion> listaInspecciones = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
            "SELECT i.*, u.nombre_completo AS nombre_inspector, e.nombre AS nombre_establecimiento " +
            "FROM inspecciones i " +
            "JOIN usuarios u ON i.id_inspector = u.id_usuario " +
            "JOIN establecimientos e ON i.id_establecimiento = e.id_establecimiento " +
            "WHERE DATE(i.fecha_inspeccion) BETWEEN ? AND ? "
        );

        if (idInspector > 0) {
            sqlBuilder.append("AND i.id_inspector = ? ");
        }
        sqlBuilder.append("ORDER BY i.fecha_inspeccion DESC, i.id_inspeccion DESC");

        try {
            con = cn.conectar();
            ps = con.prepareStatement(sqlBuilder.toString());
            ps.setDate(1, new java.sql.Date(fechaInicio.getTime()));
            ps.setDate(2, new java.sql.Date(fechaFin.getTime()));
            if (idInspector > 0) {
                ps.setInt(3, idInspector);
            }
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Inspeccion insp = new Inspeccion();
                insp.setIdInspeccion(rs.getInt("id_inspeccion"));
                insp.setIdEstablecimiento(rs.getInt("id_establecimiento"));
                insp.setIdInspector(rs.getInt("id_inspector"));
                insp.setFechaInspeccion(rs.getTimestamp("fecha_inspeccion"));
                insp.setObservaciones(rs.getString("observaciones"));
                insp.setResultado(rs.getString("resultado"));
                insp.setFechaRegistroSistema(rs.getTimestamp("fecha_registro_sistema"));
                
                insp.setNombreInspector(rs.getString("nombre_inspector"));
                insp.setNombreEstablecimiento(rs.getString("nombre_establecimiento"));
                
                listaInspecciones.add(insp);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar inspecciones por período: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return listaInspecciones;
    }
    
    @Override
    public Inspeccion obtenerPorId(int idInspeccion) {
        Inspeccion insp = null;
        String sql = "SELECT i.*, u.nombre_completo AS nombre_inspector, e.nombre AS nombre_establecimiento " +
                     "FROM inspecciones i " +
                     "JOIN usuarios u ON i.id_inspector = u.id_usuario " +
                     "JOIN establecimientos e ON i.id_establecimiento = e.id_establecimiento " +
                     "WHERE i.id_inspeccion = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idInspeccion);
            rs = ps.executeQuery();
            if (rs.next()) {
                insp = new Inspeccion();
                insp.setIdInspeccion(rs.getInt("id_inspeccion"));
                insp.setIdEstablecimiento(rs.getInt("id_establecimiento"));
                insp.setIdInspector(rs.getInt("id_inspector"));
                insp.setFechaInspeccion(rs.getTimestamp("fecha_inspeccion"));
                insp.setObservaciones(rs.getString("observaciones"));
                insp.setResultado(rs.getString("resultado"));
                insp.setFechaRegistroSistema(rs.getTimestamp("fecha_registro_sistema"));
                
                insp.setNombreInspector(rs.getString("nombre_inspector"));
                insp.setNombreEstablecimiento(rs.getString("nombre_establecimiento"));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener inspección por ID: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return insp;
    }

    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos JDBC en InspeccionDAO: " + e.getMessage());
        }
    }
}