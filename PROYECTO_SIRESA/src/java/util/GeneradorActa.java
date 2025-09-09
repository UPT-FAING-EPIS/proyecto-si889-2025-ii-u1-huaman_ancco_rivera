/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import modelo.Establecimiento;
import modelo.Inspeccion;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class GeneradorActa {

    public static String generarActaDeClausuraHTML(Inspeccion inspeccion, Establecimiento establecimiento) {
        
        Date fechaActual = new Date();
        String hora = new SimpleDateFormat("HH:mm").format(fechaActual);
        String dia = new SimpleDateFormat("dd").format(fechaActual);
        String mes = new SimpleDateFormat("MMMM", new Locale("es", "ES")).format(fechaActual);
        String anio = new SimpleDateFormat("yyyy").format(fechaActual);
        
        String numeroActa = String.format("%04d", inspeccion.getIdInspeccion());
        String nombreEstablecimiento = establecimiento.getNombre() != null ? establecimiento.getNombre().toUpperCase() : "NO ESPECIFICADO";
        String direccionEstablecimiento = establecimiento.getDireccion() != null ? establecimiento.getDireccion().toUpperCase() : "NO ESPECIFICADA";
        String nombreContacto = establecimiento.getContactoNombre() != null ? establecimiento.getContactoNombre().toUpperCase() : "...................................................";
        String dniContacto = "70669601";
        String condicionContacto = "ENCARGADO(A)";
        
        String motivo = inspeccion.getObservaciones() != null ? inspeccion.getObservaciones().toUpperCase() : "SIN OBSERVACIONES DETALLADAS EN LA ÚLTIMA INSPECCIÓN.";
        
        StringBuilder html = new StringBuilder();
        
        html.append("<!DOCTYPE html><html lang='es'><head><meta charset='UTF-8'><title>Acta de Operativo N° ").append(numeroActa).append("</title>");
        html.append("<style>");
        html.append("body { background-color: #f0f0f0; font-family: 'Times New Roman', Times, serif; font-size: 12pt; line-height: 1.6; }");
        html.append(".page-container { width: 21cm; min-height: 29.7cm; padding: 2cm; margin: 1cm auto; border: 1px solid #D1D1D1; background: white; box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); }");
        html.append(".header-table { width: 100%; border-collapse: collapse; margin-bottom: 25px; }");
        html.append(".header-table td { vertical-align: middle; text-align: center; }");
        html.append(".logo { width: 90px; height: auto; }");
        html.append(".header-title { font-weight: bold; font-size: 13pt; }");
        html.append(".acta-title { text-align: center; font-weight: bold; font-size: 16pt; margin: 30px 0; text-decoration: underline; }");
        html.append(".section { margin-top: 25px; text-align: justify; }");
        html.append(".motivo-section { margin-top: 20px; }");
        html.append(".motivo-box { border: 1px solid #000; padding: 15px; margin-top: 10px; min-height: 100px; background-color: #fafafa; }");
        html.append(".firmas-container { display: flex; justify-content: space-around; margin-top: 100px; text-align: center; }");
        html.append(".firma-block { width: 45%; }");
        html.append(".firma-line { border-top: 1px solid #000; margin: 0 20px; }");
        html.append(".print-button-container { text-align: center; margin: 20px; }");
        html.append("@media print { .no-print { display: none !important; } .page-container { margin: 0; border: none; box-shadow: none; } }");
        html.append("</style></head><body>");

        html.append("<div class='page-container'>");

        html.append("<table class='header-table'><tr>");
        html.append("<td><img src='https://i.imgur.com/slzpdWh.jpeg' alt='Logo MPT' class='logo'></td>");
        html.append("<td class='header-title'>");
        html.append("MUNICIPALIDAD PROVINCIAL DE TACNA<br>");
        html.append("GERENCIA DE DESARROLLO ECONÓMICO SOCIAL<br>");
        html.append("UNIDAD DE GESTIÓN DE SALUD PÚBLICA");
        html.append("</td>");
        html.append("<td><img src='https://i.imgur.com/xmvtPSc.jpeg' alt='Logo Tacna' class='logo'></td>");
        html.append("</tr></table>");

        html.append("<div class='acta-title'>ACTA DE OPERATIVO Nº ").append(numeroActa).append("-").append(anio).append("-UGSP-SGDS-PV-GDES/MPT</div>");
        
        html.append("<div class='section'>");
        html.append("En la ciudad de Tacna, siendo las <strong>").append(hora).append("</strong> horas, del día <strong>").append(dia).append("</strong> del mes de <strong>").append(mes).append("</strong> del <strong>").append(anio).append("</strong>, ");
        html.append("el personal de la Unidad de Gestión de Salud Pública se constituyó en el establecimiento comercial denominado: <strong>").append(nombreEstablecimiento).append("</strong>, ");
        html.append("ubicado en: <strong>").append(direccionEstablecimiento).append("</strong>, donde se entrevistó al(la) Sr(a).: ");
        html.append("<strong>").append(nombreContacto).append("</strong>, identificado(a) con DNI N°: <strong>").append(dniContacto).append("</strong>, ");
        html.append("quien manifestó ser <strong>").append(condicionContacto).append("</strong> del establecimiento. El operativo contó con la presencia del siguiente personal:");
        html.append("</div>");

        html.append("<div class='section'>");
        html.append("Ministerio Público ( )&nbsp;&nbsp;&nbsp;&nbsp;Policía Nacional del Perú ( )<br>");
        html.append("Dirección Ejecutiva de Salud Ambiental (DIRESA) ( )&nbsp;&nbsp;&nbsp;&nbsp;Sub Gerencia de Fiscalización y Control (X)<br>");
        html.append("Unidad de Gestión de Salud Pública (X)&nbsp;&nbsp;&nbsp;&nbsp;Seguridad Ciudadana ( )");
        html.append("</div>");
        
        html.append("<div class='section'>");
        html.append("Con la finalidad de verificar el cumplimiento de las normas de salubridad y seguridad vigentes, en el marco de la Ley Orgánica de Municipalidades Nº 27972 y la Ley de Procedimiento Administrativo General Nº 27444, se procedió a la inspección, encontrándose las siguientes observaciones:");
        html.append("</div>");

        html.append("<div class='motivo-section'><strong>MOTIVO DE LA SANCIÓN:</strong></div>");
        html.append("<div class='motivo-box'>").append(motivo).append("</div>");
        
        html.append("<div class='section'>");
        html.append("En cumplimiento al Art. 156 de la Ley Nº 27444, se da por culminado el presente operativo, levantando el acta para los fines correspondientes, siendo las <strong>").append(hora).append("</strong> horas de la fecha.");
        html.append("</div>");
        html.append("<div class='section'>En señal de conformidad, proceden a firmar los intervinientes:</div>");
        
        html.append("<div class='firmas-container'>");
        html.append("<div class='firma-block'><p class='firma-line'></p><p>Inspector Sanitario MPT</p></div>");
        html.append("<div class='firma-block'><p class='firma-line'></p><p>Propietario y/o Encargado</p><p>DNI: ....................................</p></div>");
        html.append("</div>");

        html.append("</div></body></html>");
        
        return html.toString();
    }
}