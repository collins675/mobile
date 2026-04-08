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

$availableResult = $conn->query("SELECT COALESCE(SUM(available_quantity), 0) AS total FROM bikes");
$availableBikes = (int) $availableResult->fetch_assoc()['total'];

$typeResult = $conn->query("SELECT COUNT(*) AS total FROM bicycle_types");
$availableTypes = (int) $typeResult->fetch_assoc()['total'];

$bookedTrips = 0;
if ($userId > 0) {
    $stmt = $conn->prepare("SELECT COUNT(*) AS total FROM rentals WHERE user_id = ?");
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $activeResult = $stmt->get_result();
    $bookedTrips = (int) $activeResult->fetch_assoc()['total'];
    $stmt->close();
}

$types = [];
$typesQuery = "SELECT bt.display_name, bt.type_name, COALESCE(SUM(b.available_quantity), 0) AS available_count
               FROM bicycle_types bt
               LEFT JOIN bikes b ON b.category = bt.type_name
               GROUP BY bt.id, bt.display_name, bt.type_name, bt.sort_order
               ORDER BY bt.sort_order ASC, bt.display_name ASC";
$typesResult = $conn->query($typesQuery);

while ($row = $typesResult->fetch_assoc()) {
    $row['available_count'] = (int) $row['available_count'];
    $types[] = $row;
}

echo json_encode([
    "status" => "success",
    "stats" => [
        "available_bikes" => $availableBikes,
        "booked_trips" => $bookedTrips,
        "available_types" => $availableTypes,
    ],
    "types" => $types
]);

$conn->close();
?>
