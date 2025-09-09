/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package config; 

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    Connection con;
    String url; 
    String user;
    String pass;

    public Connection conectar() {
        try {
            String instanceConnectionName = System.getenv("INSTANCE_CONNECTION_NAME");
            String dbName = System.getenv("DB_NAME");
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASS");
            String dbHost = System.getenv("DB_HOST"); 

            if (dbName == null || dbUser == null || dbPass == null) {
                System.err.println("ERROR_DB_CONFIG: Faltan variables de entorno críticas para la BD (DB_NAME, DB_USER, DB_PASS).");
                return null;
            }

            if (instanceConnectionName != null && !instanceConnectionName.isEmpty()) {

                url = String.format("jdbc:mysql://google/%s?cloudSqlInstance=%s&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
                                    dbName, instanceConnectionName);
                System.out.println("GAE Conectando vía Cloud SQL Socket Factory a: " + dbName);
            } 

            else if (dbHost != null && !dbHost.isEmpty()) {
                String dbPort = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306";
                url = String.format("jdbc:mysql://%s:%s/%s?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
                                    dbHost, dbPort, dbName);
                System.out.println("GAE Conectando vía IP Pública a: " + dbHost);
            } else {
                System.err.println("ERROR_DB_CONFIG: No se proporcionó INSTANCE_CONNECTION_NAME (para Socket Factory) ni DB_HOST (para IP pública).");
                return null;
            }

            this.user = dbUser;
            this.pass = dbPass;

            con = DriverManager.getConnection(this.url, this.user, this.pass);
            System.out.println("Conexión a BD en Google Cloud exitosa!");

        } catch (SQLException e) {
            System.err.println("Error SQL al conectar con la BD en Google Cloud: " + e.getMessage());
            e.printStackTrace();
        } 
        return con;
    }

}