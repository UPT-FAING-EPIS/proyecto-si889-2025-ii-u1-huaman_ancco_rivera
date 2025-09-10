/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package interfaces;

import modelo.Establecimiento;
import java.util.List;
import java.util.Map;

public interface CRUDEstablecimiento {

    public boolean agregar(Establecimiento establecimiento);

    public List<Establecimiento> listarTodos();

    public Establecimiento obtenerPorId(int id);
    
    public boolean softDelete(int idEstablecimiento, int idUsuarioModifico, String motivo);

    public boolean actualizarEstado(int idEstablecimiento, String nuevoEstado, int idUsuarioModifico, String motivo);

    public boolean actualizar(Establecimiento establecimiento);

    public List<Establecimiento> listarFiltrado(Map<String, Object> filtros);
}
