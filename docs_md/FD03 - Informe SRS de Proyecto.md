![Logo UPT](./media/image1.png)

# UNIVERSIDAD PRIVADA DE TACNA

**FACULTAD DE INGENIERÍA**  
**Escuela Profesional de Ingeniería de Sistemas**

# Proyecto Sistema Web de Registros de Salud - SIRESA

**Curso:** Patrones de Software  
**Docente:** Mag. Patrick Cuadros Quiroga

**Integrantes:**
- Ancco Suaña, Bruno Enrique (2023077472)
- Huaman Rivera, Roberto Carlos (2021071077)
- Rivera Muñoz, Augusto Joaquin (2022073505)

**Tacna -- Perú 2025**

---

## CONTROL DE VERSIONES

| Versión | Hecha por            | Revisada por | Aprobada por | Fecha      | Motivo                |
|---------|----------------------|--------------|--------------|------------|-----------------------|
| 1.0     | BEAS, RCHR, UJRM     | PCQ          | PCQ          | 07/05/2025 | Versión Original      |

---

# Sistema Web de Registro de Salud - SIRESA  
**Documento de Especificación de Requerimientos de Software (SRS)**  
**Versión 3.0**

---

## ÍNDICE GENERAL

- Introducción
- I. Generalidades de la Empresa
    - Nombre de la Empresa
    - Visión
    - Misión
    - Organigrama
- II. Visionamiento de la Empresa
    - Descripción del Problema
    - Objetivos de Negocios
    - Objetivos de Diseño
    - Alcance del proyecto
    - Viabilidad del Sistema
    - Información obtenida del Levantamiento de Información
- III. Análisis de Procesos
    - Diagrama del Proceso Actual
    - Diagrama del Proceso Propuesto
- IV. Especificación de Requerimientos de Software
    - Requerimientos funcionales iniciales/finales
    - Requerimientos no funcionales
    - Reglas de Negocio
- V. Fase de Desarrollo
    - Perfiles de Usuario
    - Modelo Conceptual
    - Diagrama de Paquetes
    - Diagrama de Casos de Uso
    - Escenarios de Caso de Uso
    - Modelo Lógico
    - Análisis de Objetos
    - Diagramas varios (actividades, secuencia, clases)
- Conclusiones
- Recomendaciones
- Bibliografía
- Webgrafía

---

# Introducción

---

## I. Generalidades de la Empresa

### Nombre de la Empresa
Policlínico Municipal - Municipalidad Provincial de Tacna

### Visión
Garantizar servicios de calidad promoviendo el desarrollo integral y sostenible de la población de la Provincia de Tacna.

### Misión
Tacna, con identidad patriótica, moderna, ordenada y atractiva a la inversión, comprometida con el desarrollo sostenible y con igualdad de oportunidades.

### Organigrama

![Organigrama](./media/image4.jpeg)

---

## II. Visionamiento de la Empresa

### Descripción del Problema

El proceso de fiscalización y registro de establecimientos de expendio de alimentos y bebidas es manual o fragmentado, generando ineficiencia, demoras, poca trazabilidad y dificultad en la comunicación de resultados.

### Objetivos de Negocio

- Optimizar la gestión de fiscalizaciones sanitarias.
- Garantizar trazabilidad y transparencia.
- Digitalizar formularios y registros.
- Facilitar toma de decisiones basada en datos.
- Mejorar comunicación con establecimientos.
- Incrementar eficiencia del personal.
- Cumplir normativas y estándares de salud pública.

### Objetivos de Diseño

- Interfaz intuitiva y fácil de usar.
- Arquitectura modular y escalable.
- Seguridad, autenticación y auditoría.
- Registro en tiempo real, incluso offline.
- Generación de reportes y visualización de datos.
- Alertas y notificaciones automáticas.
- Accesibilidad y usabilidad.

### Alcance del Proyecto

Brindar a las autoridades una herramienta web para registrar, controlar y monitorear fiscalizaciones, centralizando y digitalizando el proceso.

#### Funcionalidades principales:

- Registro de establecimientos y visitas.
- Asignación de estados (Aprobado, En Revisión, Rechazado).
- Reportes administrativos y sanitarios.
- Gestión de usuarios y roles.
- Notificaciones automáticas.
- Interfaz responsive para web y móvil.
- Módulo de autenticación, seguridad y panel de indicadores.

### Viabilidad del Sistema

- **Técnica:** Uso de tecnologías web (HTML, CSS, JS, MySQL) y servidores/nube.
- **Económica:** Reducción de costos operativos, aumento de eficiencia y rápida amortización.
- **Operativa:** Personal suficiente y diseño amigable, capacitación prevista, adopción positiva.

### Información obtenida del Levantamiento de Información

#### Procesos actuales

- Inspecciones en papel o Excel.
- Resultados notificados manualmente.
- No existe una base centralizada.

#### Problemas identificados

- Duplicidad y pérdida de documentos.
- Dificultad para generar reportes.
- Consumo de tiempo y poca trazabilidad.
- Falta de información en campo.

#### Necesidades detectadas

- Sistema web centralizado.
- Reportes automáticos.
- Seguridad y diferenciación por roles.
- Notificaciones a establecimientos.
- Registro de evidencias (fotos y observaciones).

#### Expectativas del sistema

- Accesibilidad desde oficina y campo.
- Rápido ingreso de datos y validaciones.
- Mejor supervisión e indicadores visuales.
- Facilitar auditorías internas.

---

## III. Análisis de Procesos

### Diagrama del Proceso Actual

![Diagrama del Proceso Actual](./media/image5.jpeg)

### Diagrama del Proceso Propuesto

![Diagrama Propuesto](./media/image6.jpeg)

---

## IV. Especificación de Requerimientos de Software

### Cuadro de Requerimientos Funcionales

| Código  | Rol                          | Requerimiento Funcional                           | Descripción                                                                                                    | Prioridad |
|---------|------------------------------|---------------------------------------------------|----------------------------------------------------------------------------------------------------------------|-----------|
| RF-01   | Administrador                | Login y gestión de usuarios                       | Autenticación para roles (administrador, fiscalizador, usuario general).                                       | Alta      |
| RF-02   | Inspector                    | Registro de establecimientos                      | Registrar nuevos establecimientos (nombre, dirección, tipo, contacto).                                         | Alta      |
| RF-03   | Admin/Inspector/Ciudadano    | Visualización del estado de los establecimientos  | Mostrar el estado de cada establecimiento: verde (aprobado), rojo (rechazado), amarillo (en proceso).          | Alta      |
| RF-04   | Admin/Inspector              | Actualización del estado                          | Cambiar el estado del establecimiento (aprobado, rechazado, en proceso).                                       | Alta      |
| RF-05   | Admin/Inspector/Ciudadano    | Búsqueda y filtrado                               | Buscar y filtrar establecimientos por nombre, tipo, ubicación o estado.                                        | Alta      |
| RF-06   | Inspector                    | Registro de inspecciones                          | Registrar inspecciones con fecha, observaciones, resultado.                                                     | Alta      |
| RF-07   | Admin/Inspector              | Generación de reportes                            | Generar reportes por periodo, estado, ubicación o cantidad revisados.                                          | Media     |
| RF-08   | Admin/Inspector              | Visualización en mapa                             | Mostrar establecimientos en mapa con color de estado.                                                          | Baja      |
| RF-09   | Administrador                | Historial de cambios                              | Mantener historial de cambios (quién, cuándo, por qué cambió el estado).                                       | Baja      |
| RF-10   | Administrador                | Notificaciones                                    | Notificar internamente o por correo cambios de estado a responsables.                                          | Baja      |

### Cuadro de Requerimientos No Funcionales

| Código     | Requerimiento No Funcional             | Descripción                                                                                   |
|------------|----------------------------------------|-----------------------------------------------------------------------------------------------|
| RNF-01     | Disponibilidad                         | Sistema disponible 24/7, menos de 4% de inactividad mensual.                                  |
| RNF-02     | Rendimiento                            | Respuesta no mayor a 10 segundos en consultas comunes.                                        |
| RNF-03     | Seguridad                              | Autenticación segura, cifrado de datos sensibles.                                             |
| RNF-04     | Usabilidad                             | Interfaz intuitiva y accesible con instrucciones claras para los usuarios.                    |
| RNF-05     | Escalabilidad                          | Capacidad para hasta 10,000 establecimientos registrados.                                     |
| RNF-06     | Mantenibilidad                         | Permitir actualizaciones sin afectar la disponibilidad.                                       |
| RNF-07     | Compatibilidad                         | Funcionamiento en Chrome, Firefox, Edge.                                                      |
| RNF-08     | Respaldo de datos                      | Respaldo automático diario de la base de datos.                                              |
| RNF-09     | Accesibilidad                          | Cumplir requisitos de accesibilidad.                                                         |
| RNF-10     | Localización                           | En español y ajustes regionales por ciudad fiscalizada.                                       |

---

## Reglas de Negocio

![Reglas de negocio](./media/image7.png)

---

## V. Fase de Desarrollo

### Perfiles de Usuario

| Rol          | Descripción                                                                                                                 |
|--------------|----------------------------------------------------------------------------------------------------------------------------|
| Administrador| Control total del sistema, gestión de usuarios, cambios de estado, historial, reportes.                                    |
| Inspector    | Registro de establecimientos e inspecciones, actualización de estados, generación de reportes.                             |
| Ciudadano    | Visualización de establecimientos, búsqueda, filtros, no puede modificar datos.                                             |

---

## Modelo Conceptual

![Modelo conceptual](./media/image8.jpeg)

### Diagrama de Paquetes

![Diagrama de paquetes](./media/image9.jpeg)

### Diagrama de Casos de Uso

![Casos de uso general](./media/image10.jpeg)

#### Diagramas por requerimiento:

- **RF01:**  
  (imagen)

- **RF02:**  
  ![RF02](./media/image12.png)

- **RF03:**  
  ![RF03](./media/image13.png)

- **RF05:**  
  ![RF05](./media/image15.png)

- **RF06:**  
  ![RF06](./media/image16.png)

- **RF08:**  
  ![RF08](./media/image18.png)

- **RF09:**  
  ![RF09](./media/image19.png)

- **RF10:**  
  ![RF10](./media/image20.png)

---

## Escenarios de Caso de Uso

### Nombre del Caso de Uso:
Registrar Fiscalización Sanitaria en Establecimiento

#### Actor Principal:
Inspector de Salud Pública

#### Objetivo del Actor:
Registrar hallazgos de fiscalización en campo de manera rápida y segura.

#### Precondiciones:

- Usuario autenticado
- Establecimiento previamente registrado
- Permisos asignados
- Acceso con batería suficiente y conexión o modo offline

#### Flujo Principal de Eventos:
1. Inicio de sesión
2. Acceso a módulo de fiscalizaciones y nueva fiscalización
3. Búsqueda y selección del establecimiento
4. Llenado de formulario (datos, condiciones, observaciones, evidencia)
5. Asignación de estado ("aprobado", "en revisión", "rechazado")
6. Confirmación y envío
7. Notificación automática al establecimiento

#### Flujos Alternativos:
- Sin conexión (se guarda localmente y sincroniza después)
- Establecimiento no registrado (permite registrar)
- Datos incompletos (valida el formulario)

#### Postcondiciones:
- Registro de fiscalización completo y actualizado
- Historial y evidencia almacenados
- Alertas/Logs generados

#### Consideraciones UX/UI:
- Formulario responsivo, botones grandes, autoguardado, usabilidad priorizada

---

## Modelo Lógico y Diagramas

### Análisis de Objetos

![Análisis de Objetos](./media/image21.jpeg)

### Diagrama de Actividades con Objetos

![Diagrama de actividades](./media/image22.png)

### Diagrama de Secuencia

![Diagrama de secuencia](./media/image23.png)

### Diagrama de Clases

![Diagrama de clases](./media/image24.png)

---

# Conclusiones

- El sistema propuesto resuelve la problemática de fiscalización manual y dispersa, centralizando información y agilizando la gestión.
- Automatiza procesos, mejora reportes, aporta transparencia y promueve la confianza ciudadana.
- Metodologías y herramientas de ingeniería del software se aplican para garantizar seguridad, acceso, escalabilidad y alineación normativa.
- La solución puede escalar regional o nacionalmente, mejorando significativamente los servicios públicos.
