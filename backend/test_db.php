<?php
header('Content-Type: text/plain; charset=utf-8');

$ref      = 'jngvzkyggdgnvpmglzkp';
$password = 'Chatonegro12';

// Intento 1: Direct connection
$hosts = [
    [
        'name' => 'Conexión Directa (IPv6 / Supabase direct)',
        'host' => "db.{$ref}.supabase.co",
        'port' => 5432,
        'user' => 'postgres',
        'pass' => $password,
    ],
    [
        'name' => 'Connection Pooler (Session mode - puerto 5432)',
        'host' => 'aws-0-us-west-2.pooler.supabase.com',
        'port' => 5432,
        'user' => "postgres.{$ref}",
        'pass' => $password,
    ],
    [
        'name' => 'Connection Pooler (Transaction mode - puerto 6543)',
        'host' => 'aws-0-us-west-2.pooler.supabase.com',
        'port' => 6543,
        'user' => "postgres.{$ref}",
        'pass' => $password,
    ]
];

$connected = false;
foreach ($hosts as $cfg) {
    echo "Probando: {$cfg['name']}...\n";
    try {
        $dsn = "pgsql:host={$cfg['host']};port={$cfg['port']};dbname=postgres;sslmode=require";
        $pdo = new PDO($dsn, $cfg['user'], $cfg['pass'], [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_TIMEOUT            => 5
        ]);
        
        $stmt = $pdo->query("SELECT nombre, rol FROM usuario ORDER BY id ASC");
        $users = $stmt->fetchAll();
        
        echo "✅ ¡CONEXIÓN EXITOSA!\n";
        echo "Usuarios encontrados en la base de datos:\n";
        foreach ($users as $u) {
            echo " - {$u['nombre']} ({$u['rol']})\n";
        }
        $connected = true;
        break;
    } catch (Exception $e) {
        echo "❌ Error: " . $e->getMessage() . "\n\n";
    }
}

if (!$connected) {
    echo "No se pudo conectar por PDO directo.\n";
}
