<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'connect.php';

$userId = (int) ($_GET['user_id'] ?? 0);

if ($userId <= 0) {
    echo json_encode([
        "status" => "error",
        "message" => "User id is required"
    ]);
    exit();
}

$sql = "SELECT id, Fullname, email, `created-at`, `updated-at` FROM users WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $userId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode([
        "status" => "error",
        "message" => "User not found"
    ]);
    exit();
}

$user = $result->fetch_assoc();

echo json_encode([
    "status" => "success",
    "user" => $user
]);

$stmt->close();
$conn->close();
?>
