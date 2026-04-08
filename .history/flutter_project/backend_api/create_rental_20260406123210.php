<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'connect.php';

$conn->begin_transaction();

$userId = (int) ($_POST['user_id'] ?? 0);
$bikeId = (int) ($_POST['bike_id'] ?? 0);
$pickupStation = trim($_POST['pickup_station'] ?? '');
$startDate = trim($_POST['start_date'] ?? '');
$endDate = trim($_POST['end_date'] ?? '');
$durationDays = (int) ($_POST['duration_days'] ?? 0);
$totalAmount = (int) ($_POST['total_amount'] ?? 0);
$mpesaPhone = trim($_POST['mpesa_phone'] ?? '');
$rentalType = trim($_POST['rental_type'] ?? 'day');

if (
    $userId <= 0 || $bikeId <= 0 || empty($pickupStation) || empty($startDate) ||
    empty($endDate) || $durationDays <= 0 || $totalAmount <= 0 || empty($mpesaPhone)
) {
    echo json_encode([
        "status" => "error",
        "message" => "All rental fields are required"
    ]);
    exit();
}

$status = (strtotime($startDate) <= strtotime(date('Y-m-d'))) ? 'Active' : 'Upcoming';

$bikeCheck = $conn->prepare("SELECT name, available_quantity FROM bikes WHERE id = ? FOR UPDATE");
$bikeCheck->bind_param("i", $bikeId);
$bikeCheck->execute();
$bikeResult = $bikeCheck->get_result();

if ($bikeResult->num_rows === 0) {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => "Bike not found"
    ]);
    exit();
}

$bike = $bikeResult->fetch_assoc();

if ((int) $bike['available_quantity'] <= 0) {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => $bike['name'] . " has already been booked. Please wait for about one hour or add more available bikes in the database."
    ]);
    exit();
}

$sql = "INSERT INTO rentals (user_id, bike_id, pickup_station, start_date, end_date, duration_days, total_amount, mpesa_phone, payment_status, rental_status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'paid', ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param(
    "iisssiiss",
    $userId,
    $bikeId,
    $pickupStation,
    $startDate,
    $endDate,
    $durationDays,
    $totalAmount,
    $mpesaPhone,
    $status
);

if (!$stmt->execute()) {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => $stmt->error
    ]);
    exit();
}

$updateBike = $conn->prepare("UPDATE bikes SET available_quantity = available_quantity - 1 WHERE id = ? AND available_quantity > 0");
$updateBike->bind_param("i", $bikeId);

if (!$updateBike->execute() || $updateBike->affected_rows === 0) {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => "This bike has already been booked. Please wait for about one hour or add more available bikes in the database."
    ]);
    exit();
}

$conn->commit();

echo json_encode([
    "status" => "success",
    "message" => "Rental created successfully",
    "rental_id" => $stmt->insert_id
]);

$bikeCheck->close();
$updateBike->close();
$stmt->close();
$conn->close();
?>
