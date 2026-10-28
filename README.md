# 🌱 Proyecto Integrador — Invernadero Inteligente (IoT)
### Monitoreo y Automatización para Cultivo de Jitomate Cherry (*Solanum lycopersicum var. cerasiforme*)

**Institución:** Universidad Tecnológica de Querétaro (UTEQ)  
**Materia:** Formulación de Proyectos de Tecnología  
**Profesor:** M. C. y T. Tito Villalobos Cruz (`tito.villalobos@uteq.edu.mx`)

---

## 👥 Equipo de Base de Datos y Backend
* **Cesar Oswaldo Medina Ornelas** (Líder de Proyecto)
* **Iker Aarón Razo Roa**
* **Jazmin Velazquez Cruz**
* **Viviana López Álvarez**
* **Susana Elizabeth Soforo Medrano**

---

## 🗄️ Arquitectura de Base de Datos (Supabase / PostgreSQL)
La base de datos se encuentra alojada en **Supabase** (PostgreSQL) y consta de **13 tablas normalizadas** según el diagrama Entidad-Relación:

1. `grupo`: Tenant/organización raíz del invernadero.
2. `usuario`: Credenciales, roles (`admin`, `operador`, `visor`) y control de acceso.
3. `magnitud`: Variables ambientales medidas (Temperatura, Humedad relativa, Humedad de sustrato, Lux, CO2).
4. `cultivo`: Registro agronómico (Jitomate Cherry).
5. `zona`: Áreas físicas del invernadero (Zona Norte vegetativa, Zona Sur fructificación).
6. `umbral`: Límites agronómicos mín/máx permitidos por cultivo y magnitud.
7. `dispositivo`: Hardware IoT (Microcontroladores ESP32, MAC, tokens).
8. `sensor`: Sensores físicos (DHT22, SHT31-D, Capacitivo v1.2, BH1750, SCD30).
9. `actuador`: Dispositivos de control (Extractores, Bombas de riego, Lámparas LED).
10. `lectura`: **Histórico completo de telemetría IoT**.
11. `lectura_actual`: Caché de alta velocidad con la última lectura por sensor.
12. `alerta`: Disparador de eventos cuando una variable sale de los umbrales seguros.
13. `comando_actuador`: Auditoría de órdenes enviadas a actuadores (manual o automático).

### Scripts SQL Incluidos:
* [`supabase_01_create_database.sql`](./supabase_01_create_database.sql): DDL completo con tipos ENUM personalizados, llaves foráneas, índices y constraints.
* [`supabase_02_seed_data.sql`](./supabase_02_seed_data.sql): Carga de datos iniciales, calibraciones y mediciones de prueba.

---

## ⚙️ Backend en PHP
El backend está desarrollado en **PHP 8** y se conecta a Supabase mediante **PDO (PostgreSQL)** con cifrado SSL.

### Estructura del Backend:
```
backend/
├── config/
│   └── db.php          # Singleton de conexión PDO a Supabase
├── api/
│   └── dashboard.php   # Endpoint REST que retorna lecturas, alertas y actuadores en JSON
└── test_db.php         # Script CLI para verificar conectividad con Supabase
```

### Probar la API localmente:
Puedes levantar un servidor de pruebas de PHP con el comando:
```bash
php -S localhost:8000 -t backend/api
```
Y acceder a `http://localhost:8000/dashboard.php`.

---

## 📄 Documentación Adjunta
* [`DIAGRAMA ENTIDAD RELACIÓN.pdf`](./DIAGRAMA%20ENTIDAD%20RELACIÓN.pdf): Diagrama conceptual y relacional completo.
* [`EDTS BD.pdf`](./EDTS%20BD.pdf): Estructura de Desglose de Trabajo (EDT).
* [`Reporte de metodología_Base de Datos (2).pdf`](./Reporte%20de%20metodología_Base%20de%20Datos%20(2).pdf): Justificación, alcance y metodología técnica.
