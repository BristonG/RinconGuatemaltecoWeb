package com.proyectobd.rinconguatemaltecoweb.conexion;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConexionBD {

    private static final Properties propiedades = new Properties();

    static {
        try (InputStream input = ConexionBD.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new RuntimeException("No se encontró el archivo db.properties.");
            }
            propiedades.load(input);
            Class.forName(propiedades.getProperty("db.driver"));
        } catch (IOException e) {
            throw new RuntimeException("Error al leer db.properties", e);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver no encontrado: " + propiedades.getProperty("db.driver"), e);
        }
    }

    public static Connection obtenerConexion() throws SQLException {
        String url = propiedades.getProperty("db.url");
        String usuario = propiedades.getProperty("db.usuario");
        String clave = propiedades.getProperty("db.clave");

        if (usuario != null && !usuario.trim().isEmpty()) {
            return DriverManager.getConnection(url, usuario, clave != null ? clave : "");
        } else {
            return DriverManager.getConnection(url);
        }
    }
}