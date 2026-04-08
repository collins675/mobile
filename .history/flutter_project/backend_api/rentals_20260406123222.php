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

$sql = "SELECT rentals.id, bikes.name AS bike_name, rentals.pickup_station, rentals.start_date, rentals.end_date, rentals.duration_days, rentals.total_amount, rentals.payment_status, rentals.rental_status, rentals.rental_type
        FROM rentals
        INNER JOIN bikes ON bikes.id = rentals.bike_id
        WHERE rentals.user_id = ?
        ORDER BY rentals.created_at DESC";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $userId);
$stmt->execute();
$result = $stmt->get_result();

$rentals = [];
while ($row = $result->fetch_assoc()) {
    $row['id'] = (int) $row['id'];
    $row['duration_days'] = (int) $row['duration_days'];
    $row['total_amount'] = (int) $row['total_amount'];
    $rentals[] = $row;
}

echo json_encode([
    "status" => "success",
    "rentals" => $rentals
]);

$stmt->close();
$conn->close();
?>
