/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import interfaces.CRUDTipoEstablecimiento;
import modelo.TipoEstablecimiento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TipoEstablecimientoDAO implements CRUDTipoEstablecimiento {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public List<TipoEstablecimiento> listarTodos() {
        List<TipoEstablecimiento> listaTipos = new ArrayList<>();
        String sql = "SELECT * FROM tipos_establecimiento ORDER BY nombre_tipo ASC";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                TipoEstablecimiento tipo = new TipoEstablecimiento();
                tipo.setIdTipoEstablecimiento(rs.getInt("id_tipo_establecimiento"));
                tipo.setNombreTipo(rs.getString("nombre_tipo"));
                tipo.setDescripcion(rs.getString("descripcion"));
                listaTipos.add(tipo);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar tipos de establecimiento: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return listaTipos;
    }

    @Override
    public TipoEstablecimiento obtenerPorId(int id) {
        TipoEstablecimiento tipo = null;
        String sql = "SELECT * FROM tipos_establecimiento WHERE id_tipo_establecimiento = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                tipo = new TipoEstablecimiento();
                tipo.setIdTipoEstablecimiento(rs.getInt("id_tipo_establecimiento"));
                tipo.setNombreTipo(rs.getString("nombre_tipo"));
                tipo.setDescripcion(rs.getString("descripcion"));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener tipo de establecimiento por ID: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return tipo;
    }

    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos JDBC en TipoEstablecimientoDAO: " + e.getMessage());
        }
    }
}