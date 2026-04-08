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

$rentalId = (int) ($_POST['rental_id'] ?? 0);
$bikeId = (int) ($_POST['bike_id'] ?? 0);

if ($rentalId <= 0 || $bikeId <= 0) {
    echo json_encode([
        "status" => "error",
        "message" => "Rental id and bike id are required",
    ]);
    exit();
}

$rentalCheck = $conn->prepare("SELECT bike_id, rental_status FROM rentals WHERE id = ? FOR UPDATE");
$rentalCheck->bind_param("i", $rentalId);
$rentalCheck->execute();
$rentalResult = $rentalCheck->get_result();

if ($rentalResult->num_rows === 0) {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => "Rental not found",
    ]);
    exit();
}

$rental = $rentalResult->fetch_assoc();

if ((int) $rental['bike_id'] !== $bikeId) {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => "Bike does not match the rental",
    ]);
    exit();
}

$currentStatus = strtolower(trim($rental['rental_status']));
if ($currentStatus !== 'active') {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => "Only active rentals can be returned.",
    ]);
    exit();
}

$updateRental = $conn->prepare("UPDATE rentals SET rental_status = 'Returned' WHERE id = ? AND rental_status = 'Active'");
$updateRental->bind_param("i", $rentalId);
if (!$updateRental->execute() || $updateRental->affected_rows === 0) {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => "Could not update rental status.",
    ]);
    exit();
}

$updateBike = $conn->prepare("UPDATE bikes SET available_quantity = available_quantity + 1 WHERE id = ?");
$updateBike->bind_param("i", $bikeId);
if (!$updateBike->execute() || $updateBike->affected_rows === 0) {
    $conn->rollback();
    echo json_encode([
        "status" => "error",
        "message" => "Could not update bike availability.",
    ]);
    exit();
}

$conn->commit();

echo json_encode([
    "status" => "success",
    "message" => "Bike returned successfully.",
]);

$rentalCheck->close();
$updateRental->close();
$updateBike->close();
$conn->close();
?>