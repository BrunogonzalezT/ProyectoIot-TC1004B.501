#include <cstdlib>

#include <string.h>

#include <time.h>

#include <HTTPClient.h> 

#include <WiFi.h>

#include <mqtt_client.h>
#include <az_core.h>
#include <az_iot.h>
#include <azure_ca.h>
#include "AzIoTSasToken.h"
#include "SerialLogger.h"
#include "iot_configs.h"
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_BME280.h>
#include <Adafruit_CCS811.h>

// Macro para tamaño de arrays

#define sizeofarray(a) (sizeof(a) / sizeof(a[0]))

// --- PINES DE IDENTIDAD (JUMPERS) ---

#define PIN_ID_1 13
#define PIN_ID_2 12

// --- HARDWARE ---

#define SDA_PIN 21

#define SCL_PIN 22

#define I2C_ADDR_OLED   0x3C

#define I2C_ADDR_CCS811 0x5A

#define I2C_ADDR_BME280 0x76



// Objetos Sensores

Adafruit_SSD1306 display(128, 32, &Wire, -1);

Adafruit_BME280 bme;

Adafruit_CCS811 ccs;



// Variables de sensores

float humidity = 0.0f;

float temperature = 0.0f;

int co2 = 0;

int tvoc = 0;



//const char* serverPHP = "http://192.168.0.11/iot/insertar_datos.php";

const char* serverPHP = "http://10.48.90.156/iot/insertar_datos.php";





// --- CONFIGURACIÓN AZURE ---

#define AZURE_SDK_CLIENT_USER_AGENT "c%2F" AZ_SDK_VERSION_STRING "(ard;esp32)"

#define NTP_SERVERS "pool.ntp.org", "time.nist.gov"

#define MQTT_QOS1 1

#define DO_NOT_RETAIN_MSG 0

#define SAS_TOKEN_DURATION_IN_MINUTES 60

#define UNIX_TIME_NOV_13_2017 1510592825



// --- ZONA HORARIA (CORREGIDO) ---

#define PST_TIME_ZONE -6 // México Centro

#define PST_TIME_ZONE_DAYLIGHT_SAVINGS_DIFF 0

// ¡ESTAS SON LAS LÍNEAS QUE FALTABAN!

#define GMT_OFFSET_SECS (PST_TIME_ZONE * 3600)

#define GMT_OFFSET_SECS_DST ((PST_TIME_ZONE + PST_TIME_ZONE_DAYLIGHT_SAVINGS_DIFF) * 3600)



static const char* ssid = IOT_CONFIG_WIFI_SSID;

static const char* password = IOT_CONFIG_WIFI_PASSWORD;

static const char* host = IOT_CONFIG_IOTHUB_FQDN;

static const char* device_id = IOT_CONFIG_DEVICE_ID; // ID Default "Team8Esp32"



static esp_mqtt_client_handle_t mqtt_client;

static az_iot_hub_client client;

static char mqtt_client_id[128];

static char mqtt_username[128];

static char mqtt_password[200];

static uint8_t sas_signature_buffer[256];

static unsigned long next_telemetry_send_time_ms = 0;

static char telemetry_topic[256];

static uint32_t telemetry_send_count = 0;

static String telemetry_payload = "";



#ifndef IOT_CONFIG_USE_X509_CERT

static AzIoTSasToken sasToken(&client, AZ_SPAN_FROM_STR(IOT_CONFIG_DEVICE_KEY), AZ_SPAN_FROM_BUFFER(sas_signature_buffer), AZ_SPAN_FROM_BUFFER(mqtt_password));

#endif



// --- FUNCIONES DE CONEXIÓN ---



static void connectToWiFi() {

  Logger.Info("Conectando a WIFI...");

  WiFi.mode(WIFI_STA);

  WiFi.disconnect();

  delay(100);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) { delay(500); Serial.print("."); }

  Serial.println("");

  Logger.Info("WiFi IP: " + WiFi.localIP().toString());

}



static void initializeTime() {

  configTime(GMT_OFFSET_SECS, GMT_OFFSET_SECS_DST, NTP_SERVERS);

  time_t now = time(NULL);

  while (now < UNIX_TIME_NOV_13_2017) { delay(500); Serial.print("."); now = time(nullptr); }

  Serial.println("");

  Logger.Info("Hora sincronizada");

}



#if defined(ESP_ARDUINO_VERSION_MAJOR) && ESP_ARDUINO_VERSION_MAJOR >= 3

static void mqtt_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data) {

  esp_mqtt_event_handle_t event = (esp_mqtt_event_handle_t)event_data;

#else

static esp_err_t mqtt_event_handler(esp_mqtt_event_handle_t event) {

#endif

  if (event->event_id == MQTT_EVENT_CONNECTED) Logger.Info("MQTT Conectado");

  if (event->event_id == MQTT_EVENT_DISCONNECTED) Logger.Info("MQTT Desconectado");

#if defined(ESP_ARDUINO_VERSION_MAJOR) && ESP_ARDUINO_VERSION_MAJOR < 3

  return ESP_OK;

#endif

}



static void initializeIoTHubClient() {

  az_iot_hub_client_options options = az_iot_hub_client_options_default();

  options.user_agent = AZ_SPAN_FROM_STR(AZURE_SDK_CLIENT_USER_AGENT);

  az_iot_hub_client_init(&client, az_span_create((uint8_t*)host, strlen(host)), az_span_create((uint8_t*)device_id, strlen(device_id)), &options);

 

  size_t client_id_length;

  az_iot_hub_client_get_client_id(&client, mqtt_client_id, sizeof(mqtt_client_id) - 1, &client_id_length);

  az_iot_hub_client_get_user_name(&client, mqtt_username, sizeofarray(mqtt_username), NULL);

}



static int initializeMqttClient() {

  if (sasToken.Generate(SAS_TOKEN_DURATION_IN_MINUTES) != 0) return 1;



  esp_mqtt_client_config_t mqtt_config;

  memset(&mqtt_config, 0, sizeof(mqtt_config));



  #if defined(ESP_ARDUINO_VERSION_MAJOR) && ESP_ARDUINO_VERSION_MAJOR >= 3

    mqtt_config.broker.address.hostname = host;

    mqtt_config.broker.address.port = 8883;

    mqtt_config.broker.address.transport = MQTT_TRANSPORT_OVER_SSL;

    mqtt_config.credentials.client_id = mqtt_client_id;

    mqtt_config.credentials.username = mqtt_username;

    mqtt_config.credentials.authentication.password = (const char*)az_span_ptr(sasToken.Get());

    mqtt_config.session.keepalive = 30;

    mqtt_config.broker.verification.certificate = (const char*)ca_pem;

  #else

    mqtt_config.host = host;

    mqtt_config.port = 8883;

    mqtt_config.transport = MQTT_TRANSPORT_OVER_SSL;

    mqtt_config.client_id = mqtt_client_id;

    mqtt_config.username = mqtt_username;

    mqtt_config.password = (const char*)az_span_ptr(sasToken.Get());

    mqtt_config.keepalive = 30;

    mqtt_config.event_handle = mqtt_event_handler;

    mqtt_config.cert_pem = (const char*)ca_pem;

  #endif



  mqtt_client = esp_mqtt_client_init(&mqtt_config);

  #if defined(ESP_ARDUINO_VERSION_MAJOR) && ESP_ARDUINO_VERSION_MAJOR >= 3

    esp_mqtt_client_register_event(mqtt_client, MQTT_EVENT_ANY, mqtt_event_handler, NULL);

  #endif

  return (esp_mqtt_client_start(mqtt_client) == ESP_OK) ? 0 : 1;

}



// --- LÓGICA DE APLICACIÓN ---



void leerSensores() {

  temperature = bme.readTemperature();

  humidity = bme.readHumidity();

  ccs.setEnvironmentalData(humidity, temperature);

  if (ccs.available() && !ccs.readData()) {

    co2 = ccs.geteCO2();

    tvoc = ccs.getTVOC();

  }

}



String getISOTime() {

  time_t now; time(&now); char buf[30];

  // Hora Local (sin Z al final)

  strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%S", localtime(&now));

  return String(buf);

}



// Envío HTTP Local

void enviarALaptop(String jsonPayload) {

  if (WiFi.status() == WL_CONNECTED) {

    HTTPClient http;

    http.begin(serverPHP);

    http.addHeader("Content-Type", "application/json");

    int code = http.POST(jsonPayload);

    if (code > 0) {

      Logger.Info("PHP Local OK. Resp: " + http.getString());

    } else {

      Logger.Error("PHP Local Fail: " + String(code));

    }

    http.end();

  }

}



// --- LÓGICA MAESTRA DE ENVÍO ---

static void sendTelemetry() {

  Logger.Info("Preparando envío...");

 

  az_iot_hub_client_telemetry_get_publish_topic(&client, NULL, telemetry_topic, sizeof(telemetry_topic), NULL);

  strcat(telemetry_topic, "$.ct=application%2Fjson&$.ce=utf-8");



  // 1. DETERMINAR IDENTIDAD (Basado en tu BD)

  int pin1 = digitalRead(PIN_ID_1); // Pin 13

  int pin2 = digitalRead(PIN_ID_2); // Pin 12

 

  String currentId;

  String currentTag;

  float currentLat, currentLon;



  // COORDENADAS DEL ARCHIVO SQL

  if (pin1 == HIGH && pin2 == HIGH) {       // 1 1 -> Estacion 1

    currentId = "Team8Esp32"; // "Team8Esp32"

    currentTag = "CEDETEC";

    currentLat = 19.597016;

    currentLon = -99.227220;

  }

  else if (pin1 == HIGH && pin2 == LOW) {   // 1 0 -> Estacion 2

    currentId = "STATION_02";

    currentTag = "Aulas 6";

    currentLat = 19.598277;

    currentLon = -99.226309;

  }

  else if (pin1 == LOW && pin2 == HIGH) {   // 0 1 -> Estacion 3

    currentId = "STATION_03";

    currentTag = "Biblioteca";

    currentLat = 19.597033;

    currentLon = -99.226720;

  }

  else {                                    // 0 0 -> Estacion 4

    currentId = "STATION_04";

    currentTag = "Aulas 3";

    currentLat = 19.598355;

    currentLon = -99.225592;

  }



  Logger.Info("Identidad detectada: " + currentTag);



  // 2. CONSTRUIR JSON (Formato de tu compañero)

  telemetry_payload = "{";

  telemetry_payload += "\"sensorId\": \"" + currentId + "\",";

  telemetry_payload += "\"temperature\": " + String(temperature) + ",";

  telemetry_payload += "\"humidity\": " + String(humidity) + ",";

  telemetry_payload += "\"lat\": " + String(currentLat, 6) + ",";

  telemetry_payload += "\"lon\": " + String(currentLon, 6) + ",";

  telemetry_payload += "\"deviceTime\": \"" + getISOTime() + "\",";

  telemetry_payload += "\"eCO2\": " + String(co2) + ",";

  telemetry_payload += "\"TVOC\": " + String(tvoc);

  telemetry_payload += "}";



  // 3. ENVIAR A AZURE

  if (esp_mqtt_client_publish(mqtt_client, telemetry_topic, (const char*)telemetry_payload.c_str(), telemetry_payload.length(), MQTT_QOS1, DO_NOT_RETAIN_MSG) == -1) {

    Logger.Error("Error publicando Azure");

  } else {

    Logger.Info("Azure OK: " + telemetry_payload);

  }

 

  // 4. ENVIAR A LAPTOP

  enviarALaptop(telemetry_payload);

}



// --- SETUP Y LOOP ---



void setup() {

  Serial.begin(115200);

 

  // Pines de Identidad

  pinMode(PIN_ID_1, INPUT_PULLUP);

  pinMode(PIN_ID_2, INPUT_PULLUP);



  Wire.begin(SDA_PIN, SCL_PIN);

  if (!display.begin(SSD1306_SWITCHCAPVCC, I2C_ADDR_OLED)) Serial.println(F("Error OLED"));

  if (!bme.begin(I2C_ADDR_BME280)) Serial.println(F("Error BME280"));

  if (!ccs.begin(I2C_ADDR_CCS811)) Serial.println(F("Error CCS811"));

  while (!ccs.available());

 

  display.clearDisplay();

  display.setTextSize(1);

  display.setTextColor(SSD1306_WHITE);

  display.println("WiFi...");

  display.display();



  connectToWiFi();

  initializeTime();

  initializeIoTHubClient();

  (void)initializeMqttClient();

 

  display.clearDisplay();

  display.println("Listo! Modo: " + String(digitalRead(PIN_ID_1)) + String(digitalRead(PIN_ID_2)));

  display.display();

  delay(2000);

}



void loop() {

  if (WiFi.status() != WL_CONNECTED) connectToWiFi();

 

  if (sasToken.IsExpired()) {

    esp_mqtt_client_destroy(mqtt_client);

    initializeMqttClient();

  }



  leerSensores();

 

  // Actualizar OLED (Muestra en qué modo estás)

  display.clearDisplay();

  display.setCursor(0, 0);

  // Mostrar estación en pantalla

  display.print("EST: ");

  int p1 = digitalRead(PIN_ID_1);

  int p2 = digitalRead(PIN_ID_2);

 

  if(p1==1 && p2==1) display.println("       1 (CEDETEC)");

  else if(p1==1 && p2==0) display.println("    2 (Aulas 6)");

  else if(p1==0 && p2==1) display.println("    3 (Biblio)");

  else display.println("     4 (Aulas 3)");

 

  display.println(temperature, 1); display.print("C ");

  display.println(humidity, 0); display.println("%");

  display.println("CO2:"); display.print(co2);

  display.display();



  if (millis() > next_telemetry_send_time_ms) {

    sendTelemetry();

    next_telemetry_send_time_ms = millis() + TELEMETRY_FREQUENCY_MILLISECS;

  }

  delay(2000);

}