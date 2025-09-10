# SIRESA - Sistema de Inspección y Registro de Establecimientos de Salud y Alimentación

## Descripción

SIRESA es una aplicación web para la gestión, inspección y auditoría de establecimientos de comida y bebidas. Permite a administradores, inspectores y ciudadanos consultar información, realizar inspecciones, visualizar mapas y generar reportes detallados sobre el estado y cambios de los establecimientos.

## Equipo de desarrollo:
   - Bruno Ancco Suaña
   - Roberto Huaman Rivera
   - Augusto Rivera Muñoz
 
## Estructura del Proyecto

```
PROYECTO_SIRESA/
├── build.xml                  # Script de construcción (Ant)
├── build/                     # Archivos generados
├── nbproject/                 # Configuración NetBeans
├── src/
│   ├── java/
│   │   ├── controlador/       # Servlets principales (ControladorEstablecimiento, ControladorReporte, ControladorInspeccion, ControladorAuditoria)
│   │   ├── modelo/            # Entidades (Establecimiento, Inspeccion, Usuario, HistorialCambioEstado, etc.)
│   │   ├── modeloDAO/         # DAOs para acceso a datos
│   │   ├── interfaces/        # Interfaces CRUD
│   │   └── util/              # Utilidades (GeneradorActa, GeneradorNotificaciones, EmailService)
│   └── ...
├── web/
│   ├── index.html             # Página de inicio (placeholder)
│   ├── *.jsp                  # Vistas JSP (dashboard, reportes, formularios, mapas, historial, etc.)
│   └── media/                 # Recursos estáticos (imágenes)
├── docs/                      # Documentación técnica y funcional
├── docs_md/                   # Documentación en Markdown
├── README.md                  # Este archivo
```

## Principales Funcionalidades

- **Gestión de Establecimientos:** Registro, edición, consulta y eliminación lógica.
- **Inspecciones:** Registro y seguimiento de inspecciones, generación de actas y notificaciones.
- **Reportes:** Gráficos y tablas por estado, periodo y resultados de inspección.
- **Historial de Cambios:** Auditoría de cambios de estado por establecimiento y global.
- **Mapa Interactivo:** Visualización geográfica de establecimientos según estado.
- **Roles de Usuario:** Administrador, Inspector y Ciudadano, con permisos diferenciados.

## Roadmap

### Fase 1: MVP y Estabilización
- CRUD de establecimientos y usuarios
- Registro y consulta de inspecciones
- Visualización de estado y historial de cambios
- Reportes básicos y gráficos

### Fase 2: Mejoras de Usabilidad y Seguridad
- Validaciones avanzadas en formularios
- Mejorar feedback de errores y mensajes al usuario
- Implementar control de sesiones y expiración segura
- Auditar y reforzar roles y permisos

### Fase 3: Integraciones y Automatización
- Integrar notificaciones por correo electrónico
- Exportar reportes a PDF/Excel
- API REST para consulta externa
- Automatización de backups y logs

### Fase 4: Escalabilidad y Nuevas Funcionalidades
- Soporte para múltiples municipios/regiones
- Dashboard analítico avanzado
- Integración con sistemas externos (RENIEC, SUNAT, etc.)
- Mobile-friendly y PWA


## Instalación y Ejecución

1. **Requisitos:**
   - Java 8+
   - Servidor de aplicaciones compatible con Jakarta EE (Tomcat, GlassFish)
   - Base de datos configurada (ver documentación en `docs/`)
   - NetBeans (opcional, para desarrollo)

2. **Compilación:**
   - Ejecuta `ant build` o usa NetBeans para compilar el proyecto.

3. **Despliegue:**
   - Copia el contenido de `build/web/` al directorio webapps de tu servidor.
   - Configura la base de datos en los archivos de conexión (`config/Conexion.java`).

4. **Acceso:**
   - Ingresa a la aplicación vía navegador en la URL configurada (ejemplo: `http://localhost:8080/PROYECTO_SIRESA/web/index.html`).

## Documentación

- Manual de usuario y técnico en [docs/](docs/)
- Diccionario de datos, estándares y microservicios en [docs/](docs/)
- Diagramas y especificaciones funcionales en [docs_md/](docs_md/)
- Documentación y estándares: Ver archivos en [docs/](docs/)