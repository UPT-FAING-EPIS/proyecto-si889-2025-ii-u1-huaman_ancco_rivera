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

public class GeneradorNotificaciones {


    public static String generarAdvertenciaHTML(Inspeccion inspeccion, Establecimiento establecimiento, int nuevoNumeroFaltas, String linkDetalles) {
        
        Date fechaInspeccion = inspeccion.getFechaInspeccion();
        String fechaInspeccionStr = new SimpleDateFormat("dd 'de' MMMM 'de' yyyy", new Locale("es", "ES")).format(fechaInspeccion);
        String refId = String.format("ADV-%s-%04d", new SimpleDateFormat("yyyy").format(fechaInspeccion), inspeccion.getIdInspeccion());
        
        String nombreEstablecimiento = establecimiento.getNombre() != null ? establecimiento.getNombre() : "No Especificado";
        String direccionEstablecimiento = establecimiento.getDireccion() != null ? establecimiento.getDireccion() : "No Especificada";
        String nombreContacto = establecimiento.getContactoNombre() != null ? establecimiento.getContactoNombre() : "Responsable del Establecimiento";
        String observaciones = inspeccion.getObservaciones() != null && !inspeccion.getObservaciones().isEmpty() ? inspeccion.getObservaciones() : "No se detallaron observaciones específicas.";

        
        String html = "<!DOCTYPE html>"
            + "<html lang='es'>"
            + "<head><meta charset='UTF-8'><title>Notificación de Advertencia Sanitaria</title></head>"
            + "<body style='margin: 0; padding: 0; background-color: #f4f4f4; font-family: Arial, sans-serif;'>"
            + "  <table role='presentation' border='0' cellpadding='0' cellspacing='0' width='100%'>"
            + "    <tr>"
            + "      <td style='padding: 20px 0;'>"
            + "        <table align='center' border='0' cellpadding='0' cellspacing='0' width='600' style='border-collapse: collapse; border: 1px solid #cccccc; background-color: #ffffff;'>"
            + "          <!-- ENCABEZADO CON LOGOS -->"
            + "          <tr>"
            + "            <td align='center' style='padding: 20px 20px 10px 20px;'>"
            + "              <table border='0' cellpadding='0' cellspacing='0' width='100%'>"
            + "                <tr>"
            + "                  <td width='100' align='left'><img src='https://i.imgur.com/xmvtPSc.jpeg' alt='Logo Gobierno Regional de Tacna' width='80' style='display: block;' /></td>"
            + "                  <td align='center' style='color: #555555; font-size: 14px;'>"
            + "                    <strong style='font-size: 16px;'>GOBIERNO REGIONAL DE TACNA</strong><br/>"
            + "                    <span style='font-size: 12px;'>\"La que mira de frente al mañana\"</span>"
            + "                  </td>"
            + "                  <td width='100' align='right'><img src='https://i.imgur.com/slzpdWh.jpeg' alt='Logo Municipalidad Provincial de Tacna' width='80' style='display: block;' /></td>"
            + "                </tr>"
            + "              </table>"
            + "            </td>"
            + "          </tr>"
            + "          <!-- BARRA DE TÍTULO -->"
            + "          <tr>"
            + "            <td bgcolor='#c0392b' style='padding: 15px 20px; color: #ffffff; font-size: 20px; font-weight: bold; text-align: center;'>"
            + "              NOTIFICACIÓN DE ADVERTENCIA SANITARIA"
            + "            </td>"
            + "          </tr>"
            + "          <!-- CUERPO DEL CORREO -->"
            + "          <tr>"
            + "            <td style='padding: 30px 30px 40px 30px; color: #333333; font-size: 16px; line-height: 1.6;'>"
            + "              <p style='margin: 0 0 15px 0;'><strong>Fecha:</strong> " + fechaInspeccionStr + "</p>"
            + "              <p style='margin: 0 0 25px 0;'><strong>Referencia:</strong> " + refId + "</p>"
            + "              <p style='margin: 0 0 15px 0;'>Estimado(a) <strong>" + nombreContacto + "</strong>,</p>"
            + "              <p style='margin: 0 0 15px 0;'>Por medio de la presente, se notifica que el establecimiento <strong>" + nombreEstablecimiento + "</strong>, ubicado en " + direccionEstablecimiento + ", ha sido objeto de una inspección sanitaria con resultado <strong>DESFAVORABLE</strong>.</p>"
            + "              <div style='border-left: 4px solid #c0392b; padding: 15px; background-color: #f9f9f9; margin: 20px 0;'>"
            + "                <p style='margin: 0 0 10px 0;'><strong>Observaciones Críticas Encontradas:</strong></p>"
            + "                <p style='margin: 0; font-style: italic;'>\"" + observaciones + "\"</p>"
            + "              </div>"
            + "              <p style='margin: 20px 0;'>Esta notificación constituye su <strong>FALTA N° " + nuevoNumeroFaltas + " de 3</strong>. Se le exhorta a subsanar las observaciones detalladas a la brevedad posible para evitar la aplicación de sanciones más severas, incluyendo la clausura del establecimiento.</p>"
            + "              <table align='center' border='0' cellpadding='0' cellspacing='0' width='100%'>"
            + "                <tr><td align='center' style='padding: 20px 0;'><a href='" + linkDetalles + "' style='background-color: #007bff; color: #ffffff; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold;'>Ver Detalles en el Sistema SIRESA</a></td></tr>"
            + "              </table>"
            + "              <p style='margin-top: 30px; margin-bottom: 0;'>Atentamente,</p>"
            + "              <p style='margin-top: 5px; margin-bottom: 0; font-weight: bold;'>Unidad de Gestión de Salud Pública</p>"
            + "              <p style='margin-top: 0; margin-bottom: 0;'>Gerencia de Desarrollo Económico Social</p>"
            + "            </td>"
            + "          </tr>"
            + "          <!-- PIE DE PÁGINA -->"
            + "          <tr>"
            + "            <td bgcolor='#ffc107' style='padding: 5px;'></td>"
            + "          </tr>"
            + "          <tr>"
            + "            <td bgcolor='#f4f4f4' style='padding: 20px 30px; text-align: center; color: #888888; font-size: 12px;'>"
            + "              Municipalidad Provincial de Tacna<br/>"
            + "              Este es un correo generado automáticamente. Por favor, no responda a este mensaje."
            + "            </td>"
            + "          </tr>"
            + "        </table>"
            + "      </td>"
            + "    </tr>"
            + "  </table>"
            + "</body></html>";
            
        return html;
    }
}