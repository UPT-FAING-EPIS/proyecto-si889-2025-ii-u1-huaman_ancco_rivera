![Logo UPT](./media/image1.png)

# UNIVERSIDAD PRIVADA DE TACNA

## FACULTAD DE INGENIERÍA  
**Escuela Profesional de Ingeniería de Sistemas**

# Informe Final

**Proyecto Sistema Web de Registros de Salud - SIRESA**

Curso: Patrones de Software  
Docente: *Mag. Patrick Cuadros Quiroga*

**Integrantes:**  
- Ancco Suaña, Bruno Enrique (2023077472)  
- Huaman Rivera, Roberto Carlos (2021071077)  
- Rivera Muñoz, Augusto Joaquin (2022073505)  

Tacna -- Perú  
2025

---

## CONTROL DE VERSIONES

| Versión | Hecha por          | Revisada por | Aprobada por | Fecha      | Motivo          |
|---------|--------------------|--------------|--------------|------------|-----------------|
| 1.0     | BEAS, RCHQ, AJRM   | PCQ          | PCQ          | 09/09/2025 | Versión Original|

---

## ÍNDICE GENERAL

1. Antecedentes  
2. Planteamiento del Problema  
   - Problema  
   - Justificación  
   - Alcance  
3. Objetivos  
4. Marco Teórico  
5. Desarrollo de la Solución  
   - Análisis de Factibilidad (técnico, económica, operativa, social, legal, ambiental)  
   - Tecnología de Desarrollo  
   - Metodología de implementación (Documento de VISIÓN, SRS, SAD)  
6. Cronograma  
7. Presupuesto  
8. Conclusiones  
9. Recomendaciones  
10. Bibliografía  
11. Anexos  
    - Anexo 01 Informe de Factibilidad  
    - Anexo 02 Documento de Visión  
    - Anexo 03 Documento SRS  
    - Anexo 04 Documento SAD  
    - Anexo 05 Manuales y otros documentos  

---

# 1. Antecedentes

La gestión de la configuración es clave para el éxito de proyectos TIC para proteger la integridad y permitir el control formal de todos los elementos configurados. Un plan efectivo evita costos, mejora calidad y facilita la entrega acorde a costos, calendarios y requerimientos.

---

# 2. Planteamiento del Problema

Actualmente hay dificultades por falta de control eficiente de versiones y registro de cambios, generando ineficiencias, retrasos, falta de comunicación y complicaciones en la gestión. Se requiere un sistema que integre y centralice los registros de salud de los establecimientos fiscalizados para una gestión eficiente y transparente, accesible para autoridades, establecimientos y usuarios del sector turismo.

---

## Problema

Falta de un sistema para gestionar versiones y cambios con seguimiento transparente que agilice proyectos y permita acceso actualizado desde cualquier lugar.

---

## Justificación

El sistema para Gestión y Administración de la Configuración optimizará la eficiencia en procesos, automatizará tareas clave como gestión de usuarios, documentos y cambios, logrando reducir tiempos y mejorar calidad del servicio.

---

## Alcance

- Registro de establecimientos: datos generales (nombre, dirección, tipo de servicio).  
- Gestión de fiscalizaciones: registro detallado de visitas.  
- Estado sanitario: visualización con colores (verde, rojo, amarillo).  
- Consulta y búsqueda filtrada por estado, ubicación, tipo, fechas.  
- Historial de visitas por establecimiento.  
- Control de acceso por roles (inspectores, supervisores, administradores).  
- Soporte para reportes y auditorías.

---

# 3. Objetivos

## Objetivo General

Automatizar la Gestión de Configuración en proyectos de software para reducir costos y tiempos, asegurar satisfacción del cliente, garantizar seguridad y accesibilidad de documentos.

## Objetivos Específicos

- Crear aplicación para gestionar proyectos asignados.  
- Desarrollar software que administre metodologías.  
- Organizar proyectos asignados.  
- Gestionar usuarios eficazmente.  
- Administrar documentos y versiones de forma efectiva.

---

# 4. Marco Teórico

## 4.1 Calidad de software

La calidad del software se controla asegurando atributos propios, considerando que es un producto inmaterial, con errores propios diferentes a productos físicos. Tiene menor tradición que la calidad tradicional pero es fundamental.

## 4.2 Normativa ISO 9000

La norma audita procesos internos para certificación vigente, renovable periódicamente, costosa y que garantiza calidad en metodologías y sistemas.

## 4.3 Medición del software

Se miden atributos de calidad subdivididos en métricas concretas, aunque a veces imprecisas. La medición sigue un enfoque de lo general a lo concreto, crucial para la ciencia aplicada al software.

## 4.4 Líneas Base

Definición y control formal de especificaciones o productos que sirven como referencia para desarrollos posteriores con procedimientos estrictos para cambios.

![Líneas Base](./media/image2.jpg)

## 4.5 Elementos de la Configuración

Elementos (ECS) son documentos, pruebas o componentes que se identifican y catalogan en base de datos con nombre y atributos, formando grafos de interrelaciones.

![Elementos de Configuración](./media/image5.jpg)

## 4.6 Gestión de Configuración de Software

Responsable de controlar identificaciones, versiones, cambios, auditorías e informes para mantener calidad y control del producto.

## 4.7 Proceso de Gestión de Configuración de Software

Control de cambios y versiones durante todas las fases del desarrollo garantizando disponibilidad y mantenimiento. Facilita el mantenimiento del sistema.

![Gestión de Configuración](./media/image6.png)

## 4.8 Identificación de Objetos en GCS

Objetos básicos y compuestos con nombres únicos y atributos claros que evolucionan conforme al ciclo de ingeniería.

![Identificación de Objetos](./media/image7.png)

## 4.9 Control de Versiones

Procedimientos y herramientas que permiten manejar versiones asociadas a atributos variable en complejidad para describir configuraciones.

![Control de Versiones](./media/image8.jpg)

## 4.10 Control de cambios

Combinación de procedimientos y herramientas para evitar caos, controlar cambios y asegurar calidad.

![Control de Cambios](./media/image9.jpg)

## 4.11 Auditoría de la Configuración

La autoridad controla impactos y evalúa cambios con revisiones técnicas formales y auditorías para confirmar cumplimiento y coherencia.

## 4.12 Informe de Estado

Generación de reportes claros sobre cambios realizados con detalle y responsables para mejorar comunicación y evitar errores.

---

# 5. Desarrollo de la Solución

## Análisis de Factibilidad

### Técnico

Uso de hardware existente (PC con Intel i5, 4 GB RAM, 500 GB HDD), software Windows 10. Cliente posiblemente laptop sin costo extra.

| Estructura | Recurso | Descripción                    |
|------------|---------|--------------------------------|
| Hardware   | PC      | Intel Core i5, 4 GB RAM, 500 GB HDD |
| Software   | Sistema | Windows 10 Home                |

### Económica

| Costos Generales          | Monto (S/.) |
|--------------------------|-------------|
| Provisiones de Oficina    | 1,000.00    |
| **Total**                | **1,000.00**|

### Costos Operativos Durante el Desarrollo

| Concepto                   | Actividad                    | Costo (S/.) |
|----------------------------|-----------------------------|-------------|
| Alquiler de Laptops (5)     | Equipos para desarrollo      | 2,000.00    |
| Servicio de Energía Eléctrica (5) | Suministro de energía   | 1,000.00    |
| Servicio de Internet (5)    | Conexión a internet          | 1,200.00    |
| **Total**                  |                             | **4,200.00**|

### Operativa

Automatizar tareas cotidianas para mejorar eficiencia y equidad en ejecución.

### Social

Compromiso institucional con entrega a tiempo, capacitación y mantenimiento sin costo el primer año para asegurar adopción.

### Legal

Cumplimiento Ley Orgánica de Protección de Datos (LOPD) y licenciamiento legítimo.

### Ambiental

Evaluación de impacto ambiental y adopción de prácticas sostenibles y uso de materiales reciclables.

---

# Tecnología de Desarrollo

- Lenguaje: C# (.NET Framework) con ASP.NET MVC para lógica y controladores.  
- Frameworks y Librerías: ASP.NET MVC 5, Entity Framework, Bootstrap 5, jQuery, DataTables.  
- Base de Datos: SQL Server.  
- Herramientas: Visual Studio 2022, SSMS, Git, GitHub, Postman.  
- Arquitectura: MVC, cliente-servidor con comunicaciones HTTP y AJAX.  
- Recursos adicionales: CSS personalizado, FontAwesome.

---

# Metodología de Implementación

Basada en documentos Visión, SRS y SAD para definir objetivos, requisitos, arquitectura y diseño de la solución.

---

# 6. Cronograma

| Elemento               | Fase           | Elemento Configuración de Software  | Fecha        |
|-----------------------|----------------|------------------------------------|--------------|
| Análisis Preliminar    |                | Informe de Factibilidad             | 18/04/2024   |
|                       |                | Plan de Gestión de la Configuración| 18/04/2024   |
|                       |                | Informe de Visión                  | 23/04/2025   |
|                       |                | Estándares de Programación        | 25/04/2025   |
|                       |                | Plan de Gestión de Riesgos        | 04/05/2025   |
| RUP                   | Inicio         | Especificación de Requerimientos  | 09/05/2025   |
|                       |                | Diagrama de Caso de Uso           | 11/05/2025   |
|                       |                | Diagrama de Paquetes              | 16/05/2025   |
|                       |                | Narrativa Caso de Uso             | 16/05/2025   |
|                       |                | Diagrama de Clases               | 16/05/2025   |
|                       |                | Diagrama Entidad-Relación        | 17/05/2025   |
|                       |                | Diagrama de Componentes          | 22/05/2025   |
|                       | Elaboración    | Diseño de Prototipos             | 28/05/2025   |
|                       |                | Diagrama de Secuencia            | 29/05/2025   |
|                       |                | Diagrama Físico de Base de Datos | 31/05/2025   |
|                       |                | Diagrama de Despliegue           | 02/06/2025   |
|                       | Construcción   | Solución del Proyecto - Casos de Uso |          |
|                       |                | Pruebas del Sistema              |              |
|                       | Transición     | Acta Informe Final               |              |

---

# 7. Presupuesto

| Descripción            | Monto (S/.) |
|-----------------------|-------------|
| Costos generales       | 1,000.00    |
| Costos operativos      | 4,200.00    |
| Costos del ambiente    | 1,000.00    |
| Costos de personal     | 2,100.00    |
| **Costo total**        | **8,300.00**|

---

# 8. Conclusiones

- El sistema cumple todos los requisitos funcionales y no funcionales, es escalable y flexible.  
- Representa una solución beneficiosa para los objetivos planteados.  
- La gestión eficaz de cambios incluye un Comité de Control de Cambios para administrar los ECS.  
- Se definió claramente el alcance y objetivo para agilizar inventarios en almacén.  

---

# Recomendaciones

- Mantener colaboración continua con cliente y partes interesadas para adaptar el desarrollo.  
- Realizar entrevistas frecuentes para clarificar requisitos funcionales y no funcionales y capacidades de usuarios futuros.

---