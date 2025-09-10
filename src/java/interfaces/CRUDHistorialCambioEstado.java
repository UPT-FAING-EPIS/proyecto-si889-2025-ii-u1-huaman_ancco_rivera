/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package interfaces;

import modelo.HistorialCambioEstado;
import java.util.List;

public interface CRUDHistorialCambioEstado {

    public List<HistorialCambioEstado> obtenerHistorialPorEstablecimiento(int idEstablecimiento);

    public List<HistorialCambioEstado> listarCambiosRecientes(int limite);
}
