/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.Timestamp; 
import java.util.Date; 

public class Inspeccion {
    private int idInspeccion;
    private int idEstablecimiento;
    private int idInspector; 
    private Date fechaInspeccion;
    private String observaciones;
    private String resultado; 
    private Timestamp fechaRegistroSistema; 

    private String nombreEstablecimiento;
    private String nombreInspector;

    public Inspeccion() {
    }

    public Inspeccion(int idInspeccion, int idEstablecimiento, int idInspector, Date fechaInspeccion, String observaciones, String resultado, Timestamp fechaRegistroSistema) {
        this.idInspeccion = idInspeccion;
        this.idEstablecimiento = idEstablecimiento;
        this.idInspector = idInspector;
        this.fechaInspeccion = fechaInspeccion;
        this.observaciones = observaciones;
        this.resultado = resultado;
        this.fechaRegistroSistema = fechaRegistroSistema;
    }

    public int getIdInspeccion() {
        return idInspeccion;
    }

    public void setIdInspeccion(int idInspeccion) {
        this.idInspeccion = idInspeccion;
    }

    public int getIdEstablecimiento() {
        return idEstablecimiento;
    }

    public void setIdEstablecimiento(int idEstablecimiento) {
        this.idEstablecimiento = idEstablecimiento;
    }

    public int getIdInspector() {
        return idInspector;
    }

    public void setIdInspector(int idInspector) {
        this.idInspector = idInspector;
    }

    public Date getFechaInspeccion() {
        return fechaInspeccion;
    }

    public void setFechaInspeccion(Date fechaInspeccion) {
        this.fechaInspeccion = fechaInspeccion;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public String getResultado() {
        return resultado;
    }

    public void setResultado(String resultado) {
        this.resultado = resultado;
    }

    public Timestamp getFechaRegistroSistema() {
        return fechaRegistroSistema;
    }

    public void setFechaRegistroSistema(Timestamp fechaRegistroSistema) {
        this.fechaRegistroSistema = fechaRegistroSistema;
    }

    public String getNombreEstablecimiento() {
        return nombreEstablecimiento;
    }

    public void setNombreEstablecimiento(String nombreEstablecimiento) {
        this.nombreEstablecimiento = nombreEstablecimiento;
    }

    public String getNombreInspector() {
        return nombreInspector;
    }

    public void setNombreInspector(String nombreInspector) {
        this.nombreInspector = nombreInspector;
    }

    @Override
    public String toString() {
        return "Inspeccion{" + "idInspeccion=" + idInspeccion + ", idEstablecimiento=" + idEstablecimiento + ", resultado=" + resultado + '}';
    }
}
