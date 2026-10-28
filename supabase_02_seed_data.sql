-- ============================================================
--  PROYECTO INVERNADERO — DATOS DE PRUEBA (SEED DATA) PARA SUPABASE
--  Cultivo: Jitomate Cherry (Solanum lycopersicum var. cerasiforme)
--  Equipo BD: Cesar Oswaldo Medina Ornelas (Líder), Iker Razo, Jazmin Velazquez, Viviana López, Susana Soforo
--  Institución: Universidad Tecnológica de Querétaro (UTEQ)
-- ============================================================

-- Limpieza previa opcional en cascada
TRUNCATE TABLE comando_actuador, alerta, lectura_actual, lectura, actuador, sensor, dispositivo, umbral, zona, cultivo, magnitud, usuario, grupo RESTART IDENTITY CASCADE;

-- ============================================================
-- 1. GRUPO
-- ============================================================
INSERT INTO grupo (id, nombre, descripcion, creado_por, creado_en)
VALUES (1, 'Invernadero Inteligente UTEQ', 'Invernadero automatizado con IoT dedicado al cultivo y monitoreo de Jitomate Cherry', NULL, NOW());

-- ============================================================
-- 2. USUARIOS
-- ============================================================
INSERT INTO usuario (id, grupo_id, nombre, correo, password_hash, rol, activo, creado_por) VALUES
(1, 1, 'Cesar Oswaldo Medina Ornelas',   'cesar.medina@uteq.edu.mx',    '$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'admin',    TRUE, 1),
(2, 1, 'Iker Aarón Razo Roa',             'iker.razo@uteq.edu.mx',       '$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'operador', TRUE, 1),
(3, 1, 'Jazmin Velazquez Cruz',            'jazmin.velazquez@uteq.edu.mx','$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'operador', TRUE, 1),
(4, 1, 'Viviana López Álvarez',            'viviana.lopez@uteq.edu.mx',   '$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'operador', TRUE, 1),
(5, 1, 'Susana Elizabeth Soforo Medrano',  'susana.soforo@uteq.edu.mx',   '$2y$10$wT8fH2p5vM9xK7.3qLmNNeRzE6hYJq8gK3kP2d1x4z9y8v7u6t5s4', 'operador', TRUE, 1);

-- Actualizar auditoría del grupo con el admin creado
UPDATE grupo SET creado_por = 1 WHERE id = 1;

-- ============================================================
-- 3. MAGNITUDES
-- ============================================================
INSERT INTO magnitud (id, codigo, nombre, unidad, rango_min, rango_max, creado_por) VALUES
(1, 'TEMP',       'Temperatura Ambiente',      '°C',   0.00,  50.00, 1),
(2, 'HUM_AMB',    'Humedad Relativa Ambiente', '%',    0.00, 100.00, 1),
(3, 'HUM_SUELO',  'Humedad del Sustrato',      '%',    0.00, 100.00, 1),
(4, 'LUZ',        'Iluminancia / Radiación',   'lux',  0.00, 100000.00, 1),
(5, 'CO2',        'Dióxido de Carbono',        'ppm',  300.00, 2500.00, 1);

-- ============================================================
-- 4. CULTIVO
-- ============================================================
INSERT INTO cultivo (id, grupo_id, nombre, creado_por) VALUES
(1, 1, 'Jitomate Cherry (Solanum lycopersicum var. cerasiforme)', 1);

-- ============================================================
-- 5. ZONAS
-- ============================================================
INSERT INTO zona (id, grupo_id, cultivo_id, nombre, creado_por) VALUES
(1, 1, 1, 'Zona Norte - Crecimiento Vegetativo Cherry', 1),
(2, 1, 1, 'Zona Sur - Floración y Fructificación Cherry', 1);

-- ============================================================
-- 6. UMBRALES
-- ============================================================
INSERT INTO umbral (cultivo_id, magnitud_id, grupo_id, minimo, maximo, creado_por) VALUES
(1, 1, 1, 18.00,    28.00, 1),
(1, 2, 1, 60.00,    80.00, 1),
(1, 3, 1, 65.00,    85.00, 1),
(1, 4, 1, 15000.00, 65000.00, 1),
(1, 5, 1, 500.00,   1200.00, 1);

-- ============================================================
-- 7. DISPOSITIVOS (Nodos ESP32)
-- ============================================================
INSERT INTO dispositivo (id, grupo_id, zona_id, nombre, mac, api_key_hash, intervalo_seg, estado, ultima_conexion, creado_por) VALUES
(1, 1, 1, 'ESP32 - Nodo Zona Norte', '24:6F:28:AB:CD:01', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 30, 'activo', NOW(), 1),
(2, 1, 2, 'ESP32 - Nodo Zona Sur',   '24:6F:28:AB:CD:02', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 30, 'activo', NOW(), 1);

-- ============================================================
-- 8. SENSORES
-- ============================================================
INSERT INTO sensor (id, grupo_id, dispositivo_id, magnitud_id, codigo, modelo, cal_seco, cal_mojado, activo, creado_por) VALUES
(1, 1, 1, 1, 'SENS_TEMP_ZN',  'DHT22 / AM2302',  0,    0,    TRUE, 1),
(2, 1, 1, 2, 'SENS_HUM_ZN',   'DHT22 / AM2302',  0,    0,    TRUE, 1),
(3, 1, 1, 3, 'SENS_SUELO_ZN', 'Capacitivo v1.2', 3200, 1400, TRUE, 1),
(4, 1, 1, 4, 'SENS_LUZ_ZN',   'BH1750',          0,    0,    TRUE, 1),
(5, 1, 2, 1, 'SENS_TEMP_ZS',  'SHT31-D',         0,    0,    TRUE, 1),
(6, 1, 2, 2, 'SENS_HUM_ZS',   'SHT31-D',         0,    0,    TRUE, 1),
(7, 1, 2, 3, 'SENS_SUELO_ZS', 'Capacitivo v1.2', 3200, 1400, TRUE, 1),
(8, 1, 2, 5, 'SENS_CO2_ZS',   'SCD30 NDIR',      0,    0,    TRUE, 1);

-- ============================================================
-- 9. ACTUADORES
-- ============================================================
INSERT INTO actuador (id, grupo_id, dispositivo_id, tipo, nombre, estado, creado_por) VALUES
(1, 1, 1, 'bomba',      'Bomba de Riego por Goteo Zona Norte',  'apagado',   1),
(2, 1, 1, 'ventilador', 'Extractor de Aire Caliente Norte',     'apagado',   1),
(3, 1, 2, 'bomba',      'Bomba de Fertirriego Zona Sur',        'apagado',   1),
(4, 1, 2, 'ventilador', 'Ventilador de Recirculación Sur',      'encendido', 1),
(5, 1, 2, 'lampara',    'Lámpara LED Grow Light Fructificación','apagado',   1);

-- ============================================================
-- 10. LECTURAS
-- ============================================================
INSERT INTO lectura (grupo_id, sensor_id, valor, fecha_hora, creado_por) VALUES
-- Mediciones hace 2 horas (Zona Norte)
(1, 1, 22.50, NOW() - INTERVAL '120 minutes', NULL),
(1, 2, 68.20, NOW() - INTERVAL '120 minutes', NULL),
(1, 3, 74.00, NOW() - INTERVAL '120 minutes', NULL),
(1, 4, 32000.00, NOW() - INTERVAL '120 minutes', NULL),

-- Mediciones hace 1 hora (Zona Norte)
(1, 1, 24.10, NOW() - INTERVAL '60 minutes', NULL),
(1, 2, 66.50, NOW() - INTERVAL '60 minutes', NULL),
(1, 3, 72.80, NOW() - INTERVAL '60 minutes', NULL),
(1, 4, 45000.00, NOW() - INTERVAL '60 minutes', NULL),

-- Mediciones hace 30 minutos (Zona Sur)
(1, 5, 26.80, NOW() - INTERVAL '30 minutes', NULL),
(1, 6, 64.00, NOW() - INTERVAL '30 minutes', NULL),
(1, 7, 70.50, NOW() - INTERVAL '30 minutes', NULL),
(1, 8, 750.00, NOW() - INTERVAL '30 minutes', NULL),

-- Pico de temperatura reciente en Zona Sur (provoca alerta de prueba: 29.5°C > máx 28.0°C)
(1, 5, 29.50, NOW() - INTERVAL '10 minutes', NULL),
(1, 6, 58.50, NOW() - INTERVAL '10 minutes', NULL),

-- Mediciones actuales normales (hace 2 minutos)
(1, 1, 23.80, NOW() - INTERVAL '2 minutes', NULL),
(1, 2, 67.40, NOW() - INTERVAL '2 minutes', NULL),
(1, 3, 73.10, NOW() - INTERVAL '2 minutes', NULL),
(1, 4, 41200.00, NOW() - INTERVAL '2 minutes', NULL),
(1, 5, 27.20, NOW() - INTERVAL '2 minutes', NULL),
(1, 6, 63.80, NOW() - INTERVAL '2 minutes', NULL),
(1, 7, 71.20, NOW() - INTERVAL '2 minutes', NULL),
(1, 8, 720.00, NOW() - INTERVAL '2 minutes', NULL);

-- ============================================================
-- 11. LECTURA_ACTUAL (Caché por sensor)
-- ============================================================
INSERT INTO lectura_actual (sensor_id, grupo_id, valor, fecha_hora, creado_por) VALUES
(1, 1, 23.80,    NOW() - INTERVAL '2 minutes', 1),
(2, 1, 67.40,    NOW() - INTERVAL '2 minutes', 1),
(3, 1, 73.10,    NOW() - INTERVAL '2 minutes', 1),
(4, 1, 41200.00, NOW() - INTERVAL '2 minutes', 1),
(5, 1, 27.20,    NOW() - INTERVAL '2 minutes', 1),
(6, 1, 63.80,    NOW() - INTERVAL '2 minutes', 1),
(7, 1, 71.20,    NOW() - INTERVAL '2 minutes', 1),
(8, 1, 720.00,   NOW() - INTERVAL '2 minutes', 1);

-- ============================================================
-- 12. ALERTA
-- ============================================================
INSERT INTO alerta (id, grupo_id, zona_id, sensor_id, atendida_por, tipo, nivel, valor, limite, mensaje, fecha_hora, atendida, atendida_en, creado_por) VALUES
(1, 1, 2, 5, 1, 'maximo', 'alto', 29.50, 28.00, 
 'Temperatura alta en Zona Sur Cherry: 29.50°C supera el límite máximo permitido de 28.00°C', 
 NOW() - INTERVAL '10 minutes', TRUE, NOW() - INTERVAL '5 minutes', 1);

-- ============================================================
-- 13. COMANDO_ACTUADOR
-- ============================================================
INSERT INTO comando_actuador (id, grupo_id, usuario_id, actuador_id, accion, duracion_seg, origen, estado, confirmado_en, creado_por) VALUES
(1, 1, 1, 4, 'encender', 600, 'automatico', 'ejecutado', NOW() - INTERVAL '9 minutes', 1);

-- ============================================================
-- REAJUSTAR SECUENCIAS AUTOINCREMENTALES
-- ============================================================
SELECT setval(pg_get_serial_sequence('grupo', 'id'), COALESCE(MAX(id), 1)) FROM grupo;
SELECT setval(pg_get_serial_sequence('usuario', 'id'), COALESCE(MAX(id), 1)) FROM usuario;
SELECT setval(pg_get_serial_sequence('magnitud', 'id'), COALESCE(MAX(id), 1)) FROM magnitud;
SELECT setval(pg_get_serial_sequence('cultivo', 'id'), COALESCE(MAX(id), 1)) FROM cultivo;
SELECT setval(pg_get_serial_sequence('zona', 'id'), COALESCE(MAX(id), 1)) FROM zona;
SELECT setval(pg_get_serial_sequence('dispositivo', 'id'), COALESCE(MAX(id), 1)) FROM dispositivo;
SELECT setval(pg_get_serial_sequence('sensor', 'id'), COALESCE(MAX(id), 1)) FROM sensor;
SELECT setval(pg_get_serial_sequence('actuador', 'id'), COALESCE(MAX(id), 1)) FROM actuador;
SELECT setval(pg_get_serial_sequence('lectura', 'id'), COALESCE(MAX(id), 1)) FROM lectura;
SELECT setval(pg_get_serial_sequence('alerta', 'id'), COALESCE(MAX(id), 1)) FROM alerta;
SELECT setval(pg_get_serial_sequence('comando_actuador', 'id'), COALESCE(MAX(id), 1)) FROM comando_actuador;
