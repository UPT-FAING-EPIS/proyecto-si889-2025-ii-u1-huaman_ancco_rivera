/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import interfaces.CRUDEstablecimiento;
import modelo.Establecimiento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

public class EstablecimientoDAO implements CRUDEstablecimiento {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
        
    @Override
    public List<Establecimiento> listarFiltrado(Map<String, Object> filtros) {
        List<Establecimiento> listaEstablecimientos = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
    "SELECT e.*, te.nombre_tipo, u.nombre_completo AS nombre_usuario_registrador " +
    "FROM establecimientos e " +
    "INNER JOIN tipos_establecimiento te ON e.id_tipo_establecimiento = te.id_tipo_establecimiento " +
    "LEFT JOIN usuarios u ON e.id_usuario_registro = u.id_usuario "
        );
        List<Object> params = new ArrayList<>();
        sqlBuilder.append(" WHERE e.activo = TRUE "); 

        if (filtros != null && !filtros.isEmpty()) {
            String nombre = (String) filtros.get("nombre");
            if (nombre != null && !nombre.trim().isEmpty()) {
                sqlBuilder.append(" AND e.nombre LIKE ?"); 
                params.add("%" + nombre.trim() + "%");
            }

            Integer idTipo = (Integer) filtros.get("idTipoEstablecimiento");
            if (idTipo != null && idTipo > 0) {
                sqlBuilder.append(" AND e.id_tipo_establecimiento = ?");
                params.add(idTipo);
            }

            String estado = (String) filtros.get("estado");
            if (estado != null && !estado.trim().isEmpty()) {
                sqlBuilder.append(" AND e.estado = ?");
                params.add(estado.trim());
            }
        }
        sqlBuilder.append(" ORDER BY e.fecha_registro DESC");

        try {
            con = cn.conectar();
            ps = con.prepareStatement(sqlBuilder.toString());

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                Establecimiento est = new Establecimiento();
                est.setIdEstablecimiento(rs.getInt("id_establecimiento"));
                est.setNumeroFaltas(rs.getInt("numero_faltas"));
                est.setNombre(rs.getString("nombre"));
                est.setDireccion(rs.getString("direccion"));
                est.setIdTipoEstablecimiento(rs.getInt("id_tipo_establecimiento"));
                est.setContactoNombre(rs.getString("contacto_nombre"));
                est.setContactoTelefono(rs.getString("contacto_telefono"));
                est.setContactoEmail(rs.getString("contacto_email"));
                est.setEstado(rs.getString("estado"));
                est.setLatitud(rs.getBigDecimal("latitud"));
                est.setLongitud(rs.getBigDecimal("longitud"));
                est.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                est.setIdUsuarioRegistro(rs.getInt("id_usuario_registro"));
                est.setNombreTipoEstablecimiento(rs.getString("nombre_tipo"));
                est.setNombreUsuarioRegistro(rs.getString("nombre_usuario_registrador"));
                est.setActivo(rs.getBoolean("activo"));
                listaEstablecimientos.add(est);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar/filtrar establecimientos: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return listaEstablecimientos;
    }
    
    @Override
    public boolean agregar(Establecimiento establecimiento) {
        String sql = "INSERT INTO establecimientos (nombre, direccion, id_tipo_establecimiento, " +
                     "contacto_nombre, contacto_telefono, contacto_email, estado, " +
                     "latitud, longitud, id_usuario_registro) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, establecimiento.getNombre());
            ps.setString(2, establecimiento.getDireccion());
            ps.setInt(3, establecimiento.getIdTipoEstablecimiento());
            ps.setString(4, establecimiento.getContactoNombre());
            ps.setString(5, establecimiento.getContactoTelefono());
            ps.setString(6, establecimiento.getContactoEmail());
            ps.setString(7, establecimiento.getEstado() != null ? establecimiento.getEstado() : "en proceso");
            
            if (establecimiento.getLatitud() != null) {
                ps.setBigDecimal(8, establecimiento.getLatitud());
            } else {
                ps.setNull(8, java.sql.Types.DECIMAL);
            }
            
            if (establecimiento.getLongitud() != null) {
                ps.setBigDecimal(9, establecimiento.getLongitud());
            } else {
                ps.setNull(9, java.sql.Types.DECIMAL);
            }
            
            ps.setInt(10, establecimiento.getIdUsuarioRegistro());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al agregar establecimiento: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos();
        }
    }
    
    
    
    @Override
    public List<Establecimiento> listarTodos() {
        return listarFiltrado(new java.util.HashMap<>());
    }
    
    

    @Override
    public Establecimiento obtenerPorId(int id) {
        Establecimiento est = null;
        String sql = "SELECT e.*, te.nombre_tipo, u.nombre_completo AS nombre_usuario_registrador " +
             "FROM establecimientos e " +
             "INNER JOIN tipos_establecimiento te ON e.id_tipo_establecimiento = te.id_tipo_establecimiento " +
             "LEFT JOIN usuarios u ON e.id_usuario_registro = u.id_usuario " +
             "WHERE e.id_establecimiento = ? AND e.activo = TRUE";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                est = new Establecimiento();
                est.setIdEstablecimiento(rs.getInt("id_establecimiento"));
                est.setNombre(rs.getString("nombre"));
                est.setDireccion(rs.getString("direccion"));
                est.setIdTipoEstablecimiento(rs.getInt("id_tipo_establecimiento"));
                est.setNumeroFaltas(rs.getInt("numero_faltas"));
                est.setContactoNombre(rs.getString("contacto_nombre"));
                est.setContactoTelefono(rs.getString("contacto_telefono"));
                est.setContactoEmail(rs.getString("contacto_email"));
                est.setEstado(rs.getString("estado"));
                est.setLatitud(rs.getBigDecimal("latitud"));
                est.setLongitud(rs.getBigDecimal("longitud"));
                est.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                est.setIdUsuarioRegistro(rs.getInt("id_usuario_registro"));
                est.setActivo(rs.getBoolean("activo"));
                
                est.setNombreTipoEstablecimiento(rs.getString("nombre_tipo"));
                est.setNombreUsuarioRegistro(rs.getString("nombre_usuario_registrador"));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener establecimiento por ID: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return est;
    }

    @Override
    public boolean actualizarEstado(int idEstablecimiento, String nuevoEstado, int idUsuarioModifico, String motivo) {
        String sqlEst = "UPDATE establecimientos SET estado = ? WHERE id_establecimiento = ?";
        String sqlHist = "INSERT INTO historial_cambios_estado (id_establecimiento, id_usuario_modifico, estado_anterior, estado_nuevo, motivo_cambio) " +
                         "VALUES (?, ?, (SELECT estado FROM establecimientos WHERE id_establecimiento = ?), ?, ?)";
        
        Connection conn = null; 
        PreparedStatement psEst = null;
        PreparedStatement psHist = null;
        boolean exito = false;

        try {
            conn = cn.conectar();
            conn.setAutoCommit(false);

            psEst = conn.prepareStatement(sqlEst);
            psEst.setString(1, nuevoEstado);
            psEst.setInt(2, idEstablecimiento);
            int filasActualizadas = psEst.executeUpdate();

            if (filasActualizadas > 0) {

                psHist = conn.prepareStatement(sqlHist);
                psHist.setInt(1, idEstablecimiento);
                psHist.setInt(2, idUsuarioModifico);
                psHist.setInt(3, idEstablecimiento);
                psHist.setString(4, nuevoEstado);
                psHist.setString(5, motivo);
                psHist.executeUpdate();
                
                conn.commit(); 
                exito = true;
            } else {
                conn.rollback(); 
            }

        } catch (SQLException e) {
            System.err.println("Error al actualizar estado del establecimiento y registrar historial: " + e.getMessage());
             if (conn != null) {
                try {
                    conn.rollback(); 
                } catch (SQLException ex) {
                    System.err.println("Error al hacer rollback: " + ex.getMessage());
                }
            }
        } finally {
            try {
                if (psEst != null) psEst.close();
                if (psHist != null) psHist.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error al cerrar recursos en actualizarEstado: " + e.getMessage());
            }
        }
        return exito;
    }
    
    public Map<String, Integer> contarEstablecimientosPorEstado() {
        Map<String, Integer> conteoPorEstado = new HashMap<>();
        String sql = "SELECT estado, COUNT(*) AS cantidad FROM establecimientos WHERE activo = TRUE GROUP BY estado";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                String estado = rs.getString("estado");
                int cantidad = rs.getInt("cantidad");
                if (estado != null) { 
                    conteoPorEstado.put(estado, cantidad);
                }
            }
            String[] todosLosEstados = {"aprobado", "rechazado", "en proceso"};
            for(String estadoPosible : todosLosEstados){
                conteoPorEstado.putIfAbsent(estadoPosible, 0);
            }

        } catch (SQLException e) {
            System.err.println("Error al contar establecimientos por estado: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return conteoPorEstado;
    }
    
    public int incrementarFaltasYObtenerActual(int idEstablecimiento) {
    String selectBeforeSql = "SELECT numero_faltas FROM establecimientos WHERE id_establecimiento = ?";
    String updateSql = "UPDATE establecimientos SET numero_faltas = numero_faltas + 1 WHERE id_establecimiento = ?";
    String selectAfterSql = "SELECT numero_faltas FROM establecimientos WHERE id_establecimiento = ?";
    
    int faltasAntes = -1;
    int nuevoNumeroFaltas = -1;
    PreparedStatement psSelectBeforeLocal = null;
    PreparedStatement psUpdateLocal = null;
    PreparedStatement psSelectAfterLocal = null;
    ResultSet rsBeforeLocal = null;
    ResultSet rsAfterLocal = null;

    System.out.println("DEBUG DAO.incrementarFaltas: Entrando para idEstablecimiento: " + idEstablecimiento + " (Thread: " + Thread.currentThread().getId() + ")");

    try {
        con = cn.conectar();

        psSelectBeforeLocal = con.prepareStatement(selectBeforeSql);
        psSelectBeforeLocal.setInt(1, idEstablecimiento);
        rsBeforeLocal = psSelectBeforeLocal.executeQuery();
        if (rsBeforeLocal.next()) {
            faltasAntes = rsBeforeLocal.getInt("numero_faltas");
            System.out.println("DEBUG DAO.incrementarFaltas: Faltas ANTES del update para ID " + idEstablecimiento + ": " + faltasAntes);
        } else {
             System.out.println("DEBUG DAO.incrementarFaltas: No se encontró establecimiento ANTES del update para ID " + idEstablecimiento);
             return -1; 
        }

        psUpdateLocal = con.prepareStatement(updateSql);
        psUpdateLocal.setInt(1, idEstablecimiento);
        int affectedRows = psUpdateLocal.executeUpdate();
        System.out.println("DEBUG DAO.incrementarFaltas: Filas afectadas por UPDATE para ID " + idEstablecimiento + ": " + affectedRows);

        if (affectedRows > 0) {
            psSelectAfterLocal = con.prepareStatement(selectAfterSql);
            psSelectAfterLocal.setInt(1, idEstablecimiento);
            rsAfterLocal = psSelectAfterLocal.executeQuery(); 
            if (rsAfterLocal.next()) {
                nuevoNumeroFaltas = rsAfterLocal.getInt("numero_faltas");
                System.out.println("DEBUG DAO.incrementarFaltas: Faltas DESPUÉS del update para ID " + idEstablecimiento + ": " + nuevoNumeroFaltas);
            } else {
                System.out.println("DEBUG DAO.incrementarFaltas: No se encontró establecimiento DESPUÉS del update para ID " + idEstablecimiento + " (¡esto sería raro!)");
                nuevoNumeroFaltas = -1;
            }
        } else {
             System.out.println("DEBUG DAO.incrementarFaltas: UPDATE no afectó filas para ID " + idEstablecimiento + ". Faltas ANTES era: " + faltasAntes);
             nuevoNumeroFaltas = faltasAntes;
        }
    } catch (SQLException e) {
         System.err.println("DEBUG DAO.incrementarFaltas: Error SQL para establecimiento ID " + idEstablecimiento + ": " + e.getMessage());
         e.printStackTrace(); 
         nuevoNumeroFaltas = -1;
    } finally {
        try { if (rsBeforeLocal != null) rsBeforeLocal.close(); } catch (SQLException e) { /* ignore */ }
        try { if (psSelectBeforeLocal != null) psSelectBeforeLocal.close(); } catch (SQLException e) { /* ignore */ }
        try { if (rsAfterLocal != null) rsAfterLocal.close(); } catch (SQLException e) { /* ignore */ }
        try { if (psSelectAfterLocal != null) psSelectAfterLocal.close(); } catch (SQLException e) { /* ignore */ }
        try { if (psUpdateLocal != null) psUpdateLocal.close(); } catch (SQLException e) { /* ignore */ }

    }
    System.out.println("DEBUG DAO.incrementarFaltas: Saliendo para idEstablecimiento: " + idEstablecimiento + ", nuevoNumeroFaltas: " + nuevoNumeroFaltas + " (Thread: " + Thread.currentThread().getId() + ")");
    return nuevoNumeroFaltas;
}
    
    public boolean resetFaltas(int idEstablecimiento) {
    String sql = "UPDATE establecimientos SET numero_faltas = 0 WHERE id_establecimiento = ?";
    try {
        con = cn.conectar();
        ps = con.prepareStatement(sql);
        ps.setInt(1, idEstablecimiento);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        System.err.println("Error al resetear faltas para establecimiento ID " + idEstablecimiento + ": " + e.getMessage());
        return false;
    } finally {
        cerrarRecursos();
    }
}
    
    public Map<java.sql.Date, Integer> contarEstablecimientosPorDiaEnPeriodo(java.util.Date fechaInicio, java.util.Date fechaFin) {
        Map<java.sql.Date, Integer> conteoPorDia = new LinkedHashMap<>();
        String sql = "SELECT DATE(fecha_registro) AS dia_registro, COUNT(*) AS cantidad " +
                     "FROM establecimientos " +
                     "WHERE DATE(fecha_registro) BETWEEN ? AND ? " +
                     "GROUP BY DATE(fecha_registro) " +
                     "ORDER BY dia_registro ASC";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(fechaInicio.getTime()));
            ps.setDate(2, new java.sql.Date(fechaFin.getTime()));
            
            rs = ps.executeQuery();
            while (rs.next()) {
                conteoPorDia.put(rs.getDate("dia_registro"), rs.getInt("cantidad"));
            }
        } catch (SQLException e) {
            System.err.println("Error al contar establecimientos por día en período: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return conteoPorDia;
    }

    public List<Establecimiento> listarEstablecimientosPorFechaRegistro(Date fechaInicio, Date fechaFin) {
        List<Establecimiento> lista = new ArrayList<>();
        String sql = "SELECT e.*, te.nombre_tipo, u.nombre_completo AS nombre_usuario_registrador " +
                     "FROM establecimientos e " +
                     "INNER JOIN tipos_establecimiento te ON e.id_tipo_establecimiento = te.id_tipo_establecimiento " +
                     "LEFT JOIN usuarios u ON e.id_usuario_registro = u.id_usuario " +
                     "WHERE DATE(e.fecha_registro) BETWEEN ? AND ? AND e.activo = TRUE " +
                     "ORDER BY e.fecha_registro ASC";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(fechaInicio.getTime()));
            ps.setDate(2, new java.sql.Date(fechaFin.getTime()));
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Establecimiento est = new Establecimiento();
                est.setIdEstablecimiento(rs.getInt("id_establecimiento"));
                est.setNombre(rs.getString("nombre"));
                est.setDireccion(rs.getString("direccion"));
                est.setIdTipoEstablecimiento(rs.getInt("id_tipo_establecimiento"));
                est.setContactoNombre(rs.getString("contacto_nombre"));
                est.setContactoTelefono(rs.getString("contacto_telefono"));
                est.setContactoEmail(rs.getString("contacto_email"));
                est.setEstado(rs.getString("estado"));
                est.setLatitud(rs.getBigDecimal("latitud"));
                est.setLongitud(rs.getBigDecimal("longitud"));
                est.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                est.setIdUsuarioRegistro(rs.getInt("id_usuario_registro"));
                est.setNombreTipoEstablecimiento(rs.getString("nombre_tipo"));
                est.setNombreUsuarioRegistro(rs.getString("nombre_usuario_registrador"));
                lista.add(est);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar establecimientos por fecha de registro: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return lista;
    }
    
@Override
public boolean softDelete(int idEstablecimiento, int idUsuarioModifico, String motivo) {
    String sqlUpdate = "UPDATE establecimientos SET activo = FALSE WHERE id_establecimiento = ? AND activo = TRUE";
    String sqlHistorial = "INSERT INTO historial_cambios_estado " +
                          "(id_establecimiento, id_usuario_modifico, estado_anterior, estado_nuevo, motivo_cambio) " +
                          "VALUES (?, ?, ?, ?, ?)"; 

    boolean exito = false;
    String estadoAnteriorObtenido = "Indeterminado"; 

    try (Connection connLocal = cn.conectar()) { 
        connLocal.setAutoCommit(false); 

        Establecimiento estActual = this.obtenerPorIdConConexion(idEstablecimiento, connLocal); 

        if (estActual != null && estActual.isActivo()) {
            estadoAnteriorObtenido = estActual.getEstado();
        } else {
            System.err.println("SoftDelete DAO: No se encontró el establecimiento activo con ID: " + idEstablecimiento + " o ya estaba inactivo. No se procede.");
            connLocal.rollback(); 
            return false; 
        }

        int filasActualizadas;
        try (PreparedStatement psUpdateEst = connLocal.prepareStatement(sqlUpdate)) { 
            psUpdateEst.setInt(1, idEstablecimiento);
            filasActualizadas = psUpdateEst.executeUpdate();
        }

        if (filasActualizadas > 0) {
            try (PreparedStatement psInsertHist = connLocal.prepareStatement(sqlHistorial)) { 
                psInsertHist.setInt(1, idEstablecimiento);
                psInsertHist.setInt(2, idUsuarioModifico);
                psInsertHist.setString(3, estadoAnteriorObtenido);
                psInsertHist.setString(4, "Eliminado Lógicamente"); 
                psInsertHist.setString(5, motivo);
                psInsertHist.executeUpdate();
            }

            connLocal.commit(); 
            exito = true;
            System.out.println("SoftDelete DAO: Establecimiento ID " + idEstablecimiento + " marcado como inactivo. Historial registrado.");
        } else {
            System.err.println("SoftDelete DAO: UPDATE no afectó filas para ID " + idEstablecimiento + ". Puede que el estado 'activo' haya cambiado concurrentemente o no existía activo.");
            connLocal.rollback(); 
        }

    } catch (SQLException e) {
        System.err.println("Error SQLException en softDelete DAO del establecimiento ID " + idEstablecimiento + ": " + e.getMessage());
        e.printStackTrace(); 
    } 
    return exito;
}
    
    private Establecimiento obtenerPorIdConConexion(int id, Connection conexionExistente) throws SQLException {
    Establecimiento est = null;
    String sql = "SELECT e.*, te.nombre_tipo, u.nombre_completo AS nombre_usuario_registrador " +
                 "FROM establecimientos e " +
                 "INNER JOIN tipos_establecimiento te ON e.id_tipo_establecimiento = te.id_tipo_establecimiento " +
                 "LEFT JOIN usuarios u ON e.id_usuario_registro = u.id_usuario " +
                 "WHERE e.id_establecimiento = ? AND e.activo = TRUE"; 

    try (PreparedStatement psLocal = conexionExistente.prepareStatement(sql)) {
        psLocal.setInt(1, id);
        try (ResultSet rsLocal = psLocal.executeQuery()) {
            if (rsLocal.next()) {
                est = new Establecimiento();
                est.setIdEstablecimiento(rsLocal.getInt("id_establecimiento"));
                est.setNombre(rsLocal.getString("nombre"));
                est.setDireccion(rsLocal.getString("direccion"));
                est.setIdTipoEstablecimiento(rsLocal.getInt("id_tipo_establecimiento"));
                est.setContactoNombre(rsLocal.getString("contacto_nombre"));
                est.setContactoTelefono(rsLocal.getString("contacto_telefono"));
                est.setContactoEmail(rsLocal.getString("contacto_email"));
                est.setEstado(rsLocal.getString("estado")); // Para el historial
                est.setLatitud(rsLocal.getBigDecimal("latitud"));
                est.setLongitud(rsLocal.getBigDecimal("longitud"));
                est.setFechaRegistro(rsLocal.getTimestamp("fecha_registro"));
                est.setIdUsuarioRegistro(rsLocal.getInt("id_usuario_registro"));
                est.setNumeroFaltas(rsLocal.getInt("numero_faltas"));
                est.setActivo(rsLocal.getBoolean("activo")); 
                est.setNombreTipoEstablecimiento(rsLocal.getString("nombre_tipo"));
                est.setNombreUsuarioRegistro(rsLocal.getString("nombre_usuario_registrador"));
            }
        }
    }
    return est;
}
    
    @Override
public boolean actualizar(Establecimiento establecimiento) {
    String sql = "UPDATE establecimientos SET nombre = ?, direccion = ?, id_tipo_establecimiento = ?, " +
                 "contacto_nombre = ?, contacto_telefono = ?, contacto_email = ?, " +
                 "latitud = ?, longitud = ? " + 
                 "WHERE id_establecimiento = ?";
    try {
        con = cn.conectar();
        ps = con.prepareStatement(sql);
        
        ps.setString(1, establecimiento.getNombre());
        ps.setString(2, establecimiento.getDireccion()); 
        ps.setInt(3, establecimiento.getIdTipoEstablecimiento());
        ps.setString(4, establecimiento.getContactoNombre());
        ps.setString(5, establecimiento.getContactoTelefono());
        ps.setString(6, establecimiento.getContactoEmail());
        
        if (establecimiento.getLatitud() != null) {
            ps.setBigDecimal(7, establecimiento.getLatitud());
        } else {
            ps.setNull(7, java.sql.Types.DECIMAL);
        }
        
        if (establecimiento.getLongitud() != null) {
            ps.setBigDecimal(8, establecimiento.getLongitud());
        } else {
            ps.setNull(8, java.sql.Types.DECIMAL);
        }
        
        ps.setInt(9, establecimiento.getIdEstablecimiento()); 

        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        System.err.println("Error al actualizar datos generales del establecimiento: " + e.getMessage());
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
            System.err.println("Error al cerrar recursos JDBC en EstablecimientoDAO: " + e.getMessage());
        }
    }
}
