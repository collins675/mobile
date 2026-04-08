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

$sql = "SELECT id, name, category, image, location, price_per_hour, price_per_day, available_quantity
        FROM bikes
        ORDER BY id ASC";
$result = $conn->query($sql);
$bikes = [];

while ($row = $result->fetch_assoc()) {
    $category = strtolower(trim((string) ($row['category'] ?? '')));

    $row['id'] = (int) $row['id'];
    $row['price_per_hour'] = (int) $row['price_per_hour'];
    $row['price_per_day'] = (int) $row['price_per_day'];
    if ($row['price_per_hour'] <= 0) {
        $row['price_per_hour'] = 200;
    }
    $row['available_quantity'] = (int) $row['available_quantity'];
    $row['total_quantity'] = (int) $row['available_quantity'];
    $row['is_available'] = $row['available_quantity'] > 0;
    $row['rating'] = 0;
    $row['bike_range'] = 'Flexible city range';
    $row['top_speed'] = 'Depends on route';
    $row['description'] = 'Comfortable bicycle available for daily rentals.';
    $row['features'] = ['Helmet support', 'Flexible pickup', 'Daily pricing'];
    $row['is_electric'] = $category === 'electric';
    $row['image'] = match ($category) {
        'electric' => 'assets/electric.jpg',
        'road' => 'assets/road.png',
        'mountain' => $row['id'] % 2 === 0
            ? 'assets/mountain2.png'
            : 'assets/mountain1.png',
        default => 'assets/bike.png',
    };
    $row['location'] = !empty($row['location']) ? $row['location'] : 'Main station';
    $bikes[] = $row;
}

echo json_encode([
    "status" => "success",
    "bikes" => $bikes
]);

$conn->close();
?>
