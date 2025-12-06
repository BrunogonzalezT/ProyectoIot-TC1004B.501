-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-12-2025 a las 21:30:35
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `iot`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `catalogosensor`
--

CREATE TABLE `catalogosensor` (
  `ModeloID` varchar(50) NOT NULL,
  `Descripcion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `catalogosensor`
--

INSERT INTO `catalogosensor` (`ModeloID`, `Descripcion`) VALUES
('BME280', 'Sensor de Temperatura, Humedad y Presión'),
('CCS811', 'Sensor Digital de Gas para Calidad de Aire');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estacion`
--

CREATE TABLE `estacion` (
  `EstacionID` int(11) NOT NULL,
  `Nombre` varchar(100) DEFAULT NULL,
  `DeviceMAC` varchar(50) NOT NULL,
  `Latitud` decimal(10,8) DEFAULT NULL,
  `Longitud` decimal(11,8) DEFAULT NULL,
  `UbicacionTag` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estacion`
--

INSERT INTO `estacion` (`EstacionID`, `Nombre`, `DeviceMAC`, `Latitud`, `Longitud`, `UbicacionTag`) VALUES
(1, 'Estacion 1', 'Team8Esp32', 19.59701600, -99.22722000, 'CEDETEC'),
(2, 'Estacion 2', 'STATION_02', 19.59827700, -99.22630900, 'Aulas 6'),
(3, 'Estacion 3', 'STATION_03', 19.59703300, -99.22672000, 'Biblioteca'),
(4, 'Estacion 4', 'STATION_04', 19.59835500, -99.22559200, 'Aulas 3');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lectura_eco2`
--

CREATE TABLE `lectura_eco2` (
  `LecturaID` bigint(20) NOT NULL,
  `SensorID` int(11) NOT NULL,
  `Timestamp` datetime(3) NOT NULL,
  `Valor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lectura_eco2`
--

INSERT INTO `lectura_eco2` (`LecturaID`, `SensorID`, `Timestamp`, `Valor`) VALUES
(1, 2, '2025-11-27 07:47:03.700', 400),
(2, 2, '2025-11-27 07:57:05.804', 793),
(3, 2, '2025-11-27 08:07:08.117', 793),
(4, 2, '2025-11-27 08:17:10.188', 671),
(5, 2, '2025-11-27 08:27:12.023', 428),
(6, 2, '2025-11-27 08:37:14.136', 409),
(7, 2, '2025-11-27 08:47:16.088', 405),
(8, 2, '2025-11-27 08:57:17.898', 405),
(9, 2, '2025-11-27 09:07:19.705', 450),
(10, 2, '2025-11-27 09:17:21.505', 537),
(11, 2, '2025-11-27 09:27:23.327', 555),
(12, 2, '2025-11-27 09:39:14.084', 481),
(13, 2, '2025-11-27 09:47:31.964', 421),
(14, 2, '2025-11-27 09:57:33.973', 417),
(15, 2, '2025-11-27 10:07:35.964', 441),
(16, 2, '2025-11-27 10:11:17.590', 400),
(17, 2, '2025-11-27 10:15:03.222', 400),
(18, 2, '2025-11-27 10:25:05.415', 476),
(19, 8, '2025-11-27 10:39:46.037', 406),
(20, 8, '2025-11-27 10:49:47.934', 1099),
(21, 8, '2025-11-28 11:12:12.660', 400),
(22, 4, '2025-11-28 11:22:14.686', 517),
(23, 4, '2025-11-28 11:32:16.513', 637),
(24, 4, '2025-11-28 11:42:18.381', 1242),
(25, 4, '2025-11-28 11:52:20.269', 1548),
(26, 4, '2025-11-28 12:02:22.141', 942),
(27, 4, '2025-11-28 12:12:24.209', 840),
(28, 4, '2025-11-28 12:22:26.302', 770),
(29, 4, '2025-11-28 12:32:28.126', 872),
(30, 4, '2025-11-28 12:42:29.989', 819),
(31, 6, '2025-11-28 13:38:35.466', 411),
(32, 6, '2025-11-28 13:48:36.426', 846),
(33, 6, '2025-11-28 13:58:38.638', 1062),
(34, 6, '2025-11-28 14:08:39.528', 1445),
(35, 6, '2025-11-28 14:18:41.654', 1614),
(36, 6, '2025-11-28 14:28:43.943', 1738),
(37, 6, '2025-11-28 14:49:05.699', 1723),
(38, 6, '2025-11-28 15:20:31.489', 400),
(39, 8, '2025-11-28 15:30:33.402', 456),
(40, 8, '2025-11-28 15:40:35.238', 560),
(41, 8, '2025-11-28 15:50:37.093', 517),
(42, 8, '2025-11-28 16:00:39.091', 1462),
(43, 8, '2025-11-28 16:10:40.967', 602),
(44, 8, '2025-11-28 16:20:42.894', 524),
(45, 8, '2025-11-28 16:30:44.718', 572),
(46, 8, '2025-11-28 16:40:46.548', 599),
(47, 2, '2025-12-02 11:34:15.245', 400),
(48, 2, '2025-12-02 11:44:15.415', 633),
(49, 4, '2025-12-02 11:54:15.589', 956),
(50, 4, '2025-12-02 12:04:15.858', 949),
(51, 4, '2025-12-02 12:14:16.041', 1562),
(52, 4, '2025-12-02 12:24:16.345', 1511),
(53, 4, '2025-12-02 12:34:17.002', 1330),
(54, 4, '2025-12-02 12:44:17.221', 1491);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lectura_humedad`
--

CREATE TABLE `lectura_humedad` (
  `LecturaID` bigint(20) NOT NULL,
  `SensorID` int(11) NOT NULL,
  `Timestamp` datetime(3) NOT NULL,
  `Valor` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lectura_humedad`
--

INSERT INTO `lectura_humedad` (`LecturaID`, `SensorID`, `Timestamp`, `Valor`) VALUES
(1, 1, '2025-11-27 07:47:03.695', 52.73),
(2, 1, '2025-11-27 07:57:05.800', 48.41),
(3, 1, '2025-11-27 08:07:08.114', 44.23),
(4, 1, '2025-11-27 08:17:10.184', 42.33),
(5, 1, '2025-11-27 08:27:12.020', 40.79),
(6, 1, '2025-11-27 08:37:14.132', 39.66),
(7, 1, '2025-11-27 08:47:16.087', 38.63),
(8, 1, '2025-11-27 08:57:17.888', 37.21),
(9, 1, '2025-11-27 09:07:19.703', 36.79),
(10, 1, '2025-11-27 09:17:21.503', 40.13),
(11, 1, '2025-11-27 09:27:23.325', 45.59),
(12, 1, '2025-11-27 09:39:14.082', 47.02),
(13, 1, '2025-11-27 09:47:31.962', 47.06),
(14, 1, '2025-11-27 09:57:33.969', 46.87),
(15, 1, '2025-11-27 10:07:35.962', 45.73),
(16, 1, '2025-11-27 10:11:17.589', 47.08),
(17, 1, '2025-11-27 10:15:03.216', 46.23),
(18, 1, '2025-11-27 10:25:05.412', 46.52),
(19, 7, '2025-11-27 10:39:46.035', 45.41),
(20, 7, '2025-11-27 10:49:47.932', 46.77),
(21, 7, '2025-11-28 11:12:12.658', 52.75),
(22, 3, '2025-11-28 11:22:14.684', 47.95),
(23, 3, '2025-11-28 11:32:16.511', 46.83),
(24, 3, '2025-11-28 11:42:18.374', 46.22),
(25, 3, '2025-11-28 11:52:20.267', 45.74),
(26, 3, '2025-11-28 12:02:22.137', 44.89),
(27, 3, '2025-11-28 12:12:24.205', 44.67),
(28, 3, '2025-11-28 12:22:26.299', 43.93),
(29, 3, '2025-11-28 12:32:28.123', 43.23),
(30, 3, '2025-11-28 12:42:29.987', 43.02),
(31, 5, '2025-11-28 13:38:35.463', 54.33),
(32, 5, '2025-11-28 13:48:36.424', 43.90),
(33, 5, '2025-11-28 13:58:38.635', 38.32),
(34, 5, '2025-11-28 14:08:39.526', 35.28),
(35, 5, '2025-11-28 14:18:41.651', 37.76),
(36, 5, '2025-11-28 14:28:43.942', 41.44),
(37, 5, '2025-11-28 14:49:05.697', 43.68),
(38, 5, '2025-11-28 15:20:31.486', 44.64),
(39, 7, '2025-11-28 15:30:33.399', 46.61),
(40, 7, '2025-11-28 15:40:35.235', 44.74),
(41, 7, '2025-11-28 15:50:37.089', 44.85),
(42, 7, '2025-11-28 16:00:39.087', 45.02),
(43, 7, '2025-11-28 16:10:40.965', 45.05),
(44, 7, '2025-11-28 16:20:42.892', 45.16),
(45, 7, '2025-11-28 16:30:44.715', 44.32),
(46, 7, '2025-11-28 16:40:46.545', 43.80),
(47, 1, '2025-12-02 11:34:15.243', 40.33),
(48, 1, '2025-12-02 11:44:15.414', 38.94),
(49, 3, '2025-12-02 11:54:15.587', 38.80),
(50, 3, '2025-12-02 12:04:15.857', 38.08),
(51, 3, '2025-12-02 12:14:16.030', 38.44),
(52, 3, '2025-12-02 12:24:16.342', 38.29),
(53, 3, '2025-12-02 12:34:16.999', 38.06),
(54, 3, '2025-12-02 12:44:17.220', 37.93);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lectura_temperatura`
--

CREATE TABLE `lectura_temperatura` (
  `LecturaID` bigint(20) NOT NULL,
  `SensorID` int(11) NOT NULL,
  `Timestamp` datetime(3) NOT NULL,
  `Valor` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lectura_temperatura`
--

INSERT INTO `lectura_temperatura` (`LecturaID`, `SensorID`, `Timestamp`, `Valor`) VALUES
(1, 1, '2025-11-27 07:47:03.690', 20.36),
(2, 1, '2025-11-27 07:57:05.795', 22.20),
(3, 1, '2025-11-27 08:07:08.107', 23.83),
(4, 1, '2025-11-27 08:17:10.178', 24.76),
(5, 1, '2025-11-27 08:27:12.015', 25.21),
(6, 1, '2025-11-27 08:37:14.127', 25.66),
(7, 1, '2025-11-27 08:47:16.082', 26.37),
(8, 1, '2025-11-27 08:57:17.873', 26.92),
(9, 1, '2025-11-27 09:07:19.698', 27.15),
(10, 1, '2025-11-27 09:17:21.500', 25.08),
(11, 1, '2025-11-27 09:27:23.321', 22.70),
(12, 1, '2025-11-27 09:39:14.080', 22.16),
(13, 1, '2025-11-27 09:47:31.958', 22.04),
(14, 1, '2025-11-27 09:57:33.966', 22.08),
(15, 1, '2025-11-27 10:07:35.959', 22.19),
(16, 1, '2025-11-27 10:11:17.586', 22.23),
(17, 1, '2025-11-27 10:15:03.212', 22.08),
(18, 1, '2025-11-27 10:25:05.408', 21.61),
(19, 7, '2025-11-27 10:39:46.032', 19.39),
(20, 7, '2025-11-27 10:49:47.928', 19.20),
(21, 7, '2025-11-28 11:12:12.656', 20.69),
(22, 3, '2025-11-28 11:22:14.675', 20.27),
(23, 3, '2025-11-28 11:32:16.506', 20.48),
(24, 3, '2025-11-28 11:42:18.368', 20.79),
(25, 3, '2025-11-28 11:52:20.262', 21.08),
(26, 3, '2025-11-28 12:02:22.131', 21.32),
(27, 3, '2025-11-28 12:12:24.200', 21.36),
(28, 3, '2025-11-28 12:22:26.294', 21.53),
(29, 3, '2025-11-28 12:32:28.120', 21.65),
(30, 3, '2025-11-28 12:42:29.982', 21.72),
(31, 5, '2025-11-28 13:38:35.459', 21.11),
(32, 5, '2025-11-28 13:48:36.422', 24.07),
(33, 5, '2025-11-28 13:58:38.631', 26.79),
(34, 5, '2025-11-28 14:08:39.524', 28.49),
(35, 5, '2025-11-28 14:18:41.647', 26.94),
(36, 5, '2025-11-28 14:28:43.939', 25.15),
(37, 5, '2025-11-28 14:49:05.692', 24.49),
(38, 5, '2025-11-28 15:20:31.482', 20.93),
(39, 7, '2025-11-28 15:30:33.393', 19.62),
(40, 7, '2025-11-28 15:40:35.229', 20.47),
(41, 7, '2025-11-28 15:50:37.084', 20.12),
(42, 7, '2025-11-28 16:00:39.084', 20.44),
(43, 7, '2025-11-28 16:10:40.963', 20.30),
(44, 7, '2025-11-28 16:20:42.890', 20.00),
(45, 7, '2025-11-28 16:30:44.710', 20.19),
(46, 7, '2025-11-28 16:40:46.541', 20.46),
(47, 1, '2025-12-02 11:34:15.240', 22.82),
(48, 1, '2025-12-02 11:44:15.411', 23.30),
(49, 3, '2025-12-02 11:54:15.584', 23.43),
(50, 3, '2025-12-02 12:04:15.856', 23.56),
(51, 3, '2025-12-02 12:14:16.014', 23.55),
(52, 3, '2025-12-02 12:24:16.338', 23.57),
(53, 3, '2025-12-02 12:34:16.996', 23.63),
(54, 3, '2025-12-02 12:44:17.216', 23.66);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lectura_tvoc`
--

CREATE TABLE `lectura_tvoc` (
  `LecturaID` bigint(20) NOT NULL,
  `SensorID` int(11) NOT NULL,
  `Timestamp` datetime(3) NOT NULL,
  `Valor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lectura_tvoc`
--

INSERT INTO `lectura_tvoc` (`LecturaID`, `SensorID`, `Timestamp`, `Valor`) VALUES
(1, 2, '2025-11-27 07:47:03.702', 0),
(2, 2, '2025-11-27 07:57:05.808', 59),
(3, 2, '2025-11-27 08:07:08.121', 59),
(4, 2, '2025-11-27 08:17:10.192', 41),
(5, 2, '2025-11-27 08:27:12.026', 4),
(6, 2, '2025-11-27 08:37:14.139', 1),
(7, 2, '2025-11-27 08:47:16.090', 0),
(8, 2, '2025-11-27 08:57:17.901', 0),
(9, 2, '2025-11-27 09:07:19.706', 7),
(10, 2, '2025-11-27 09:17:21.507', 20),
(11, 2, '2025-11-27 09:27:23.329', 23),
(12, 2, '2025-11-27 09:39:14.085', 12),
(13, 2, '2025-11-27 09:47:31.967', 3),
(14, 2, '2025-11-27 09:57:33.976', 2),
(15, 2, '2025-11-27 10:07:35.965', 6),
(16, 2, '2025-11-27 10:11:17.591', 0),
(17, 2, '2025-11-27 10:15:03.228', 0),
(18, 2, '2025-11-27 10:25:05.418', 11),
(19, 8, '2025-11-27 10:39:46.041', 0),
(20, 8, '2025-11-27 10:49:47.935', 106),
(21, 8, '2025-11-28 11:12:12.662', 0),
(22, 4, '2025-11-28 11:22:14.690', 17),
(23, 4, '2025-11-28 11:32:16.515', 36),
(24, 4, '2025-11-28 11:42:18.386', 128),
(25, 4, '2025-11-28 11:52:20.270', 206),
(26, 4, '2025-11-28 12:02:22.146', 82),
(27, 4, '2025-11-28 12:12:24.214', 67),
(28, 4, '2025-11-28 12:22:26.310', 56),
(29, 4, '2025-11-28 12:32:28.127', 71),
(30, 4, '2025-11-28 12:42:29.993', 63),
(31, 6, '2025-11-28 13:38:35.469', 1),
(32, 6, '2025-11-28 13:48:36.427', 67),
(33, 6, '2025-11-28 13:58:38.639', 100),
(34, 6, '2025-11-28 14:08:39.529', 159),
(35, 6, '2025-11-28 14:18:41.658', 258),
(36, 6, '2025-11-28 14:28:43.945', 374),
(37, 6, '2025-11-28 14:49:05.702', 360),
(38, 6, '2025-11-28 15:20:31.491', 0),
(39, 8, '2025-11-28 15:30:33.404', 8),
(40, 8, '2025-11-28 15:40:35.241', 24),
(41, 8, '2025-11-28 15:50:37.099', 17),
(42, 8, '2025-11-28 16:00:39.092', 161),
(43, 8, '2025-11-28 16:10:40.968', 30),
(44, 8, '2025-11-28 16:20:42.896', 18),
(45, 8, '2025-11-28 16:30:44.721', 26),
(46, 8, '2025-11-28 16:40:46.549', 30),
(47, 2, '2025-12-02 11:34:15.246', 0),
(48, 2, '2025-12-02 11:44:15.416', 35),
(49, 4, '2025-12-02 11:54:15.590', 84),
(50, 4, '2025-12-02 12:04:15.859', 83),
(51, 4, '2025-12-02 12:14:16.050', 216),
(52, 4, '2025-12-02 12:24:16.347', 178),
(53, 4, '2025-12-02 12:34:17.004', 141),
(54, 4, '2025-12-02 12:44:17.223', 166);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sensor`
--

CREATE TABLE `sensor` (
  `SensorID` int(11) NOT NULL,
  `EstacionID` int(11) NOT NULL,
  `ModeloID` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sensor`
--

INSERT INTO `sensor` (`SensorID`, `EstacionID`, `ModeloID`) VALUES
(1, 1, 'BME280'),
(2, 1, 'CCS811'),
(3, 2, 'BME280'),
(4, 2, 'CCS811'),
(5, 3, 'BME280'),
(6, 3, 'CCS811'),
(7, 4, 'BME280'),
(8, 4, 'CCS811');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `catalogosensor`
--
ALTER TABLE `catalogosensor`
  ADD PRIMARY KEY (`ModeloID`);

--
-- Indices de la tabla `estacion`
--
ALTER TABLE `estacion`
  ADD PRIMARY KEY (`EstacionID`),
  ADD UNIQUE KEY `DeviceMAC` (`DeviceMAC`);

--
-- Indices de la tabla `lectura_eco2`
--
ALTER TABLE `lectura_eco2`
  ADD PRIMARY KEY (`LecturaID`),
  ADD KEY `FK_eCO2_Sensor` (`SensorID`);

--
-- Indices de la tabla `lectura_humedad`
--
ALTER TABLE `lectura_humedad`
  ADD PRIMARY KEY (`LecturaID`),
  ADD KEY `FK_Hum_Sensor` (`SensorID`);

--
-- Indices de la tabla `lectura_temperatura`
--
ALTER TABLE `lectura_temperatura`
  ADD PRIMARY KEY (`LecturaID`),
  ADD KEY `FK_Temp_Sensor` (`SensorID`);

--
-- Indices de la tabla `lectura_tvoc`
--
ALTER TABLE `lectura_tvoc`
  ADD PRIMARY KEY (`LecturaID`),
  ADD KEY `FK_TVOC_Sensor` (`SensorID`);

--
-- Indices de la tabla `sensor`
--
ALTER TABLE `sensor`
  ADD PRIMARY KEY (`SensorID`),
  ADD KEY `FK_Sensor_Estacion` (`EstacionID`),
  ADD KEY `FK_Sensor_Catalogo` (`ModeloID`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `estacion`
--
ALTER TABLE `estacion`
  MODIFY `EstacionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `lectura_eco2`
--
ALTER TABLE `lectura_eco2`
  MODIFY `LecturaID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `lectura_humedad`
--
ALTER TABLE `lectura_humedad`
  MODIFY `LecturaID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `lectura_temperatura`
--
ALTER TABLE `lectura_temperatura`
  MODIFY `LecturaID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `lectura_tvoc`
--
ALTER TABLE `lectura_tvoc`
  MODIFY `LecturaID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `sensor`
--
ALTER TABLE `sensor`
  MODIFY `SensorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `lectura_eco2`
--
ALTER TABLE `lectura_eco2`
  ADD CONSTRAINT `FK_eCO2_Sensor` FOREIGN KEY (`SensorID`) REFERENCES `sensor` (`SensorID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `lectura_humedad`
--
ALTER TABLE `lectura_humedad`
  ADD CONSTRAINT `FK_Hum_Sensor` FOREIGN KEY (`SensorID`) REFERENCES `sensor` (`SensorID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `lectura_temperatura`
--
ALTER TABLE `lectura_temperatura`
  ADD CONSTRAINT `FK_Temp_Sensor` FOREIGN KEY (`SensorID`) REFERENCES `sensor` (`SensorID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `lectura_tvoc`
--
ALTER TABLE `lectura_tvoc`
  ADD CONSTRAINT `FK_TVOC_Sensor` FOREIGN KEY (`SensorID`) REFERENCES `sensor` (`SensorID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sensor`
--
ALTER TABLE `sensor`
  ADD CONSTRAINT `FK_Sensor_Catalogo` FOREIGN KEY (`ModeloID`) REFERENCES `catalogosensor` (`ModeloID`),
  ADD CONSTRAINT `FK_Sensor_Estacion` FOREIGN KEY (`EstacionID`) REFERENCES `estacion` (`EstacionID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
