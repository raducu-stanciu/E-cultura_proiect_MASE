package com.ecultura.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            // Încărcăm driverul din folderul lib
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Conectarea la baza de date
            // ATENȚIE: Schimbă 'admin123' cu parola setată de tine în MySQL Installer
            con = DriverManager.getConnection(
                "jdbc:mysql://centerbeam.proxy.rlwy.net:13424/railway?useSSL=false&allowPublicKeyRetrieval=true", "root", "cwmkEiuWVmfThVdfkWOfpGfhwheYdPtZ");
            
            System.out.println("Conexiune reușită la baza de date!");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Eroare la conexiune: " + e.getMessage());
        }
        return con;
    }
}