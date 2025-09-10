/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {

    private static final String CORREO_REMITENTE = "rh2021071077@virtual.upt.pe";
    private static final String CONTRASENA_REMITENTE = "tkhw sdyu jiqb cvnb"; 

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587"; 

    public static boolean enviarCorreo(String destinatario, String asunto, String cuerpoHTML) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(CORREO_REMITENTE, CONTRASENA_REMITENTE);
            }
        });
        

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(CORREO_REMITENTE));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            message.setSubject(asunto);
            
            message.setContent(cuerpoHTML, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Correo enviado exitosamente a: " + destinatario + " con asunto: " + asunto);
            return true;

        } catch (MessagingException e) {
            System.err.println("Error al enviar correo a " + destinatario + ": " + e.getMessage());
            e.printStackTrace(); 
            return false;
        }
    }

    public static void main(String[] args) {
        String destinatarioPrueba = "rh2021071077@virtual.upt.pe"; 
        String asuntoPrueba = "Prueba de envío de correo SIRESA";
        String cuerpoPruebaHTML = "<h1>¡Hola desde SIRESA!</h1><p>Este es un correo de prueba enviado usando JavaMail.</p><p>Saludos.</p>";

        if (enviarCorreo(destinatarioPrueba, asuntoPrueba, cuerpoPruebaHTML)) {
            System.out.println("Prueba de correo enviada.");
        } else {
            System.out.println("Fallo al enviar correo de prueba.");
        }
    }
}
