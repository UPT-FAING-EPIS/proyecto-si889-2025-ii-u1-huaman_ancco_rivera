/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Establecimiento {
    private int idEstablecimiento;
    private String nombre;
    private String direccion;
    private int idTipoEstablecimiento;
    private String contactoNombre;
    private String contactoTelefono;
    private String contactoEmail;
    private String estado;
    private BigDecimal latitud;
    private BigDecimal longitud;
    private Timestamp fechaRegistro;
    private int idUsuarioRegistro;

    private int numeroFaltas;
    private String nombreTipoEstablecimiento;
    private String nombreUsuarioRegistro;
    
    private boolean activo;
    
    public Establecimiento() {
    }

    public Establecimiento(int idEstablecimiento, String nombre, String direccion, int idTipoEstablecimiento,
                           String contactoNombre, String contactoTelefono, String contactoEmail,
                           String estado, BigDecimal latitud, BigDecimal longitud,
                           Timestamp fechaRegistro, int idUsuarioRegistro, int numeroFaltas, boolean activo) {
        this.idEstablecimiento = idEstablecimiento;
        this.nombre = nombre;
        this.direccion = direccion;
        this.idTipoEstablecimiento = idTipoEstablecimiento;
        this.contactoNombre = contactoNombre;
        this.contactoTelefono = contactoTelefono;
        this.contactoEmail = contactoEmail;
        this.estado = estado;
        this.latitud = latitud;
        this.longitud = longitud;
        this.fechaRegistro = fechaRegistro;
        this.idUsuarioRegistro = idUsuarioRegistro;
        this.numeroFaltas = numeroFaltas;
        this.activo = activo;
    }

    public int getIdEstablecimiento() {
        return idEstablecimiento;
    }

    public void setIdEstablecimiento(int idEstablecimiento) {
        this.idEstablecimiento = idEstablecimiento;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public int getIdTipoEstablecimiento() {
        return idTipoEstablecimiento;
    }

    public void setIdTipoEstablecimiento(int idTipoEstablecimiento) {
        this.idTipoEstablecimiento = idTipoEstablecimiento;
    }

    public String getContactoNombre() {
        return contactoNombre;
    }

    public void setContactoNombre(String contactoNombre) {
        this.contactoNombre = contactoNombre;
    }

    public String getContactoTelefono() {
        return contactoTelefono;
    }

    public void setContactoTelefono(String contactoTelefono) {
        this.contactoTelefono = contactoTelefono;
    }

    public String getContactoEmail() {
        return contactoEmail;
    }

    public void setContactoEmail(String contactoEmail) {
        this.contactoEmail = contactoEmail;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public BigDecimal getLatitud() {
        return latitud;
    }

    public void setLatitud(BigDecimal latitud) {
        this.latitud = latitud;
    }

    public BigDecimal getLongitud() {
        return longitud;
    }

    public void setLongitud(BigDecimal longitud) {
        this.longitud = longitud;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public int getIdUsuarioRegistro() {
        return idUsuarioRegistro;
    }

    public void setIdUsuarioRegistro(int idUsuarioRegistro) {
        this.idUsuarioRegistro = idUsuarioRegistro;
    }
    
    public boolean isActivo() {
    return activo;
}

public void setActivo(boolean activo) {
    this.activo = activo;
}
    
    public int getNumeroFaltas() {
    return numeroFaltas;
    }

    public void setNumeroFaltas(int numeroFaltas) {
        this.numeroFaltas = numeroFaltas;
    }

    public String getNombreTipoEstablecimiento() {
        return nombreTipoEstablecimiento;
    }

    public void setNombreTipoEstablecimiento(String nombreTipoEstablecimiento) {
        this.nombreTipoEstablecimiento = nombreTipoEstablecimiento;
    }

    public String getNombreUsuarioRegistro() {
        return nombreUsuarioRegistro;
    }

    public void setNombreUsuarioRegistro(String nombreUsuarioRegistro) {
        this.nombreUsuarioRegistro = nombreUsuarioRegistro;
    }
    

    @Override
    public String toString() {
        return "Establecimiento{" + "idEstablecimiento=" + idEstablecimiento + ", nombre=" + nombre + ", estado=" + estado + '}';
    }
}