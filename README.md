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
