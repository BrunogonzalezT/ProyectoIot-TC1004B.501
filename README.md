Proyecto para la materia TC1004B.501 

# 🌿 Sistema de Monitoreo Ambiental IoT Híbrido

![Status](https://img.shields.io/badge/Status-Completado-success)
![Platform](https://img.shields.io/badge/Platform-ESP32-blue)
![Backend](https://img.shields.io/badge/Backend-PHP%20%7C%20MySQL-orange)
![Cloud](https://img.shields.io/badge/Cloud-Azure%20IoT-0078D4)
![Frontend](https://img.shields.io/badge/Frontend-Streamlit-FF4B4B)

Un sistema de monitoreo ambiental inteligente y resiliente diseñado con una **arquitectura híbrida (Edge-to-Cloud & Edge-to-Local)**.

Este proyecto permite la medición de **Temperatura, Humedad, eCO2 y TVOC** utilizando un microcontrolador ESP32. La principal innovación es su capacidad de transmitir datos simultáneamente a la nube (**Microsoft Azure**) para monitoreo remoto y a un servidor local (**MySQL**) para persistencia de datos y análisis histórico sin depender de internet.

---

## 🏗️ Arquitectura del Sistema

El sistema opera bajo un esquema de redundancia de datos. El dispositivo ESP32 actúa como el nodo central que distribuye la información por dos canales seguros.

```mermaid
graph LR
    classDef hardware fill:#ffcc00,stroke:#333,stroke-width:2px;
    classDef cloud fill:#0078d4,stroke:#333,stroke-width:2px,color:white;
    classDef local fill:#77dd77,stroke:#333,stroke-width:2px;

    subgraph Hardware ["📍 CAPA FÍSICA"]
        ESP32[("📟 ESP32")]
        Sensors["Sensores (BME280 + CCS811)"]
        Jumpers["Configuración de Identidad"]
        Sensors --> ESP32
        Jumpers --> ESP32
    end

    subgraph Cloud ["☁️ CAPA NUBE (Azure)"]
        IoTHub["Azure IoT Hub"]
        ASA["Stream Analytics"]
        PowerBI["Power BI Dashboard"]
        ESP32 == "MQTT (Seguro)" ==> IoTHub
        IoTHub --> ASA
        ASA --> PowerBI
    end

    subgraph Local ["💻 CAPA LOCAL"]
        PHP["API REST (PHP)"]
        MySQL[("MySQL (7 Tablas)")]
        Streamlit["App Analítica (Python)"]
        ESP32 -.-> |"HTTP POST"| PHP
        PHP --> MySQL
        Streamlit <--> MySQL
    end

    class ESP32,Sensors,Jumpers hardware;
    class IoTHub,ASA,PowerBI cloud;
    class PHP,MySQL,Streamlit local;
¡Claro que sí! Un buen README.md es la carta de presentación de tu proyecto. Es lo primero que verá tu profesor o cualquier reclutador que entre a tu GitHub.Aquí tienes una plantilla profesional, estructurada y lista para copiar y pegar. He incluido el diagrama de arquitectura (GitHub soporta Mermaid nativamente) y las instrucciones de instalación basadas en todo lo que hemos trabajado.Copia el siguiente bloque de código y pégalo en tu archivo README.md.Markdown# 🌿 Sistema de Monitoreo Ambiental IoT Híbrido

![Status](https://img.shields.io/badge/Status-Completado-success)
![Platform](https://img.shields.io/badge/Platform-ESP32-blue)
![Backend](https://img.shields.io/badge/Backend-PHP%20%7C%20MySQL-orange)
![Cloud](https://img.shields.io/badge/Cloud-Azure%20IoT-0078D4)
![Frontend](https://img.shields.io/badge/Frontend-Streamlit-FF4B4B)

Un sistema de monitoreo ambiental inteligente y resiliente diseñado con una **arquitectura híbrida (Edge-to-Cloud & Edge-to-Local)**.

Este proyecto permite la medición de **Temperatura, Humedad, eCO2 y TVOC** utilizando un microcontrolador ESP32. La principal innovación es su capacidad de transmitir datos simultáneamente a la nube (**Microsoft Azure**) para monitoreo remoto y a un servidor local (**MySQL**) para persistencia de datos y análisis histórico sin depender de internet.

---

## 🏗️ Arquitectura del Sistema

El sistema opera bajo un esquema de redundancia de datos. El dispositivo ESP32 actúa como el nodo central que distribuye la información por dos canales seguros.

```mermaid
graph LR
    classDef hardware fill:#ffcc00,stroke:#333,stroke-width:2px;
    classDef cloud fill:#0078d4,stroke:#333,stroke-width:2px,color:white;
    classDef local fill:#77dd77,stroke:#333,stroke-width:2px;

    subgraph Hardware ["📍 CAPA FÍSICA"]
        ESP32[("📟 ESP32")]
        Sensors["Sensores (BME280 + CCS811)"]
        Jumpers["Configuración de Identidad"]
        Sensors --> ESP32
        Jumpers --> ESP32
    end

    subgraph Cloud ["☁️ CAPA NUBE (Azure)"]
        IoTHub["Azure IoT Hub"]
        ASA["Stream Analytics"]
        PowerBI["Power BI Dashboard"]
        ESP32 == "MQTT (Seguro)" ==> IoTHub
        IoTHub --> ASA
        ASA --> PowerBI
    end

    subgraph Local ["💻 CAPA LOCAL"]
        PHP["API REST (PHP)"]
        MySQL[("MySQL (7 Tablas)")]
        Streamlit["App Analítica (Python)"]
        ESP32 -.-> |"HTTP POST"| PHP
        PHP --> MySQL
        Streamlit <--> MySQL
    end

    class ESP32,Sensors,Jumpers hardware;
    class IoTHub,ASA,PowerBI cloud;
    class PHP,MySQL,Streamlit local;
```
✨ Características PrincipalesPersistencia Híbrida: Los datos no se pierden. Si la nube falla, el servidor local respalda. Si la red local falla, la nube recibe.Identidad Dinámica (Virtualización): Simulación de 4 estaciones físicas diferentes (CEDETEC, Aulas, Biblioteca, Cafetería) utilizando un solo dispositivo mediante configuración de hardware (Jumpers en GPIO 12/13).Base de Datos Normalizada (3NF): Esquema relacional optimizado de 7 tablas con catálogo de sensores para evitar redundancia.Dashboard Unificado: Interfaz en Streamlit que integra análisis estadístico local (Pandas) y visualización en tiempo real embebida (Power BI).Seguridad: Uso de usuarios con privilegios mínimos en base de datos y SAS Tokens para la conexión a Azure.🛠️ Tecnologías UtilizadasCapaTecnologíasHardwareESP32 DEVKIT V1, BME280 (I2C), CCS811 (I2C), OLED 0.91".FirmwareC++ (Arduino IDE), Azure IoT SDK for C, ArduinoJson.Backend LocalApache Server, PHP 8.x, MySQL (MariaDB).Frontend LocalPython 3.11, Streamlit, PyDeck (Mapas), Pandas.NubeAzure IoT Hub, Stream Analytics, Power BI.ProtocolosMQTT (Secure), HTTP/REST, I2C.🚀 Instalación y Configuración1. Base de Datos (MySQL/XAMPP)Inicia Apache y MySQL en XAMPP.Abre phpMyAdmin e importa el script database/iot.sql.Crea el usuario seguro ejecutando el script SQL:SQLCREATE USER 'iot_user'@'localhost' IDENTIFIED BY 'pass1234';
GRANT SELECT, INSERT ON iot.* TO 'iot_user'@'localhost';
FLUSH PRIVILEGES;
2. Backend (API PHP)Copia el archivo backend/insertar_datos.php a tu carpeta htdocs/iot/.Verifica que la IP de tu máquina sea estática o conocida (ej. 192.168.0.X).3. Firmware (ESP32)Abre el proyecto en Arduino IDE.Instala las librerías necesarias:Azure IoT SDK for CArduinoJsonAdafruit BME280 & Adafruit CCS811Adafruit SSD1306 & GFXEdita iot_configs.h con tus credenciales WiFi y Azure.Edita Azure_IoT_ESP32.ino con la IP de tu servidor PHP local (serverPHP).Sube el código al ESP32.4. Dashboard (Streamlit)Navega a la carpeta de la aplicación:Bashcd app
Instala las dependencias:Bashpip install streamlit pandas mysql-connector-python pydeck
Ejecuta la aplicación:Bashstreamlit run app.py
🎮 Modo de Uso (Simulación de Estaciones)El dispositivo cuenta con dos pines de configuración (GPIO 13 y GPIO 12) que actúan como selectores binarios para cambiar la identidad y ubicación de la estación en tiempo real.Pin 13 (Bit 1)Pin 12 (Bit 0)IdentidadUbicación SimuladaLibreLibreTeam8Esp32🏠 CEDETECLibreGNDSTATION_02🏫 Aulas 6GNDLibreSTATION_03📚 BibliotecaGNDGNDSTATION_04☕ CafeteríaConecta los jumpers a GND (Tierra) para cambiar de estación.👥 AutoresProyecto desarrollado para la materia de [Nombre de tu Materia] en el Tecnológico de Monterrey.Bruno Gonzalez Torres - Líder de Proyecto & Desarrollo Full Stack[Nombre Compañero 1] - Desarrollo Cloud & Azure[Nombre Compañero 2] - Hardware & Electrónica
