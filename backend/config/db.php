<?php
// ============================================================
// CONEXIÓN A SUPABASE POSTGRESQL (PDO)
// Proyecto: Invernadero Inteligente UTEQ
// ============================================================

function getDBConnection(): PDO {
    static $pdo = null;
    
    if ($pdo === null) {
        $host     = getenv('DB_HOST') ?: 'db.jngvzkyggdgnvpmglzkp.supabase.co';
        $port     = getenv('DB_PORT') ?: '5432';
        $dbname   = getenv('DB_NAME') ?: 'postgres';
        $user     = getenv('DB_USER') ?: 'postgres';
        $password = getenv('DB_PASS') ?: 'Chatonegro12';

        $dsn = "pgsql:host={$host};port={$port};dbname={$dbname};sslmode=require";

        try {
            $pdo = new PDO($dsn, $user, $password, [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ]);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'error'   => 'Error de conexión a la base de datos Supabase: ' . $e->getMessage()
            ]);
            exit;
        }
    }

    return $pdo;
}
