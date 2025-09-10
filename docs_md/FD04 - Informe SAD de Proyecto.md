![Logo UPT](./media/image1.png)

# UNIVERSIDAD PRIVADA DE TACNA

## FACULTAD DE INGENIERÍA
**Escuela Profesional de Ingeniería de Sistemas**

> **Proyecto WEB Sistema de Registros de Salud - SIRESA**

**Curso:** Patrones de Software  
**Docente:** Mag. Patrick Cuadros Quiroga

**Integrantes:**
- Ancco Suaña, Bruno Enrique (2023077472)
- Huaman Rivera, Roberto Carlos (2021071077)
- Rivera Muñoz, Augusto Joaquin (2022073505)

**Tacna -- Perú**  
**2025**

---

## CONTROL DE VERSIONES

| Versión | Hecha por         | Revisada por | Aprobada por | Fecha      | Motivo            |
|---------|-------------------|--------------|--------------|------------|-------------------|
| 1.0     | BEAS, RCHR, AJRM  | PCQ          | PCQ          | 09/09/2025 | Versión Original  |

---

## Sistema WEB de Registros de Salud - SIRESA  
**Documento de Arquitectura de Software**  
**Versión 1.0**

---

## ÍNDICE GENERAL

1. Introducción
    - Propósito (Diagrama 4+1)
    - Alcance
    - Definición, siglas y abreviaturas
    - Organización del documento
2. Objetivos y Restricciones Arquitectónicas
    - Requerimientos funcionales
    - Requerimientos no funcionales (Atributos de Calidad)
3. Representación de la Arquitectura del Sistema
    - Vista de caso de uso (diagramas)
    - Vista lógica (paquetes, secuencia, colaboración, objetos, clases, bdd)
    - Vista de implementación (paquetes, componentes)
    - Vista de procesos (actividad)
    - Vista de despliegue (física)
4. Atributos de Calidad del Software

---

# Introducción

## Propósito (Diagrama 4+1)

El propósito es definir las necesidades y características para el manejo de registros de establecimientos fiscalizados por el Ministerio de Salud en Tacna. Se orienta a los casos de uso, interacción de roles y visualización ciudadana.  
Se implementará una aplicación móvil y web que permite visualizar registros, con etiquetas de colores (proceso, aceptado, no aceptado) y acceso para ciudadanos. Los detalles técnicos y funcionales están en los diagramas y especificaciones.

## Alcance

El sistema centralizará y optimizará:
- Registros de establecimientos de comidas y bebidas
- Registro GPS de las direcciones
- Gestión de registros y visualización vía GPS

Sustituye registros físicos y ofrece controles tanto para administradores/fiscalizadores como para ciudadanos.

## Definición, siglas y abreviaturas

- **Aplicación Móvil:** Herramienta digital accesible desde navegador, capaz de integrar multimedia.
- **Firebase Console:** Plataforma de gestión de base de datos y autenticación.

## Organización del documento

Equipo:
- Huaman Rivera, Roberto — Programador

Estructura:
- Introducción: propósitos y alcances
- Objetivos y restricciones arquitectónicas
- Representación arquitectónica (diagramas y modelos)
- Atributos de calidad

---

# OBJETIVOS Y RESTRICCIONES ARQUITECTÓNICAS

## Cuadro de Requerimientos funcionales

| Código  | Rol                          | Requerimiento Funcional                         | Descripción                                                                                                | Prioridad |
|---------|------------------------------|-------------------------------------------------|------------------------------------------------------------------------------------------------------------|-----------|
| RF-01   | Administrador                | Login y gestión de usuarios                     | Autenticación y gestión para roles (administrador, fiscalizador, usuario general).                         | Alta      |
| RF-02   | Inspector                    | Registro de establecimientos                    | Registro de establecimientos con datos clave: nombre, dirección, tipo, contacto.                           | Alta      |
| RF-03   | Admin/Inspector/Ciudadano    | Visualización del estado                        | Mostrar estado con color (verde, rojo, amarillo) para cada establecimiento.                                 | Alta      |
| RF-04   | Admin/Inspector              | Actualización del estado                        | Modificar el estado de revisión (aprobado, rechazado, en proceso) de los establecimientos.                 | Alta      |
| RF-05   | Admin/Inspector/Ciudadano    | Búsqueda y filtrado                             | Buscar/filtrar por nombre, tipo, ubicación, estado.                                                        | Alta      |
| RF-06   | Inspector                    | Registro de inspecciones                        | Registro de inspecciones, incluyendo fecha, observaciones, resultado.                                       | Alta      |
| RF-07   | Admin/Inspector              | Generación de reportes                          | Reportes por periodo, estado, ubicación, número de revisiones.                                             | Media     |
| RF-08   | Admin/Inspector              | Visualización en mapa                           | Mapa geográfico con colores según estado del establecimiento.                                               | Baja      |
| RF-09   | Administrador                | Historial de cambios                            | Historial de cambios por establecimiento: quién, cuándo, por qué.                                          | Baja      |
| RF-10   | Administrador                | Notificaciones                                  | Envío de notificaciones internas o correo cuando cambia el estado de un establecimiento.                   | Baja      |

---

## Cuadro de Requerimientos no funcionales

| Código   | Requerimiento No Funcional         | Descripción                                                                              |
|----------|------------------------------------|------------------------------------------------------------------------------------------|
| RNF-01   | Disponibilidad                     | Sistema disponible 24/7, inactividad menor al 4% mensual.                                |
| RNF-02   | Rendimiento                        | Respuestas rápidas, máximo 10 segundos por consulta común.                               |
| RNF-03   | Seguridad                          | Autenticación segura, cifrado de datos sensibles.                                        |
| RNF-04   | Usabilidad                         | Interfaz intuitiva, accesible, instrucciones claras.                                     |
| RNF-05   | Escalabilidad                      | Soporta hasta 10,000 establecimientos registrados.                                       |
| RNF-06   | Mantenibilidad                     | Permite actualizaciones sin afectar disponibilidad.                                      |
| RNF-07   | Compatibilidad                     | Funciona en Chrome, Firefox, Edge.                                                       |
| RNF-08   | Respaldo de datos                  | Respaldo automático diario de la base de datos.                                          |
| RNF-09   | Accesibilidad                      | Cumple requisitos de accesibilidad.                                                      |
| RNF-10   | Localización                       | En español, permite ajustes regionales.                                                  |

---

## Restricciones

- Existencia de dominio web propio.
- Diseño consistente en escritorio y móvil.
- Modulación para fácil adaptación.
- **Requerimientos clave**: fácil uso y opción de realidad virtual panorámica.
- Soporte para registro adicional si es necesario.
- Posibilidad de adquirir hardware para escalar.
- Varias sesiones de prueba para ajustarse a necesidades reales.

---

# REPRESENTACIÓN DE LA ARQUITECTURA DEL SISTEMA

## Vista de Caso de Uso

**Diagramas de Casos de Uso por Requerimiento:**

- RF01:  
  ![](./media/image5.png)
  ![](./media/image6.jpeg)

- RF02:  
  ![](./media/image7.jpeg)

- RF03:  
  (Imagen omitida)

- RF04:  
  ![](./media/image8.jpeg)

- RF05:  
  ![](./media/image9.jpeg)

- RF06:  
  ![](./media/image10.jpeg)

- RF07:  
  ![](./media/image11.jpeg)

- RF08:  
  (Imagen omitida)

- RF09:  
  ![](./media/image12.jpeg)

- RF10:  
  ![](./media/image13.jpeg)

---

## Vista Lógica

- **Diagrama de Subsistemas (Paquetes):**
  ![](./media/image14.jpeg)

- **Diagrama de Secuencia (vista de diseño):**
  ![](./media/image15.png)

- **Diagrama de Colaboración (vista de diseño):**
  ![](./media/image16.jpeg)

- **Diagrama de Objetos:**
  - Registro de usuarios  
    ![](./media/image17.jpeg)
  - Roles y permisos  
    ![](./media/image18.png)
  - Implementación web propia  
    ![](./media/image19.jpeg)
  - Registro de bienes inmuebles  
    ![](./media/image20.jpeg)
  - Administración de usuarios  
    ![](./media/image21.jpeg)

- **Diagrama de Clases:**
  ![](./media/image22.jpeg)

- **Diagrama de Base de datos:**
  ![](./media/image23.jpeg)

---

## Vista de Implementación (Desarrollo)

- **Diagrama de arquitectura software (paquetes):**
  ![](./media/image24.jpeg)
- **Diagrama de componentes del sistema:**
  ![](./media/image25.png)

---

## Vista de Procesos

- **Diagrama de procesos del sistema (actividad):**
  ![](./media/image26.jpeg)

---

## Vista de Despliegue (Física)

- **Diagrama de despliegue:**
  ![](./media/image27.jpeg)

---

# Atributos de Calidad del Software

- **Funcionalidad:** Cumple todos los requerimientos de negocio y usuario.
- **Usabilidad:** Interfaz intuitiva y amigable en todas las plataformas.
- **Confiabilidad:** Alta disponibilidad y respaldo, registro de auditoría y manejo de fallos.
- **Rendimiento:** Respuesta rápida y eficiente para el usuario final.
- **Mantenibilidad:** Código modular y documentación, facilita mejoras y correcciones.
- **Otros:** Escalabilidad y accesibilidad están consideradas en la arquitectura.

---
