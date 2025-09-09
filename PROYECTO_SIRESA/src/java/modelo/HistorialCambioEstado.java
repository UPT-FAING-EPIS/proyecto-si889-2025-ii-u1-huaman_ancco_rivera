/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.Timestamp;

public class HistorialCambioEstado {
    private int idHistorial;
    private int idEstablecimiento;
    private int idUsuarioModifico;
    private Timestamp fechaCambio;
    private String estadoAnterior;
    private String estadoNuevo;
    private String motivoCambio;

    private String nombreUsuarioModifico;
    private String nombreEstablecimiento; 

    public HistorialCambioEstado() {
    }

    public HistorialCambioEstado(int idHistorial, int idEstablecimiento, int idUsuarioModifico, Timestamp fechaCambio, String estadoAnterior, String estadoNuevo, String motivoCambio) {
        this.idHistorial = idHistorial;
        this.idEstablecimiento = idEstablecimiento;
        this.idUsuarioModifico = idUsuarioModifico;
        this.fechaCambio = fechaCambio;
        this.estadoAnterior = estadoAnterior;
        this.estadoNuevo = estadoNuevo;
        this.motivoCambio = motivoCambio;
    }

    public int getIdHistorial() {
        return idHistorial;
    }

    public void setIdHistorial(int idHistorial) {
        this.idHistorial = idHistorial;
    }

    public int getIdEstablecimiento() {
        return idEstablecimiento;
    }

    public void setIdEstablecimiento(int idEstablecimiento) {
        this.idEstablecimiento = idEstablecimiento;
    }

    public int getIdUsuarioModifico() {
        return idUsuarioModifico;
    }

    public void setIdUsuarioModifico(int idUsuarioModifico) {
        this.idUsuarioModifico = idUsuarioModifico;
    }

    public Timestamp getFechaCambio() {
        return fechaCambio;
    }

    public void setFechaCambio(Timestamp fechaCambio) {
        this.fechaCambio = fechaCambio;
    }

    public String getEstadoAnterior() {
        return estadoAnterior;
    }

    public void setEstadoAnterior(String estadoAnterior) {
        this.estadoAnterior = estadoAnterior;
    }

    public String getEstadoNuevo() {
        return estadoNuevo;
    }

    public void setEstadoNuevo(String estadoNuevo) {
        this.estadoNuevo = estadoNuevo;
    }

    public String getMotivoCambio() {
        return motivoCambio;
    }

    public void setMotivoCambio(String motivoCambio) {
        this.motivoCambio = motivoCambio;
    }

    public String getNombreUsuarioModifico() {
        return nombreUsuarioModifico;
    }

    public void setNombreUsuarioModifico(String nombreUsuarioModifico) {
        this.nombreUsuarioModifico = nombreUsuarioModifico;
    }

    public String getNombreEstablecimiento() {
        return nombreEstablecimiento;
    }

    public void setNombreEstablecimiento(String nombreEstablecimiento) {
        this.nombreEstablecimiento = nombreEstablecimiento;
    }

    @Override
    public String toString() {
        return "HistorialCambioEstado{" + "idHistorial=" + idHistorial + ", idEstablecimiento=" + idEstablecimiento + ", fechaCambio=" + fechaCambio + ", estadoNuevo=" + estadoNuevo + '}';
    }
}