![Logo UPT](./media/image1.png)

# UNIVERSIDAD PRIVADA DE TACNA

**FACULTAD DE INGENIERÍA**  
**Escuela Profesional de Ingeniería de Sistemas**

## Proyecto: *WEB Sistema de Registro de Salud - SIRESA*

**Curso:** Patrones de Software  
**Docente:** Mag. Patrick Cuadros Quiroga

**Integrantes:**
- Ancco Suaña, Bruno Enrique (2023077472)
- Huaman Rivera, Roberto Carlos (2021071077)
- Rivera Muñoz, Augusto Joaquin (2022073505)

**Tacna -- Perú**  
**2025**

---

### CONTROL DE VERSIONES

| Versión | Hecha por          | Revisada por | Aprobada por | Fecha      | Motivo                  |
|---------|--------------------|--------------|--------------|------------|-------------------------|
| 1.0     | BEAS, RCHQ, AJRM   | PCQ          | PCQ          | 09/09/2025 | Versión Original        |


# Sistema Web de Registro de Salud - SIRESA

## Documento de Visión

**Versión 2.0**

---

## ÍNDICE GENERAL

1. Introducción
   - Propósito
   - Alcance
   - Definiciones, Siglas y Abreviaturas
   - Referencias
   - Visión General
2. Posicionamiento
   - Oportunidad de negocio
   - Definición del problema
3. Descripción de los interesados y usuarios
   - Resumen de los interesados
   - Resumen de los usuarios
   - Entorno de usuario
   - Perfiles de los interesados
   - Perfiles de los Usuarios
   - Necesidades de los interesados y usuarios
4. Vista General del Producto
   - Perspectiva del producto
   - Resumen de capacidades
   - Suposiciones y dependencias
   - Costos y precios
   - Licenciamiento e instalación
5. Características del producto
6. Restricciones
7. Rangos de calidad
8. Precedencia y Prioridad
9. Otros requerimientos del producto

---

# Introducción

En la actualidad, la fiscalización sanitaria de establecimientos de expendio de bebidas y comidas es esencial para garantizar la salud pública. Sin embargo, muchas de estas labores aún se realizan de manera manual o con herramientas dispersas, lo que limita la trazabilidad, la transparencia y la eficiencia en los procesos de control y seguimiento.

Este documento presenta la visión de un sistema web de registros de salud orientado a digitalizar y optimizar el proceso de fiscalización de establecimientos alimentarios. Permitirá el registro estructurado de información de cada establecimiento inspeccionado, asignando su estado sanitario mediante un sistema visual tipo semáforo (verde: aprobado, rojo: rechazado, amarillo: en revisión).

El sistema busca centralizar y asegurar la información, mejorar la toma de decisiones, agilizar la supervisión y ofrecer una herramienta accesible para la gestión de fiscalizaciones en tiempo real. Este documento define los objetivos, funcionalidades clave, usuarios previstos y alcances funcionales de la solución.

---

## 1. Propósito

El propósito es establecer una visión clara y compartida sobre el desarrollo e implementación de un sistema web de registros de salud, orientado a gestionar la fiscalización de establecimientos de expendio de bebidas y comidas. Permitirá registrar, visualizar y monitorear el estado sanitario de estos establecimientos tras ser inspeccionados por las autoridades.

Este documento servirá como guía para desarrolladores y responsables, definiendo objetivos generales, funcionalidades clave, usuarios y restricciones, asegurando una comprensión común y facilitando el diseño alineado a las necesidades.

---

## 2. Alcance

El sistema web abarcará en su primera fase:

- Registro de establecimientos (datos generales).
- Gestión de fiscalizaciones (registro y resultado).
- Asignación de estado sanitario visual (semáforo: verde, rojo, amarillo).
- Consulta y búsqueda por estado, ubicación, tipo y fecha.
- Historial de visitas por establecimiento.
- Control de acceso por roles (inspectores, supervisores, administradores).
- Generación de reportes mensuales y exportación para auditoría y análisis.

---

## 3. Definiciones, siglas y abreviaturas

- **UML (Lenguaje de Modelado Unificado):** Lenguaje de modelado visual para arquitectura, diseño e implementación de sistemas de software complejos.

---

## 4. Referencias

- Documento "Informe de Factibilidad".

---

# Posicionamiento

## 1. Oportunidad de negocio

La creciente preocupación por la salud pública y la inocuidad alimentaria exige herramientas tecnológicas para las fiscalizaciones. Los procesos manuales generan errores, pérdida de información y demoras en la toma de decisiones.

Implementar un sistema web centraliza la información, mejora la trazabilidad, transparencia y eficiencia, facilita reportes automáticos y ofrece una visualización clara del estado sanitario. Esto fortalece la confianza ciudadana y mejora el control sanitario institucional.

## 2. Definición del Problema

Las deficiencias actuales incluyen:

- Registros físicos o no estandarizados.
- Falta de acceso inmediato a resultados de fiscalización.
- Dificultad para identificar el estado sanitario de los locales.
- Imposibilidad de generar reportes ágiles y estadísticas consolidadas.
- Riesgo de pérdida o alteración de información crítica.

Estas limitaciones reducen la capacidad de las autoridades y aumentan el riesgo sanitario. Es necesario automatizar y centralizar el proceso.

---

# Descripción de los interesados y usuarios

## 1. Resumen de los interesados

Los principales interesados son autoridades de salud pública, fiscalizadores sanitarios, supervisores, desarrolladores y la ciudadanía.  
Cada grupo busca eficiencia, transparencia y soporte en el proceso de fiscalización y control.

## 2. Resumen de los usuarios

Participan funcionarios del Policlínico Municipal, visitadores, fiscalizadores y ciudadanos que desean consultar información pública.

## 3. Entorno de usuario

- Basado en navegador web moderno (Chrome, Firefox, Edge, etc).
- Interfaz responsiva, organizada por roles.
- Paneles diferenciados por tipo de usuario.
- Visualización tipo semáforo (verde, rojo, amarillo).
- Formulario de registro de fiscalización claro y ordenado.
- Búsquedas y filtros dinámicos.
- Módulo de reportes (PDF/Excel).
- Seguridad y control de acceso.

## 4. Perfiles de los interesados

| Interesado                                           | Rol en el proyecto                       | Interés principal                                                                              |
|------------------------------------------------------|------------------------------------------|------------------------------------------------------------------------------------------------|
| Policlínico Municipal / Municipalidad de Tacna       | Promotor y usuario estratégico           | Herramienta moderna para centralizar información y facilitar decisiones sanitarias              |
| Inspectores Sanitarios                               | Usuarios operativos                      | Plataforma rápida para registrar inspecciones y acceder a historial                             |
| Supervisores / Coordinadores de Fiscalización        | Validadores y usuarios analíticos        | Validar inspecciones, generar reportes, monitorear inspectores                                 |
| Área de Tecnologías de la Información (TI)           | Soporte técnico e implementación         | Instalación, mantenimiento y seguridad del sistema                                             |
| Ciudadanía (población general)                       | Usuario indirecto / beneficiario         | Conocer que los locales han sido fiscalizados y su estado sanitario                            |

## 5. Perfiles de los usuarios

| Perfil         | Descripción                                                                        | Funciones principales                                       |
|----------------|------------------------------------------------------------------------------------|-------------------------------------------------------------|
| Administrador  | Configuración global del sistema, gestión de usuarios                              | Crear, editar, eliminar usuarios, asignar roles, respaldos  |
| Visitador      | Inspector responsable de registrar inspecciones                                    | Registrar establecimientos, asignar estado, editar visitas  |
| Fiscalizador   | Control de calidad y revisión de los inspectores                                   | Validar registros, generar reportes, exportar estadísticas  |
| Ciudadano      | Usuario externo con acceso solo a consulta                                         | Buscar, ver estado, sin editar ni registrar datos           |

## 6. Necesidades de los interesados y usuarios

| Interesado                                           | Necesidades identificadas                                        |
|------------------------------------------------------|------------------------------------------------------------------|
| Policlínico Municipal / Municipalidad de Tacna       | Centralizar fiscalizaciones, control sanitario, informes         |
| Inspectores Sanitarios                               | Registrar resultados, asignar estados, consultar historial       |
| Supervisores / Coordinadores                         | Validar y rechazar registros, monitorear y generar informes      |
| Área de Tecnologías de la Información (TI)           | Configurar, mantener el sistema, seguridad y administración      |
| Ciudadanía (población general)                       | Consultar estado sanitario de establecimientos                   |

---

# Vista General del Producto

## 1. Perspectiva del producto

El sistema es una solución centralizada y digital para la fiscalización sanitaria de restaurantes y comercios, reemplazando los métodos manuales, con énfasis en facilidad de uso, visualización rápida e información estructurada y segura.

## 2. Resumen de capacidades

- Registro estructurado de establecimientos.
- Gestión detallada de fiscalizaciones (visitas y resultados).
- Visualización de estado con semáforo (verde, rojo, amarillo).
- Filtros y búsquedas por distintos criterios.
- Historial completo de inspecciones.
- Control de acceso por roles.
- Informes exportables (PDF, Excel).
- Interfaz responsiva y moderna.
- Seguridad y trazabilidad de acceso y acciones.

## 3. Suposiciones y dependencias

- Acceso confiable a internet.
- Personal con capacitación básica en tecnologías web.
- Colaboración institucional y disposición a usar la plataforma.
- Infraestructura tecnológica adecuada (servidores, copias de seguridad).
- Mantenimiento y soporte a cargo del área TI.
- Posibles adaptaciones ante cambios normativos.
- Participación ciudadana voluntaria en la consulta.

## 4. Costos y precios

No existen precios para los usuarios; el sistema es de uso institucional y público. Los costos incluyen desarrollo, infraestructura, capacitación, soporte y difusión, para mejorar eficiencia y transparencia.  
(Ver detalles ampliados en el Informe de Factibilidad).

## 5. Licenciamiento e instalación

El sistema está licenciado como software institucional, propiedad municipal, de uso restringido por las autoridades de salud pública. Será instalado en servidores municipales o la nube, con acceso y respaldo seguro, y configuración inicial asistida por TI.

---

# Características del producto

- Registro estructurado de establecimientos y fiscalizaciones.
- Asignación visual de estado sanitario tipo semáforo (verde, rojo, amarillo).
- Búsqueda y filtrado dinámico.
- Acceso controlado por roles diferenciados.
- Historial de visitas completo.
- Informes automáticos exportables (PDF, Excel).
- Interfaz responsiva, accesible en navegadores modernos.
- Seguridad mediante autenticación y permisos diferenciados.

---

# Restricciones

- Acceso restringido por roles de usuario.
- Dependencia de una conexión estable a internet.
- Compatibilidad solo con navegadores web modernos.
- Seguridad y confidencialidad de los datos sensibles obligatoria.
- Fase inicial enfocada a registro, consulta e informes; sin integración externa inmediata.

---

# Rangos de calidad

- Interfaz intuitiva y responsiva.
- Alta disponibilidad y seguridad.
- Precisión y confiabilidad en registro y visualización.
- Respuesta rápida en consultas e informes.
- Integridad y consistencia de los datos.

---

# Precedencia y Prioridad

- Prioridad para las funcionalidades esenciales: registro, gestión de fiscalizaciones, asignación de estados y consulta.
- Secundaria: informes, control de acceso por roles, mejoras UI/UX y toma de decisiones.
- Seguridad y disponibilidad son prioritarias desde fases iniciales.

---

# Otros requerimientos del producto

- Accesibilidad multiplaforma, sin instalaciones adicionales.
- Interfaz responsiva y amigable.
- Seguridad y control de acceso por roles.
- Integridad y confidencialidad de datos.
- Generación y exportación de informes (PDF, Excel).
- Mantenimiento y actualización fácil para el equipo TI.
