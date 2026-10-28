-- ============================================================
--  PROYECTO INVERNADERO — DATOS DE PRUEBA (SEED DATA)
--  Cultivo Principal: Jitomate Cherry (Solanum lycopersicum var. cerasiforme)
--  Equipo BD (UTEQ):
--    - Cesar Oswaldo Medina Ornelas (Líder)
--    - Iker Aarón Razo Roa
--    - Jazmin Velazquez Cruz
--    - Viviana López Álvarez
--    - Susana Elizabeth Soforo Medrano
-- ============================================================

USE invernadero_db;

-- Desactivar temporalmente revisión de llaves foráneas para reinicio limpio
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM comando_actuador;
DELETE FROM alerta;
DELETE FROM lectura_actual;
DELETE FROM lectura;
DELETE FROM actuador;
DELETE FROM sensor;
DELETE FROM dispositivo;
DELETE FROM umbral;
DELETE FROM zona;
DELETE FROM cultivo;
DELETE FROM magnitud;
DELETE FROM usuario;
DELETE FROM grupo;

-- Reiniciar contadores autoincrementables
ALTER TABLE grupo AUTO_INCREMENT = 1;
ALTER TABLE usuario AUTO_INCREMENT = 1;
ALTER TABLE magnitud AUTO_INCREMENT = 1;
ALTER TABLE cultivo AUTO_INCREMENT = 1;
ALTER TABLE zona AUTO_INCREMENT = 1;
ALTER TABLE dispositivo AUTO_INCREMENT = 1;
ALTER TABLE sensor AUTO_INCREMENT = 1;
ALTER TABLE actuador AUTO_INCREMENT = 1;
ALTER TABLE lectura AUTO_INCREMENT = 1;
ALTER TABLE alerta AUTO_INCREMENT = 1;
ALTER TABLE comando_actuador AUTO_INCREMENT = 1;

-- ============================================================
-- 1. GRUPO (Organización raíz del invernadero)
-- ============================================================
INSERT INTO grupo (id, nombre, descripcion, creado_por, creado_en)
VALUES (1, 'Invernadero Inteligente UTEQ', 'Invernadero automatizado con IoT dedicado al cultivo y monitoreo de Jitomate Cherry', NULL, NOW());

-- ============================================================
-- 2. USUARIOS (Integrantes del equipo de BD y roles)
-- Password genérico cifrado (bcrypt de 'Password123!')
-- ============================================================
INSERT INTO usuario (id, grupo_id, nombre, correo, password_hash, rol, activo, creado_por) VALUES
(1, 1, 'Cesar Oswaldo Medina Ornelas', 'cesar.medina@uteq.edu.mx', '$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'admin', 1, 1),
(2, 1, 'Iker Aarón Razo Roa',           'iker.razo@uteq.edu.mx',     '$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'operador', 1, 1),
(3, 1, 'Jazmin Velazquez Cruz',          'jazmin.velazquez@uteq.edu.mx','$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'operador', 1, 1),
(4, 1, 'Viviana López Álvarez',          'viviana.lopez@uteq.edu.mx', '$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'operador', 1, 1),
(5, 1, 'Susana Elizabeth Soforo Medrano','susana.soforo@uteq.edu.mx', '$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'operador', 1, 1);

-- ============================================================
-- 3. MAGNITUDES (Variables ambientales críticas para Jitomate)
-- ============================================================
INSERT INTO magnitud (id, codigo, nombre, unidad, rango_min, rango_max, creado_por) VALUES
(1, 'TEMP',       'Temperatura Ambiente',      '°C',   0.00,  50.00, 1),
(2, 'HUM_AMB',    'Humedad Relativa Ambiente', '%',    0.00, 100.00, 1),
(3, 'HUM_SUELO',  'Humedad del Sustrato',      '%',    0.00, 100.00, 1),
(4, 'LUZ',        'Iluminancia / Radiación',   'lux',  0.00, 100000.00, 1),
(5, 'CO2',        'Dióxido de Carbono',        'ppm',  300.00, 2500.00, 1);

-- ============================================================
-- 4. CULTIVO (Jitomate Cherry)
-- ============================================================
INSERT INTO cultivo (id, grupo_id, nombre, creado_por) VALUES
(1, 1, 'Jitomate Cherry (Solanum lycopersicum var. cerasiforme)', 1);

-- ============================================================
-- 5. ZONAS (Áreas físicas dentro del invernadero)
-- ============================================================
INSERT INTO zona (id, grupo_id, cultivo_id, nombre, creado_por) VALUES
(1, 1, 1, 'Zona Norte - Crecimiento Vegetativo Cherry', 1),
(2, 1, 1, 'Zona Sur - Floración y Fructificación Cherry', 1);

-- ============================================================
-- 6. UMBRALES (Parámetros agronómicos reales para Jitomate Cherry)
-- Temperatura óptima: 18°C a 28°C
-- Humedad óptima: 60% a 80%
-- Humedad sustrato: 65% a 85%
-- Luz óptima: 15,000 a 65,000 lux
-- CO2 óptimo: 500 a 1,200 ppm
-- ============================================================
INSERT INTO umbral (cultivo_id, magnitud_id, grupo_id, minimo, maximo, creado_por) VALUES
(1, 1, 1, 18.00,    28.00, 1),  -- Temp (°C)
(1, 2, 1, 60.00,    80.00, 1),  -- Humedad ambiente (%)
(1, 3, 1, 65.00,    85.00, 1),  -- Humedad de suelo (%)
(1, 4, 1, 15000.00, 65000.00, 1), -- Luz (lux)
(1, 5, 1, 500.00,   1200.00, 1); -- CO2 (ppm)

-- ============================================================
-- 7. DISPOSITIVOS (Microcontroladores IoT ESP32)
-- ============================================================
INSERT INTO dispositivo (id, grupo_id, zona_id, nombre, mac, api_key_hash, intervalo_seg, estado, ultima_conexion, creado_por) VALUES
(1, 1, 1, 'ESP32 - Nodo Zona Norte', '24:6F:28:AB:CD:01', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 30, 'activo', NOW(), 1),
(2, 1, 2, 'ESP32 - Nodo Zona Sur',   '24:6F:28:AB:CD:02', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 30, 'activo', NOW(), 1);

-- ============================================================
-- 8. SENSORES (Sensores conectados a los ESP32)
-- ============================================================
INSERT INTO sensor (id, grupo_id, dispositivo_id, magnitud_id, codigo, modelo, cal_seco, cal_mojado, activo, creado_por) VALUES
-- Sensores en Nodo Zona Norte
(1, 1, 1, 1, 'SENS_TEMP_ZN',  'DHT22 / AM2302',  0,    0,    1, 1),
(2, 1, 1, 2, 'SENS_HUM_ZN',   'DHT22 / AM2302',  0,    0,    1, 1),
(3, 1, 1, 3, 'SENS_SUELO_ZN', 'Capacitivo v1.2', 3200, 1400, 1, 1),
(4, 1, 1, 4, 'SENS_LUZ_ZN',   'BH1750',          0,    0,    1, 1),
-- Sensores en Nodo Zona Sur
(5, 1, 2, 1, 'SENS_TEMP_ZS',  'SHT31-D',         0,    0,    1, 1),
(6, 1, 2, 2, 'SENS_HUM_ZS',   'SHT31-D',         0,    0,    1, 1),
(7, 1, 2, 3, 'SENS_SUELO_ZS', 'Capacitivo v1.2', 3200, 1400, 1, 1),
(8, 1, 2, 5, 'SENS_CO2_ZS',   'SCD30 NDIR',      0,    0,    1, 1);

-- ============================================================
-- 9. ACTUADORES (Control de clima y riego para Jitomate)
-- ============================================================
INSERT INTO actuador (id, grupo_id, dispositivo_id, tipo, nombre, estado, creado_por) VALUES
(1, 1, 1, 'bomba',      'Bomba de Riego por Goteo Zona Norte', 'apagado',   1),
(2, 1, 1, 'ventilador', 'Extractor de Aire Caliente Norte',    'apagado',   1),
(3, 1, 2, 'bomba',      'Bomba de Fertirriego Zona Sur',       'apagado',   1),
(4, 1, 2, 'ventilador', 'Ventilador de Recirculación Sur',     'encendido', 1),
(5, 1, 2, 'lampara',    'Lámpara LED Grow Light Fructificación','apagado',  1);

-- ============================================================
-- 10. LECTURAS (Historial de mediciones realistas de las últimas horas)
-- ============================================================
INSERT INTO lectura (grupo_id, sensor_id, valor, fecha_hora, creado_por) VALUES
-- Mediciones hace 2 horas (Zona Norte)
(1, 1, 22.50, DATE_SUB(NOW(), INTERVAL 120 MINUTE), NULL),
(1, 2, 68.20, DATE_SUB(NOW(), INTERVAL 120 MINUTE), NULL),
(1, 3, 74.00, DATE_SUB(NOW(), INTERVAL 120 MINUTE), NULL),
(1, 4, 32000.00, DATE_SUB(NOW(), INTERVAL 120 MINUTE), NULL),

-- Mediciones hace 1 hora (Zona Norte)
(1, 1, 24.10, DATE_SUB(NOW(), INTERVAL 60 MINUTE), NULL),
(1, 2, 66.50, DATE_SUB(NOW(), INTERVAL 60 MINUTE), NULL),
(1, 3, 72.80, DATE_SUB(NOW(), INTERVAL 60 MINUTE), NULL),
(1, 4, 45000.00, DATE_SUB(NOW(), INTERVAL 60 MINUTE), NULL),

-- Mediciones hace 30 minutos (Zona Sur)
(1, 5, 26.80, DATE_SUB(NOW(), INTERVAL 30 MINUTE), NULL),
(1, 6, 64.00, DATE_SUB(NOW(), INTERVAL 30 MINUTE), NULL),
(1, 7, 70.50, DATE_SUB(NOW(), INTERVAL 30 MINUTE), NULL),
(1, 8, 750.00, DATE_SUB(NOW(), INTERVAL 30 MINUTE), NULL),

-- Pico de temperatura reciente en Zona Sur (provoca alerta de prueba: 29.5°C > máx 28.0°C)
(1, 5, 29.50, DATE_SUB(NOW(), INTERVAL 10 MINUTE), NULL),
(1, 6, 58.50, DATE_SUB(NOW(), INTERVAL 10 MINUTE), NULL),

-- Mediciones actuales normales (hace 2 minutos)
(1, 1, 23.80, DATE_SUB(NOW(), INTERVAL 2 MINUTE), NULL),
(1, 2, 67.40, DATE_SUB(NOW(), INTERVAL 2 MINUTE), NULL),
(1, 3, 73.10, DATE_SUB(NOW(), INTERVAL 2 MINUTE), NULL),
(1, 4, 41200.00, DATE_SUB(NOW(), INTERVAL 2 MINUTE), NULL),
(1, 5, 27.20, DATE_SUB(NOW(), INTERVAL 2 MINUTE), NULL),
(1, 6, 63.80, DATE_SUB(NOW(), INTERVAL 2 MINUTE), NULL),
(1, 7, 71.20, DATE_SUB(NOW(), INTERVAL 2 MINUTE), NULL),
(1, 8, 720.00, DATE_SUB(NOW(), INTERVAL 2 MINUTE), NULL);

-- ============================================================
-- 11. LECTURA_ACTUAL (Caché rápida de la última medición por sensor)
-- ============================================================
INSERT INTO lectura_actual (sensor_id, grupo_id, valor, fecha_hora, creado_por) VALUES
(1, 1, 23.80,    DATE_SUB(NOW(), INTERVAL 2 MINUTE), 1), -- Temp Norte
(2, 1, 67.40,    DATE_SUB(NOW(), INTERVAL 2 MINUTE), 1), -- Humedad Norte
(3, 1, 73.10,    DATE_SUB(NOW(), INTERVAL 2 MINUTE), 1), -- Suelo Norte
(4, 1, 41200.00, DATE_SUB(NOW(), INTERVAL 2 MINUTE), 1), -- Luz Norte
(5, 1, 27.20,    DATE_SUB(NOW(), INTERVAL 2 MINUTE), 1), -- Temp Sur
(6, 1, 63.80,    DATE_SUB(NOW(), INTERVAL 2 MINUTE), 1), -- Humedad Sur
(7, 1, 71.20,    DATE_SUB(NOW(), INTERVAL 2 MINUTE), 1), -- Suelo Sur
(8, 1, 720.00,   DATE_SUB(NOW(), INTERVAL 2 MINUTE), 1); -- CO2 Sur

-- ============================================================
-- 12. ALERTA (Alerta de prueba cuando la temperatura subió a 29.5°C)
-- ============================================================
INSERT INTO alerta (id, grupo_id, zona_id, sensor_id, atendida_por, tipo, nivel, valor, limite, mensaje, fecha_hora, atendida, atendida_en, creado_por) VALUES
(1, 1, 2, 5, 1, 'maximo', 'alto', 29.50, 28.00, 
 'Temperatura alta en Zona Sur Cherry: 29.50°C supera el límite máximo permitido de 28.00°C', 
 DATE_SUB(NOW(), INTERVAL 10 MINUTE), 1, DATE_SUB(NOW(), INTERVAL 5 MINUTE), 1);

-- ============================================================
-- 13. COMANDO_ACTUADOR (Acción preventiva activada por la alerta)
-- ============================================================
INSERT INTO comando_actuador (id, grupo_id, usuario_id, actuador_id, accion, duracion_seg, origen, estado, confirmado_en, creado_por) VALUES
(1, 1, 1, 4, 'encender', 600, 'automatico', 'ejecutado', DATE_SUB(NOW(), INTERVAL 9 MINUTE), 1);

-- Reactivar revisión de llaves foráneas
SET FOREIGN_KEY_CHECKS = 1;
