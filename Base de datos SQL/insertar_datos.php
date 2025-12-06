<?php
// CONFIGURACIÓN
$servername = "localhost";
$username = "iot_user";
$password = "pass1234";
$dbname = "iot";

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli($servername, $username, $password, $dbname);
    $conn->set_charset("utf8mb4");
} catch (Exception $e) {
    die("Error de conexión: " . $e->getMessage());
}

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if ($data) {
    $sensorId = $data['sensorId'] ?? ''; 
    $temp = $data['temperature'] ?? null;
    $hum = $data['humidity'] ?? null;
    $co2 = $data['eCO2'] ?? 0;
    $tvoc = $data['TVOC'] ?? 0;

    // 1. BUSCAR ESTACIÓN
    $stmt = $conn->prepare("SELECT EstacionID FROM Estacion WHERE Nombre = ? OR DeviceMAC = ? LIMIT 1");
    $stmt->bind_param("ss", $sensorId, $sensorId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        $estacionID = $row['EstacionID'];
        $stmt->close();

        // 2. BUSCAR SENSORES (AQUÍ ESTÁ EL CAMBIO: ModeloID)
        
        // Buscar BME280
        $modeloBME = 'BME280';
        // Cambiamos 'Modelo' por 'ModeloID' en el WHERE
        $stmtBME = $conn->prepare("SELECT SensorID FROM Sensor WHERE EstacionID = ? AND ModeloID = ? LIMIT 1");
        $stmtBME->bind_param("is", $estacionID, $modeloBME);
        $stmtBME->execute();
        $resBME = $stmtBME->get_result();
        $id_bme = ($resBME->num_rows > 0) ? $resBME->fetch_assoc()['SensorID'] : null;
        $stmtBME->close();

        // Buscar CCS811
        $modeloCCS = 'CCS811';
        // Cambiamos 'Modelo' por 'ModeloID' en el WHERE
        $stmtCCS = $conn->prepare("SELECT SensorID FROM Sensor WHERE EstacionID = ? AND ModeloID = ? LIMIT 1");
        $stmtCCS->bind_param("is", $estacionID, $modeloCCS);
        $stmtCCS->execute();
        $resCCS = $stmtCCS->get_result();
        $id_ccs = ($resCCS->num_rows > 0) ? $resCCS->fetch_assoc()['SensorID'] : null;
        $stmtCCS->close();

        // 3. INSERTAR LECTURAS
        if ($id_bme && $temp !== null) {
            $stmtT = $conn->prepare("INSERT INTO Lectura_Temperatura (SensorID, Timestamp, Valor) VALUES (?, NOW(3), ?)");
            $stmtT->bind_param("id", $id_bme, $temp);
            $stmtT->execute();
            $stmtT->close();

            $stmtH = $conn->prepare("INSERT INTO Lectura_Humedad (SensorID, Timestamp, Valor) VALUES (?, NOW(3), ?)");
            $stmtH->bind_param("id", $id_bme, $hum);
            $stmtH->execute();
            $stmtH->close();
        }

        if ($id_ccs) {
            $stmtC = $conn->prepare("INSERT INTO Lectura_eCO2 (SensorID, Timestamp, Valor) VALUES (?, NOW(3), ?)");
            $stmtC->bind_param("ii", $id_ccs, $co2);
            $stmtC->execute();
            $stmtC->close();

            $stmtV = $conn->prepare("INSERT INTO Lectura_TVOC (SensorID, Timestamp, Valor) VALUES (?, NOW(3), ?)");
            $stmtV->bind_param("ii", $id_ccs, $tvoc);
            $stmtV->execute();
            $stmtV->close();
        }

        echo "Éxito: Datos insertados (Modelo Catálogo)";

    } else {
        echo "Error: Estación '$sensorId' no encontrada.";
    }

} else {
    echo "Error: JSON vacío.";
}

$conn->close();
?>