/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

public class TipoEstablecimiento {
    private int idTipoEstablecimiento;
    private String nombreTipo;
    private String descripcion;

    public TipoEstablecimiento() {
    }

    public TipoEstablecimiento(int idTipoEstablecimiento, String nombreTipo, String descripcion) {
        this.idTipoEstablecimiento = idTipoEstablecimiento;
        this.nombreTipo = nombreTipo;
        this.descripcion = descripcion;
    }

    public int getIdTipoEstablecimiento() {
        return idTipoEstablecimiento;
    }

    public void setIdTipoEstablecimiento(int idTipoEstablecimiento) {
        this.idTipoEstablecimiento = idTipoEstablecimiento;
    }

    public String getNombreTipo() {
        return nombreTipo;
    }

    public void setNombreTipo(String nombreTipo) {
        this.nombreTipo = nombreTipo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    @Override
    public String toString() {
        return "TipoEstablecimiento{" + "idTipoEstablecimiento=" + idTipoEstablecimiento + ", nombreTipo=" + nombreTipo + '}';
    }
}