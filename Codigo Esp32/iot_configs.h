// Tu WiFi
#define IOT_CONFIG_WIFI_SSID "Tec-IoT"
#define IOT_CONFIG_WIFI_PASSWORD "spotless.magnetic.bridge"
//#define IOT_CONFIG_WIFI_SSID "IZZI-291E"
//#define IOT_CONFIG_WIFI_PASSWORD "9CC8FC6F291E"
// Azure IoT Hub (El nombre de tu recurso + .azure-devices.net)
// Ejemplo: "hub-iot-bruno-final.azure-devices.net"
#define IOT_CONFIG_IOTHUB_FQDN "HubTeam8.azure-devices.net"

// ID del dispositivo que creaste
#define IOT_CONFIG_DEVICE_ID "Team8Device"

// La "Clave Principal" (Primary Key) que copiaste del dispositivo
#define IOT_CONFIG_DEVICE_KEY "O/cslMlg5OpgHrG/SiW0IVWSIYzEfzwVain7nDponv4="
// --- CONFIGURACIÓN PHP LOCAL ---
// Cambia las 'X' por la IP de tu laptop donde corre XAMPP

// Frecuencia de envío (10000 ms = 10 segundos, cámbialo a 60000 para 1 min)
#define TELEMETRY_FREQUENCY_MILLISECS 600000
