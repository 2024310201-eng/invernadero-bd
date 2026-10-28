-- ============================================================
--  PROYECTO INVERNADERO — Base de Datos COMPLETA
--  Equipo BD: 
--    - Cesar Oswaldo Medina Ornelas (Líder)
--    - Iker Aarón Razo Roa
--    - Jazmin Velazquez Cruz
--    - Viviana López Álvarez
--    - Susana Elizabeth Soforo Medrano
--  Institución: Universidad Tecnológica de Querétaro (UTEQ)
--  Fecha: Octubre 2026
--  Tablas: 13 (exactamente según el Diagrama ER)
-- ============================================================

CREATE DATABASE IF NOT EXISTS invernadero_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE invernadero_db;

-- ============================================================
-- TABLA 1: grupo
-- Organización/tenant raíz — referenciada por casi todas las tablas
-- ============================================================
CREATE TABLE IF NOT EXISTS grupo (
    id          INT          NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(45)  NOT NULL,
    descripcion VARCHAR(200),
    creado_por  INT,
    creado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por INT,
    editado_en  DATETIME,
    eliminado   BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 2: usuario
-- Usuarios del sistema (admin, operador, etc.)
-- ============================================================
CREATE TABLE IF NOT EXISTS usuario (
    id            INT           NOT NULL AUTO_INCREMENT,
    grupo_id      INT           NOT NULL,
    nombre        VARCHAR(30)   NOT NULL,
    correo        VARCHAR(120)  NOT NULL,
    password_hash VARCHAR(255)  NOT NULL,
    rol           ENUM('admin','operador','visor') NOT NULL DEFAULT 'visor',
    activo        BOOLEAN       NOT NULL DEFAULT TRUE,
    creado_por    INT,
    creado_en     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por   INT,
    editado_en    DATETIME,
    eliminado     BOOLEAN       NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    UNIQUE KEY uq_usuario_correo (correo),
    CONSTRAINT fk_usuario_grupo FOREIGN KEY (grupo_id) REFERENCES grupo(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 3: magnitud
-- Tipos de medición: temperatura, humedad, CO2, etc.
-- ============================================================
CREATE TABLE IF NOT EXISTS magnitud (
    id          INT          NOT NULL AUTO_INCREMENT,
    codigo      VARCHAR(30)  NOT NULL,
    nombre      VARCHAR(80)  NOT NULL,
    unidad      VARCHAR(16)  NOT NULL,
    rango_min   DECIMAL(8,2),
    rango_max   DECIMAL(8,2),
    creado_por  INT,
    creado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por INT,
    editado_en  DATETIME,
    eliminado   BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    UNIQUE KEY uq_magnitud_codigo (codigo),
    CONSTRAINT fk_magnitud_creado_por  FOREIGN KEY (creado_por)  REFERENCES usuario(id),
    CONSTRAINT fk_magnitud_editado_por FOREIGN KEY (editado_por) REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 4: cultivo
-- Tipos de cultivo administrados en el invernadero
-- ============================================================
CREATE TABLE IF NOT EXISTS cultivo (
    id          INT          NOT NULL AUTO_INCREMENT,
    grupo_id    INT          NOT NULL,
    nombre      VARCHAR(80)  NOT NULL,
    creado_por  INT,
    creado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por INT,
    editado_en  DATETIME,
    eliminado   BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    CONSTRAINT fk_cultivo_grupo      FOREIGN KEY (grupo_id)   REFERENCES grupo(id),
    CONSTRAINT fk_cultivo_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id),
    CONSTRAINT fk_cultivo_editado_por FOREIGN KEY (editado_por) REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 5: zona
-- Zonas físicas del invernadero
-- ============================================================
CREATE TABLE IF NOT EXISTS zona (
    id          INT          NOT NULL AUTO_INCREMENT,
    grupo_id    INT          NOT NULL,
    cultivo_id  INT,
    nombre      VARCHAR(80)  NOT NULL,
    creado_por  INT,
    creado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por INT,
    editado_en  DATETIME,
    eliminado   BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    CONSTRAINT fk_zona_grupo       FOREIGN KEY (grupo_id)   REFERENCES grupo(id),
    CONSTRAINT fk_zona_cultivo     FOREIGN KEY (cultivo_id) REFERENCES cultivo(id),
    CONSTRAINT fk_zona_creado_por  FOREIGN KEY (creado_por) REFERENCES usuario(id),
    CONSTRAINT fk_zona_editado_por FOREIGN KEY (editado_por) REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 6: umbral
-- Límites mín/máx por cultivo y magnitud
-- PK compuesta: cultivo_id + magnitud_id
-- ============================================================
CREATE TABLE IF NOT EXISTS umbral (
    cultivo_id  INT          NOT NULL,
    magnitud_id INT          NOT NULL,
    grupo_id    INT          NOT NULL,
    minimo      DECIMAL(8,2) NOT NULL,
    maximo      DECIMAL(8,2) NOT NULL,
    creado_por  INT,
    creado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por INT,
    editado_en  DATETIME,
    eliminado   BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (cultivo_id, magnitud_id),
    CONSTRAINT fk_umbral_cultivo     FOREIGN KEY (cultivo_id)  REFERENCES cultivo(id),
    CONSTRAINT fk_umbral_magnitud    FOREIGN KEY (magnitud_id) REFERENCES magnitud(id),
    CONSTRAINT fk_umbral_grupo       FOREIGN KEY (grupo_id)    REFERENCES grupo(id),
    CONSTRAINT fk_umbral_creado_por  FOREIGN KEY (creado_por)  REFERENCES usuario(id),
    CONSTRAINT fk_umbral_editado_por FOREIGN KEY (editado_por) REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 7: dispositivo
-- Hardware IoT (ESP32, Raspberry Pi, etc.)
-- ============================================================
CREATE TABLE IF NOT EXISTS dispositivo (
    id              INT          NOT NULL AUTO_INCREMENT,
    grupo_id        INT          NOT NULL,
    zona_id         INT,
    nombre          VARCHAR(80)  NOT NULL,
    mac             VARCHAR(17)  NOT NULL,
    api_key_hash    CHAR(64),
    intervalo_seg   INT          NOT NULL DEFAULT 30,
    estado          ENUM('activo','inactivo','error') NOT NULL DEFAULT 'activo',
    ultima_conexion DATETIME,
    creado_por      INT,
    creado_en       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por     INT,
    editado_en      DATETIME,
    eliminado       BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    UNIQUE KEY uq_dispositivo_mac (mac),
    CONSTRAINT fk_dispositivo_grupo       FOREIGN KEY (grupo_id)   REFERENCES grupo(id),
    CONSTRAINT fk_dispositivo_zona        FOREIGN KEY (zona_id)    REFERENCES zona(id),
    CONSTRAINT fk_dispositivo_creado_por  FOREIGN KEY (creado_por) REFERENCES usuario(id),
    CONSTRAINT fk_dispositivo_editado_por FOREIGN KEY (editado_por) REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 8: sensor
-- Sensores físicos conectados a un dispositivo IoT
-- ============================================================
CREATE TABLE IF NOT EXISTS sensor (
    id             INT          NOT NULL AUTO_INCREMENT,
    grupo_id       INT          NOT NULL,
    dispositivo_id INT          NOT NULL,
    magnitud_id    INT          NOT NULL,
    codigo         VARCHAR(30)  NOT NULL,
    modelo         VARCHAR(40),
    cal_seco       INT          DEFAULT 0,
    cal_mojado     INT          DEFAULT 1023,
    activo         BOOLEAN      NOT NULL DEFAULT TRUE,
    creado_por     INT,
    creado_en      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por    INT,
    editado_en     DATETIME,
    eliminado      BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    UNIQUE KEY uq_sensor_codigo (codigo),
    CONSTRAINT fk_sensor_grupo        FOREIGN KEY (grupo_id)       REFERENCES grupo(id),
    CONSTRAINT fk_sensor_dispositivo  FOREIGN KEY (dispositivo_id) REFERENCES dispositivo(id),
    CONSTRAINT fk_sensor_magnitud     FOREIGN KEY (magnitud_id)    REFERENCES magnitud(id),
    CONSTRAINT fk_sensor_creado_por   FOREIGN KEY (creado_por)     REFERENCES usuario(id),
    CONSTRAINT fk_sensor_editado_por  FOREIGN KEY (editado_por)    REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 9: actuador
-- Actuadores: bomba, ventilador, calefactor, etc.
-- ============================================================
CREATE TABLE IF NOT EXISTS actuador (
    id             INT          NOT NULL AUTO_INCREMENT,
    grupo_id       INT          NOT NULL,
    dispositivo_id INT          NOT NULL,
    tipo           ENUM('bomba','ventilador','calefactor','lampara','otro') NOT NULL,
    nombre         VARCHAR(80)  NOT NULL,
    estado         ENUM('encendido','apagado','error') NOT NULL DEFAULT 'apagado',
    creado_por     INT,
    creado_en      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por    INT,
    editado_en     DATETIME,
    eliminado      BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    CONSTRAINT fk_actuador_grupo        FOREIGN KEY (grupo_id)       REFERENCES grupo(id),
    CONSTRAINT fk_actuador_dispositivo  FOREIGN KEY (dispositivo_id) REFERENCES dispositivo(id),
    CONSTRAINT fk_actuador_creado_por   FOREIGN KEY (creado_por)     REFERENCES usuario(id),
    CONSTRAINT fk_actuador_editado_por  FOREIGN KEY (editado_por)    REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 10: lectura  ⭐ MÁS IMPORTANTE DEL PROYECTO
-- Histórico completo de lecturas de todos los sensores
-- ============================================================
CREATE TABLE IF NOT EXISTS lectura (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    grupo_id    INT          NOT NULL,
    sensor_id   INT          NOT NULL,
    valor       DECIMAL(8,2) NOT NULL,
    fecha_hora  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por  INT,
    creado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por INT,
    editado_en  DATETIME,
    eliminado   BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    INDEX idx_lectura_sensor    (sensor_id),
    INDEX idx_lectura_fecha     (fecha_hora),
    INDEX idx_lectura_grupo     (grupo_id),
    CONSTRAINT fk_lectura_grupo       FOREIGN KEY (grupo_id)  REFERENCES grupo(id),
    CONSTRAINT fk_lectura_sensor      FOREIGN KEY (sensor_id) REFERENCES sensor(id),
    CONSTRAINT fk_lectura_creado_por  FOREIGN KEY (creado_por)  REFERENCES usuario(id),
    CONSTRAINT fk_lectura_editado_por FOREIGN KEY (editado_por) REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 11: lectura_actual
-- Última lectura por sensor (caché — una fila por sensor)
-- PK = sensor_id
-- ============================================================
CREATE TABLE IF NOT EXISTS lectura_actual (
    sensor_id   INT          NOT NULL,
    grupo_id    INT          NOT NULL,
    valor       DECIMAL(8,2) NOT NULL,
    fecha_hora  DATETIME     NOT NULL,
    creado_por  INT,
    creado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por INT,
    editado_en  DATETIME,
    eliminado   BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (sensor_id),
    CONSTRAINT fk_lact_sensor      FOREIGN KEY (sensor_id)  REFERENCES sensor(id),
    CONSTRAINT fk_lact_grupo       FOREIGN KEY (grupo_id)   REFERENCES grupo(id),
    CONSTRAINT fk_lact_creado_por  FOREIGN KEY (creado_por) REFERENCES usuario(id),
    CONSTRAINT fk_lact_editado_por FOREIGN KEY (editado_por) REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 12: alerta
-- Alertas cuando un sensor supera un umbral min/max
-- ============================================================
CREATE TABLE IF NOT EXISTS alerta (
    id           BIGINT       NOT NULL AUTO_INCREMENT,
    grupo_id     INT          NOT NULL,
    zona_id      INT,
    sensor_id    INT          NOT NULL,
    atendida_por INT,
    tipo         ENUM('minimo','maximo') NOT NULL,
    nivel        ENUM('bajo','medio','alto','critico') NOT NULL DEFAULT 'medio',
    valor        DECIMAL(8,2) NOT NULL,
    limite       DECIMAL(8,2) NOT NULL,
    mensaje      VARCHAR(200),
    fecha_hora   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atendida     BOOLEAN      NOT NULL DEFAULT FALSE,
    atendida_en  DATETIME,
    creado_por   INT,
    creado_en    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por  INT,
    editado_en   DATETIME,
    eliminado    BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    INDEX idx_alerta_sensor   (sensor_id),
    INDEX idx_alerta_atendida (atendida),
    CONSTRAINT fk_alerta_grupo        FOREIGN KEY (grupo_id)     REFERENCES grupo(id),
    CONSTRAINT fk_alerta_zona         FOREIGN KEY (zona_id)      REFERENCES zona(id),
    CONSTRAINT fk_alerta_sensor       FOREIGN KEY (sensor_id)    REFERENCES sensor(id),
    CONSTRAINT fk_alerta_atendida_por FOREIGN KEY (atendida_por) REFERENCES usuario(id),
    CONSTRAINT fk_alerta_creado_por   FOREIGN KEY (creado_por)   REFERENCES usuario(id),
    CONSTRAINT fk_alerta_editado_por  FOREIGN KEY (editado_por)  REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 13: comando_actuador
-- Log de comandos enviados a actuadores
-- ============================================================
CREATE TABLE IF NOT EXISTS comando_actuador (
    id            BIGINT       NOT NULL AUTO_INCREMENT,
    grupo_id      INT          NOT NULL,
    usuario_id    INT          NOT NULL,
    actuador_id   INT          NOT NULL,
    accion        ENUM('encender','apagar') NOT NULL,
    duracion_seg  INT,
    origen        ENUM('manual','automatico','programado') NOT NULL DEFAULT 'manual',
    estado        ENUM('pendiente','ejecutado','fallido') NOT NULL DEFAULT 'pendiente',
    confirmado_en DATETIME,
    creado_por    INT,
    creado_en     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    editado_por   INT,
    editado_en    DATETIME,
    eliminado     BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    CONSTRAINT fk_cmd_grupo       FOREIGN KEY (grupo_id)    REFERENCES grupo(id),
    CONSTRAINT fk_cmd_usuario     FOREIGN KEY (usuario_id)  REFERENCES usuario(id),
    CONSTRAINT fk_cmd_actuador    FOREIGN KEY (actuador_id) REFERENCES actuador(id),
    CONSTRAINT fk_cmd_creado_por  FOREIGN KEY (creado_por)  REFERENCES usuario(id),
    CONSTRAINT fk_cmd_editado_por FOREIGN KEY (editado_por) REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ============================================================
SELECT '✓ Base de datos invernadero_db creada con 13 tablas' AS resultado;
-- ============================================================
