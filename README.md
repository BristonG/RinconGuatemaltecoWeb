# Rincón Guatemalteco Web — Sistema de Gestión Comercial y POS

Aplicación web empresarial desarrollada en Java SE bajo una arquitectura en capas y gestionada con Apache Tomcat. El sistema digitaliza y centraliza el flujo operativo de un negocio comercial: desde el control de inventarios y compras a proveedores hasta la facturación, despachos, devoluciones y generación de reportes.

---

## Características principales

* **Control de acceso:** Inicio de sesión y gestión de sesiones de usuario.
* **Gestión de catálogos:** Administración CRUD de clientes, proveedores y catálogo de productos.
* **Operaciones comerciales:**
  * Registro de compras y abastecimiento.
  * Emisión de facturas y consulta de detalle por transacción.
  * Control logístico de despachos y gestión de devoluciones.
* **Reportería:** Visualización de reportes operativos para toma de decisiones.

---

## Arquitectura y tecnologías

El proyecto sigue una separación clara de responsabilidades para facilitar su mantenimiento y escalabilidad:

* **Backend:** Java SE / Jakarta EE
* **Arquitectura:** Controladores, Acceso a Datos, Entidades y Gestión de Conexión
* **Base de datos:** Microsoft SQL Server

---

## Estructura del repositorio

```text
├── BD.sql                  # Script de creación de base de datos y tablas
├── pom.xml                 # Dependencias y configuración de compilación Maven
└── src/
    └── main/
        ├── java/com/proyectobd/rinconguatemaltecoweb/
        │   ├── conexion/   # Configuración de conexión JDBC a SQL Server
        │   ├── controlador/# Servlets para manejo de peticiones HTTP
        │   ├── dao/        # Consultas SQL y operaciones de persistencia
        │   └── modelo/     # Clases de dominio
        ├── resources/      # Ubicación para el archivo de configuración db.properties
        └── webapp/
            ├── css/        # Estilos visuales (custom-dark.css)
            ├── WEB-INF/    # Descriptor de despliegue (web.xml)
            └── *.jsp       # Vistas de la interfaz de usuario