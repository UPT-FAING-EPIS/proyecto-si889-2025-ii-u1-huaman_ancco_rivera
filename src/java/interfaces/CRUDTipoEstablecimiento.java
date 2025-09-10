/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package interfaces;

import modelo.TipoEstablecimiento;
import java.util.List;

public interface CRUDTipoEstablecimiento {

    public List<TipoEstablecimiento> listarTodos();

    public TipoEstablecimiento obtenerPorId(int id);

}