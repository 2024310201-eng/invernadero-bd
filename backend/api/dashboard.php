<?php
// ============================================================
// ENDPOINT: Resumen General del Invernadero para Dashboard
// Retorna: Últimas lecturas con magnitudes, alertas activas y actuadores
// ============================================================
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

require_once __DIR__ . '/../config/db.php';

try {
    $pdo = getDBConnection();

    // 1. Lecturas actuales con información de sensor, magnitud, zona y cultivo
    $sqlLecturas = "
        SELECT 
            s.id AS sensor_id,
            s.codigo AS sensor_codigo,
            s.modelo AS sensor_modelo,
            m.codigo AS magnitud_codigo,
            m.nombre AS magnitud_nombre,
            m.unidad AS magnitud_unidad,
            la.valor,
            la.fecha_hora,
            z.nombre AS zona_nombre,
            c.nombre AS cultivo_nombre,
            u.minimo AS umbral_min,
            u.maximo AS umbral_max,
            CASE 
                WHEN la.valor < u.minimo THEN 'bajo'
                WHEN la.valor > u.maximo THEN 'alto'
                ELSE 'optimo'
            END AS estado_rango
        FROM lectura_actual la
        JOIN sensor s ON la.sensor_id = s.id
        JOIN magnitud m ON s.magnitud_id = m.id
        JOIN dispositivo d ON s.dispositivo_id = d.id
        LEFT JOIN zona z ON d.zona_id = z.id
        LEFT JOIN cultivo c ON z.cultivo_id = c.id
        LEFT JOIN umbral u ON (u.cultivo_id = c.id AND u.magnitud_id = m.id)
        WHERE s.eliminado = FALSE
        ORDER BY s.id ASC
    ";
    $stmtLecturas = $pdo->query($sqlLecturas);
    $lecturas = $stmtLecturas->fetchAll();

    // 2. Alertas activas pendientes
    $sqlAlertas = "
        SELECT 
            a.id,
            a.tipo,
            a.nivel,
            a.valor,
            a.limite,
            a.mensaje,
            a.fecha_hora,
            a.atendida,
            s.codigo AS sensor_codigo,
            z.nombre AS zona_nombre
        FROM alerta a
        JOIN sensor s ON a.sensor_id = s.id
        LEFT JOIN zona z ON a.zona_id = z.id
        WHERE a.atendida = FALSE AND a.eliminado = FALSE
        ORDER BY a.fecha_hora DESC
    ";
    $stmtAlertas = $pdo->query($sqlAlertas);
    $alertas = $stmtAlertas->fetchAll();

    // 3. Estado de los actuadores (ventiladores, bombas, luces)
    $sqlActuadores = "
        SELECT 
            act.id,
            act.nombre,
            act.tipo,
            act.estado,
            d.nombre AS dispositivo_nombre
        FROM actuador act
        JOIN dispositivo d ON act.dispositivo_id = d.id
        WHERE act.eliminado = FALSE
        ORDER BY act.id ASC
    ";
    $stmtActuadores = $pdo->query($sqlActuadores);
    $actuadores = $stmtActuadores->fetchAll();

    echo json_encode([
        'success'   => true,
        'timestamp' => date('c'),
        'invernadero' => 'Invernadero Inteligente UTEQ - Jitomate Cherry',
        'data' => [
            'lecturas'   => $lecturas,
            'alertas'    => $alertas,
            'actuadores' => $actuadores
        ]
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error'   => $e->getMessage()
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
}
