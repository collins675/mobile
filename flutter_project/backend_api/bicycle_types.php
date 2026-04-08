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

$sql = "SELECT bt.id, bt.type_name, bt.display_name, bt.description, COALESCE(SUM(b.available_quantity), 0) AS available_count
        FROM bicycle_types bt
        LEFT JOIN bikes b ON b.category = bt.type_name
        GROUP BY bt.id, bt.type_name, bt.display_name, bt.description, bt.sort_order
        ORDER BY bt.sort_order ASC, bt.display_name ASC";

$result = $conn->query($sql);
$types = [];

while ($row = $result->fetch_assoc()) {
    $row['id'] = (int) $row['id'];
    $row['available_count'] = (int) $row['available_count'];
    $types[] = $row;
}

echo json_encode([
    "status" => "success",
    "types" => $types
]);

$conn->close();
?>
