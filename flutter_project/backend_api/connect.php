<?php
$host = "localhost";
$user = "root";
$password = "";
$db = "flutter project 1.1";

$conn = mysqli_connect($host, $user, $password, $db);

if (!$conn) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Database connection failed: " . mysqli_connect_error()
    ]);
    exit();
}

mysqli_set_charset($conn, "utf8mb4");
?>
