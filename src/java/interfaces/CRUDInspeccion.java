/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package interfaces;

import modelo.Inspeccion;
import java.util.List;

public interface CRUDInspeccion {

    public boolean agregar(Inspeccion inspeccion);

    public List<Inspeccion> listarPorEstablecimiento(int idEstablecimiento);

    public List<Inspeccion> listarPorInspector(int idInspector);

    public Inspeccion obtenerPorId(int idInspeccion);

}
