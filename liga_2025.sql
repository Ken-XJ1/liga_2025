-- phpMyAdmin SQL Dump
-- version 5.2.2-1.fc42
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 04-09-2025 a las 01:24:13
-- Versión del servidor: 10.11.11-MariaDB
-- Versión de PHP: 8.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `liga_2025`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizarEntrenador` (IN `p_equipoId` INT, IN `p_nuevoEntrenador` VARCHAR(100))   BEGIN
  UPDATE equipos SET entrenador = p_nuevoEntrenador WHERE id_equipo = p_equipoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizarEstadoPartido` (IN `p_partidoId` INT, IN `p_nuevoEstado` VARCHAR(20))   BEGIN
  UPDATE partidos SET estado = p_nuevoEstado WHERE id_partido = p_partidoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizarPuntosEquipo` (IN `p_equipoId` INT, IN `p_puntos` INT)   BEGIN
  UPDATE clasificacion SET puntos = p_puntos WHERE id_equipo = p_equipoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminarEquipo` (IN `p_equipoId` INT)   BEGIN
  DELETE FROM equipos WHERE id_equipo = p_equipoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminarGol` (IN `p_golId` INT)   BEGIN
  DELETE FROM goles WHERE id_gol = p_golId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminarJugador` (IN `p_jugadorCedula` VARCHAR(20))   BEGIN
  DELETE FROM jugadores WHERE cedula = p_jugadorCedula;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminarPartido` (IN `p_partidoId` INT)   BEGIN
  DELETE FROM partidos WHERE id_partido = p_partidoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminarTarjeta` (IN `p_tarjetaId` INT)   BEGIN
  DELETE FROM tarjetas WHERE id_tarjeta = p_tarjetaId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_equiposConMasPuntos` (IN `p_puntosMin` INT)   BEGIN
  SELECT e.nombre, c.puntos
  FROM equipos e JOIN clasificacion c ON e.id_equipo = c.id_equipo
  WHERE c.puntos >= p_puntosMin;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_goleadoresPartido` (IN `p_partidoId` INT)   BEGIN
  SELECT j.nombre, j.apellido, g.minuto, g.tipo
  FROM goles g JOIN jugadores j ON g.id_jugador = j.cedula
  WHERE g.id_partido = p_partidoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertarArbitro` (IN `p_nombre` VARCHAR(100), IN `p_apellido` VARCHAR(100), IN `p_nacionalidad` VARCHAR(50), IN `p_fecha_nac` DATE)   BEGIN
  INSERT INTO arbitros (nombre, apellido, nacionalidad, fecha_nacimiento)
  VALUES (p_nombre, p_apellido, p_nacionalidad, p_fecha_nac);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertarEquipo` (IN `p_nombre` VARCHAR(100), IN `p_ciudad` VARCHAR(50), IN `p_estadio` VARCHAR(100), IN `p_fundacion` YEAR, IN `p_presidente` VARCHAR(100), IN `p_entrenador` VARCHAR(100), IN `p_ligaId` INT)   BEGIN
  INSERT INTO equipos (nombre, ciudad, estadio, fundacion, presidente, entrenador, id_liga)
  VALUES (p_nombre, p_ciudad, p_estadio, p_fundacion, p_presidente, p_entrenador, p_ligaId);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertarGol` (IN `p_partidoId` INT, IN `p_jugadorCedula` VARCHAR(20), IN `p_minuto` INT, IN `p_tipo` VARCHAR(20), IN `p_desc` TEXT)   BEGIN
  INSERT INTO goles (id_partido, id_jugador, minuto, tipo, descripcion)
  VALUES (p_partidoId, p_jugadorCedula, p_minuto, p_tipo, p_desc);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertarJugador` (IN `p_cedula` VARCHAR(20), IN `p_nombre` VARCHAR(100), IN `p_apellido` VARCHAR(100), IN `p_fecha_nac` DATE, IN `p_nacionalidad` VARCHAR(50), IN `p_posicion` VARCHAR(20), IN `p_numero` INT, IN `p_equipoId` INT)   BEGIN
  INSERT INTO jugadores (cedula, nombre, apellido, fecha_nacimiento, nacionalidad, posicion, numero_camiseta, id_equipo)
  VALUES (p_cedula, p_nombre, p_apellido, p_fecha_nac, p_nacionalidad, p_posicion, p_numero, p_equipoId);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertarPartido` (IN `p_fecha` DATETIME, IN `p_estadio` VARCHAR(100), IN `p_localId` INT, IN `p_visitaId` INT, IN `p_golesL` INT, IN `p_golesV` INT, IN `p_jornada` INT, IN `p_ligaId` INT, IN `p_estado` VARCHAR(20))   BEGIN
  INSERT INTO partidos (fecha_hora, estadio, id_equipo_local, id_equipo_visitante, goles_local, goles_visitante, jornada, id_liga, estado)
  VALUES (p_fecha, p_estadio, p_localId, p_visitaId, p_golesL, p_golesV, p_jornada, p_ligaId, p_estado);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertarTarjeta` (IN `p_partidoId` INT, IN `p_jugadorCedula` VARCHAR(20), IN `p_minuto` INT, IN `p_tipo` VARCHAR(20), IN `p_motivo` TEXT)   BEGIN
  INSERT INTO tarjetas (id_partido, id_jugador, minuto, tipo, motivo)
  VALUES (p_partidoId, p_jugadorCedula, p_minuto, p_tipo, p_motivo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_jugadoresConRojas` ()   BEGIN
  SELECT j.cedula, CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(t.id_tarjeta) AS rojas
  FROM jugadores j JOIN tarjetas t ON j.cedula = t.id_jugador
  WHERE t.tipo='Roja'
  GROUP BY j.cedula, j.nombre, j.apellido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_jugadoresEquipo` (IN `equipoId` INT)   BEGIN
  SELECT * FROM jugadores WHERE id_equipo = equipoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_jugadoresExtranjeros` ()   BEGIN
  SELECT * FROM jugadores WHERE nacionalidad <> 'Colombia';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listarEquipos` ()   BEGIN
  SELECT * FROM equipos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_maximoGoleador` ()   BEGIN
  SELECT j.cedula, CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(g.id_gol) AS goles
  FROM jugadores j LEFT JOIN goles g ON j.cedula = g.id_jugador
  GROUP BY j.cedula, j.nombre, j.apellido
  ORDER BY goles DESC LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtenerArbitrosPorPartido` (IN `p_partidoId` INT)   BEGIN
  SELECT a.nombre, a.apellido
  FROM arbitros a JOIN arbitros_partido ap ON a.id_arbitro = ap.id_arbitro
  WHERE ap.id_partido = p_partidoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtenerClasificacionEquipo` (IN `p_equipoId` INT)   BEGIN
  SELECT * FROM clasificacion WHERE id_equipo = p_equipoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtenerEquipos` ()   BEGIN
  SELECT * FROM equipos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtenerJugadoresPorEquipo` (IN `p_equipoId` INT)   BEGIN
  SELECT * FROM jugadores WHERE id_equipo = p_equipoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtenerPartidosPorLiga` (IN `p_ligaId` INT)   BEGIN
  SELECT * FROM partidos WHERE id_liga = p_ligaId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_partidosFinalizados` ()   BEGIN
  SELECT * FROM partidos WHERE estado = 'Finalizado';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_partidosProgramados` ()   BEGIN
  SELECT * FROM partidos WHERE estado = 'Programado';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rankingGoleadores` ()   BEGIN
  SELECT j.cedula, CONCAT(j.nombre,' ',j.apellido) AS jugador, e.nombre AS equipo, COUNT(g.id_gol) AS goles
  FROM jugadores j
  LEFT JOIN goles g ON j.cedula = g.id_jugador
  LEFT JOIN equipos e ON j.id_equipo = e.id_equipo
  GROUP BY j.cedula, j.nombre, j.apellido, e.nombre
  ORDER BY goles DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_resultadosEquipo` (IN `p_equipoId` INT)   BEGIN
  SELECT p.id_partido, p.goles_local, p.goles_visitante, p.estado
  FROM partidos p
  WHERE p.id_equipo_local = p_equipoId OR p.id_equipo_visitante = p_equipoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_totalGolesJugador` (IN `p_jugadorCedula` VARCHAR(20))   BEGIN
  SELECT COUNT(*) AS goles FROM goles WHERE id_jugador = p_jugadorCedula;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_totalTarjetasJugador` (IN `p_jugadorCedula` VARCHAR(20))   BEGIN
  SELECT COUNT(*) AS tarjetas FROM tarjetas WHERE id_jugador = p_jugadorCedula;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `arbitros`
--

CREATE TABLE `arbitros` (
  `id_arbitro` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `nacionalidad` varchar(50) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `arbitros`
--

INSERT INTO `arbitros` (`id_arbitro`, `nombre`, `apellido`, `nacionalidad`, `fecha_nacimiento`, `created_at`, `updated_at`) VALUES
(1, 'Wilmar', 'Roldán', 'Colombia', '1980-01-25', '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
(2, 'Andrés', 'Cuesta', 'Colombia', '1985-03-12', '2025-09-04 01:15:11', '2025-09-04 01:15:11');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `arbitros_con_total_de_partidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `arbitros_con_total_de_partidos` (
`arbitro` varchar(201)
,`total_partidos` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `arbitros_en_partidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `arbitros_en_partidos` (
`id_arbitro_partido` int(11)
,`arbitro` varchar(201)
,`id_partido` int(11)
,`fecha_hora` datetime
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `arbitros_partido`
--

CREATE TABLE `arbitros_partido` (
  `id_arbitro_partido` int(11) NOT NULL,
  `id_arbitro` int(11) DEFAULT NULL,
  `id_partido` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `arbitros_partido`
--

INSERT INTO `arbitros_partido` (`id_arbitro_partido`, `id_arbitro`, `id_partido`, `created_at`) VALUES
(1, 1, 1, '2025-09-04 01:15:11'),
(2, 2, 2, '2025-09-04 01:15:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clasificacion`
--

CREATE TABLE `clasificacion` (
  `id_clasificacion` int(11) NOT NULL,
  `id_liga` int(11) DEFAULT NULL,
  `id_equipo` int(11) DEFAULT NULL,
  `partidos_jugados` int(11) DEFAULT 0,
  `partidos_ganados` int(11) DEFAULT 0,
  `partidos_empatados` int(11) DEFAULT 0,
  `partidos_perdidos` int(11) DEFAULT 0,
  `goles_a_favor` int(11) DEFAULT 0,
  `goles_en_contra` int(11) DEFAULT 0,
  `diferencia_goles` int(11) GENERATED ALWAYS AS (`goles_a_favor` - `goles_en_contra`) STORED,
  `puntos` int(11) DEFAULT 0,
  `temporada` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clasificacion`
--

INSERT INTO `clasificacion` (`id_clasificacion`, `id_liga`, `id_equipo`, `partidos_jugados`, `partidos_ganados`, `partidos_empatados`, `partidos_perdidos`, `goles_a_favor`, `goles_en_contra`, `puntos`, `temporada`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 1, 0, 0, 2, 1, 3, '2025', '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
(2, 1, 2, 2, 0, 2, 0, 1, 1, 2, '2025', '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
(3, 1, 3, 3, 1, 0, 2, 2, 5, 3, '2025', '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
(4, 1, 4, 3, 2, 0, 1, 6, 4, 6, '2025', '2025-09-04 01:15:11', '2025-09-04 01:15:11');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `clasificacion_completa`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `clasificacion_completa` (
`id_clasificacion` int(11)
,`liga` varchar(100)
,`equipo` varchar(100)
,`partidos_jugados` int(11)
,`puntos` int(11)
,`diferencia_goles` int(11)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipos`
--

CREATE TABLE `equipos` (
  `id_equipo` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  `estadio` varchar(100) DEFAULT NULL,
  `fundacion` year(4) DEFAULT NULL,
  `presidente` varchar(100) DEFAULT NULL,
  `entrenador` varchar(100) DEFAULT NULL,
  `id_liga` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipos`
--

INSERT INTO `equipos` (`id_equipo`, `nombre`, `ciudad`, `estadio`, `fundacion`, `presidente`, `entrenador`, `id_liga`, `created_at`, `updated_at`) VALUES
(1, 'Atlético Nacional', 'Medellín', 'Atanasio Girardot', '1947', 'Presidente A', 'Entrenador A', 1, '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
(2, 'Millonarios FC', 'Bogotá', 'El Campín', '1946', 'Presidente B', 'Entrenador B', 1, '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
(3, 'Deportivo Cali', 'Cali', 'Palmaseca', '1912', 'Presidente C', 'Entrenador C', 1, '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
(4, 'Junior FC', 'Barranquilla', 'Metropolitano', '1924', 'Presidente D', 'Entrenador D', 1, '2025-09-04 01:15:11', '2025-09-04 01:15:11');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `equipos_con_derrotas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `equipos_con_derrotas` (
`equipo` varchar(100)
,`derrotas` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `equipos_con_empates`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `equipos_con_empates` (
`equipo` varchar(100)
,`empates` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `equipos_con_liga`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `equipos_con_liga` (
`id_equipo` int(11)
,`equipo` varchar(100)
,`ciudad` varchar(50)
,`liga` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `equipos_con_partidos_jugados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `equipos_con_partidos_jugados` (
`equipo` varchar(100)
,`partidos_jugados` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `equipos_con_puntos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `equipos_con_puntos` (
`equipo` varchar(100)
,`puntos` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `equipos_con_victorias`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `equipos_con_victorias` (
`equipo` varchar(100)
,`victorias` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `equipos_partidos_sin_recibir_gol`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `equipos_partidos_sin_recibir_gol` (
`equipo` varchar(100)
,`partidos_sin_gol` decimal(23,0)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `goles`
--

CREATE TABLE `goles` (
  `id_gol` int(11) NOT NULL,
  `id_partido` int(11) DEFAULT NULL,
  `id_jugador` varchar(20) DEFAULT NULL,
  `minuto` int(11) DEFAULT NULL,
  `tipo` enum('Normal','Penalti','Falta directa','Autogol') DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `goles`
--

INSERT INTO `goles` (`id_gol`, `id_partido`, `id_jugador`, `minuto`, `tipo`, `descripcion`, `created_at`) VALUES
(1, 1, '1001002', 30, 'Normal', 'Gol de cabeza en tiro de esquina', '2025-09-04 01:15:11'),
(2, 1, '2002002', 55, 'Penalti', 'Gol de penalti bien ejecutado', '2025-09-04 01:15:11'),
(3, 3, '4004001', 12, 'Normal', 'Remate dentro del área', '2025-09-04 01:15:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugadores`
--

CREATE TABLE `jugadores` (
  `cedula` varchar(20) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `nacionalidad` varchar(50) DEFAULT NULL,
  `posicion` enum('Portero','Defensa','Centrocampista','Delantero') DEFAULT NULL,
  `numero_camiseta` int(11) DEFAULT NULL,
  `id_equipo` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `jugadores`
--

INSERT INTO `jugadores` (`cedula`, `nombre`, `apellido`, `fecha_nacimiento`, `nacionalidad`, `posicion`, `numero_camiseta`, `id_equipo`, `created_at`, `updated_at`) VALUES
('1001001', 'David', 'Ospina', '1988-08-31', 'Colombia', 'Portero', 1, 1, '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
('1001002', 'Yerson', 'Mosquera', '1994-02-04', 'Colombia', 'Defensa', 3, 1, '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
('2002001', 'Juan', 'Pérez', '1995-05-20', 'Colombia', 'Centrocampista', 8, 2, '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
('2002002', 'Carlos', 'López', '1997-10-15', 'Colombia', 'Delantero', 9, 2, '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
('3003001', 'Jorge', 'Ramírez', '1994-06-01', 'Colombia', 'Defensa', 5, 3, '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
('4004001', 'Miguel', 'Ángel', '1996-03-10', 'Argentina', 'Delantero', 11, 4, '2025-09-04 01:15:11', '2025-09-04 01:15:11');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `jugadores_con_equipo_y_liga`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `jugadores_con_equipo_y_liga` (
`cedula` varchar(20)
,`jugador` varchar(201)
,`posicion` enum('Portero','Defensa','Centrocampista','Delantero')
,`equipo` varchar(100)
,`liga` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `jugadores_con_goles_de_penalti`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `jugadores_con_goles_de_penalti` (
`jugador` varchar(201)
,`goles_penalti` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `jugadores_con_mas_de_5_goles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `jugadores_con_mas_de_5_goles` (
`jugador` varchar(201)
,`goles` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `jugadores_con_posicion_y_equipo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `jugadores_con_posicion_y_equipo` (
`jugador` varchar(201)
,`posicion` enum('Portero','Defensa','Centrocampista','Delantero')
,`equipo` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `jugadores_con_tarjeta_roja`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `jugadores_con_tarjeta_roja` (
`jugador` varchar(201)
,`rojas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `jugadores_con_total_de_goles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `jugadores_con_total_de_goles` (
`jugador` varchar(201)
,`total_goles` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `jugadores_con_total_de_tarjetas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `jugadores_con_total_de_tarjetas` (
`jugador` varchar(201)
,`total_tarjetas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `jugadores_extranjeros`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `jugadores_extranjeros` (
`jugador` varchar(201)
,`nacionalidad` varchar(50)
,`equipo` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `jugador_maximo_goleador`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `jugador_maximo_goleador` (
`jugador` varchar(201)
,`total_goles` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ligas`
--

CREATE TABLE `ligas` (
  `id_liga` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `pais` varchar(50) DEFAULT NULL,
  `temporada` varchar(20) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ligas`
--

INSERT INTO `ligas` (`id_liga`, `nombre`, `pais`, `temporada`, `fecha_inicio`, `fecha_fin`, `created_at`, `updated_at`) VALUES
(1, 'Liga Profesional Colombiana', 'Colombia', '2025', '2025-01-20', '2025-12-10', '2025-09-04 01:15:11', '2025-09-04 01:15:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partidos`
--

CREATE TABLE `partidos` (
  `id_partido` int(11) NOT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  `estadio` varchar(100) DEFAULT NULL,
  `id_equipo_local` int(11) DEFAULT NULL,
  `id_equipo_visitante` int(11) DEFAULT NULL,
  `goles_local` int(11) DEFAULT 0,
  `goles_visitante` int(11) DEFAULT 0,
  `jornada` int(11) DEFAULT NULL,
  `id_liga` int(11) DEFAULT NULL,
  `estado` enum('Programado','En juego','Finalizado','Suspendido') DEFAULT 'Programado',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `partidos`
--

INSERT INTO `partidos` (`id_partido`, `fecha_hora`, `estadio`, `id_equipo_local`, `id_equipo_visitante`, `goles_local`, `goles_visitante`, `jornada`, `id_liga`, `estado`, `created_at`, `updated_at`) VALUES
(1, '2025-02-01 18:00:00', 'Atanasio Girardot', 1, 2, 2, 1, 1, 1, 'Finalizado', '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
(2, '2025-02-08 20:00:00', 'El Campín', 2, 3, 0, 0, 2, 1, 'Finalizado', '2025-09-04 01:15:11', '2025-09-04 01:15:11'),
(3, '2025-02-15 17:00:00', 'Palmaseca', 3, 4, 1, 3, 3, 1, 'Finalizado', '2025-09-04 01:15:11', '2025-09-04 01:15:11');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `partidos_con_empate`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `partidos_con_empate` (
`id_partido` int(11)
,`fecha_hora` datetime
,`estadio` varchar(100)
,`id_equipo_local` int(11)
,`id_equipo_visitante` int(11)
,`goles_local` int(11)
,`goles_visitante` int(11)
,`jornada` int(11)
,`id_liga` int(11)
,`estado` enum('Programado','En juego','Finalizado','Suspendido')
,`created_at` timestamp
,`updated_at` timestamp
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `partidos_con_mas_de_4_goles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `partidos_con_mas_de_4_goles` (
`id_partido` int(11)
,`fecha_hora` datetime
,`estadio` varchar(100)
,`id_equipo_local` int(11)
,`id_equipo_visitante` int(11)
,`goles_local` int(11)
,`goles_visitante` int(11)
,`jornada` int(11)
,`id_liga` int(11)
,`estado` enum('Programado','En juego','Finalizado','Suspendido')
,`created_at` timestamp
,`updated_at` timestamp
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `partidos_detalle`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `partidos_detalle` (
`id_partido` int(11)
,`fecha_hora` datetime
,`equipo_local` varchar(100)
,`equipo_visitante` varchar(100)
,`goles_local` int(11)
,`goles_visitante` int(11)
,`estado` enum('Programado','En juego','Finalizado','Suspendido')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `partidos_finalizados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `partidos_finalizados` (
`id_partido` int(11)
,`fecha_hora` datetime
,`estadio` varchar(100)
,`id_equipo_local` int(11)
,`id_equipo_visitante` int(11)
,`goles_local` int(11)
,`goles_visitante` int(11)
,`jornada` int(11)
,`id_liga` int(11)
,`estado` enum('Programado','En juego','Finalizado','Suspendido')
,`created_at` timestamp
,`updated_at` timestamp
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `partidos_programados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `partidos_programados` (
`id_partido` int(11)
,`fecha_hora` datetime
,`estadio` varchar(100)
,`id_equipo_local` int(11)
,`id_equipo_visitante` int(11)
,`goles_local` int(11)
,`goles_visitante` int(11)
,`jornada` int(11)
,`id_liga` int(11)
,`estado` enum('Programado','En juego','Finalizado','Suspendido')
,`created_at` timestamp
,`updated_at` timestamp
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `partidos_suspendidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `partidos_suspendidos` (
`id_partido` int(11)
,`fecha_hora` datetime
,`estadio` varchar(100)
,`id_equipo_local` int(11)
,`id_equipo_visitante` int(11)
,`goles_local` int(11)
,`goles_visitante` int(11)
,`jornada` int(11)
,`id_liga` int(11)
,`estado` enum('Programado','En juego','Finalizado','Suspendido')
,`created_at` timestamp
,`updated_at` timestamp
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarjetas`
--

CREATE TABLE `tarjetas` (
  `id_tarjeta` int(11) NOT NULL,
  `id_partido` int(11) DEFAULT NULL,
  `id_jugador` varchar(20) DEFAULT NULL,
  `minuto` int(11) DEFAULT NULL,
  `tipo` enum('Amarilla','Roja') DEFAULT NULL,
  `motivo` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tarjetas`
--

INSERT INTO `tarjetas` (`id_tarjeta`, `id_partido`, `id_jugador`, `minuto`, `tipo`, `motivo`, `created_at`) VALUES
(1, 1, '1001001', 70, 'Amarilla', 'Reclamos al árbitro', '2025-09-04 01:15:11'),
(2, 2, '3003001', 40, 'Roja', 'Falta fuerte sobre delantero', '2025-09-04 01:15:11');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `arbitros`
--
ALTER TABLE `arbitros`
  ADD PRIMARY KEY (`id_arbitro`);

--
-- Indices de la tabla `arbitros_partido`
--
ALTER TABLE `arbitros_partido`
  ADD PRIMARY KEY (`id_arbitro_partido`),
  ADD KEY `idx_ap_arbitro` (`id_arbitro`),
  ADD KEY `idx_ap_partido` (`id_partido`);

--
-- Indices de la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  ADD PRIMARY KEY (`id_clasificacion`),
  ADD KEY `idx_clasificacion_liga` (`id_liga`),
  ADD KEY `idx_clasificacion_equipo` (`id_equipo`);

--
-- Indices de la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD PRIMARY KEY (`id_equipo`),
  ADD KEY `idx_equipos_liga` (`id_liga`);

--
-- Indices de la tabla `goles`
--
ALTER TABLE `goles`
  ADD PRIMARY KEY (`id_gol`),
  ADD KEY `idx_goles_partido` (`id_partido`),
  ADD KEY `idx_goles_jugador` (`id_jugador`);

--
-- Indices de la tabla `jugadores`
--
ALTER TABLE `jugadores`
  ADD PRIMARY KEY (`cedula`),
  ADD KEY `idx_jugadores_equipo` (`id_equipo`);

--
-- Indices de la tabla `ligas`
--
ALTER TABLE `ligas`
  ADD PRIMARY KEY (`id_liga`);

--
-- Indices de la tabla `partidos`
--
ALTER TABLE `partidos`
  ADD PRIMARY KEY (`id_partido`),
  ADD KEY `idx_partidos_liga` (`id_liga`),
  ADD KEY `idx_partidos_local` (`id_equipo_local`),
  ADD KEY `idx_partidos_visitante` (`id_equipo_visitante`);

--
-- Indices de la tabla `tarjetas`
--
ALTER TABLE `tarjetas`
  ADD PRIMARY KEY (`id_tarjeta`),
  ADD KEY `idx_tarjetas_partido` (`id_partido`),
  ADD KEY `idx_tarjetas_jugador` (`id_jugador`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `arbitros`
--
ALTER TABLE `arbitros`
  MODIFY `id_arbitro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `arbitros_partido`
--
ALTER TABLE `arbitros_partido`
  MODIFY `id_arbitro_partido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  MODIFY `id_clasificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `equipos`
--
ALTER TABLE `equipos`
  MODIFY `id_equipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `goles`
--
ALTER TABLE `goles`
  MODIFY `id_gol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ligas`
--
ALTER TABLE `ligas`
  MODIFY `id_liga` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `partidos`
--
ALTER TABLE `partidos`
  MODIFY `id_partido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tarjetas`
--
ALTER TABLE `tarjetas`
  MODIFY `id_tarjeta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- --------------------------------------------------------

--
-- Estructura para la vista `arbitros_con_total_de_partidos`
--
DROP TABLE IF EXISTS `arbitros_con_total_de_partidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `arbitros_con_total_de_partidos`  AS SELECT concat(`a`.`nombre`,' ',`a`.`apellido`) AS `arbitro`, count(`ap`.`id_partido`) AS `total_partidos` FROM (`arbitros` `a` left join `arbitros_partido` `ap` on(`a`.`id_arbitro` = `ap`.`id_arbitro`)) GROUP BY `a`.`id_arbitro`, `a`.`nombre`, `a`.`apellido` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `arbitros_en_partidos`
--
DROP TABLE IF EXISTS `arbitros_en_partidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `arbitros_en_partidos`  AS SELECT `ap`.`id_arbitro_partido` AS `id_arbitro_partido`, concat(`a`.`nombre`,' ',`a`.`apellido`) AS `arbitro`, `p`.`id_partido` AS `id_partido`, `p`.`fecha_hora` AS `fecha_hora` FROM ((`arbitros_partido` `ap` join `arbitros` `a` on(`ap`.`id_arbitro` = `a`.`id_arbitro`)) join `partidos` `p` on(`ap`.`id_partido` = `p`.`id_partido`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `clasificacion_completa`
--
DROP TABLE IF EXISTS `clasificacion_completa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `clasificacion_completa`  AS SELECT `c`.`id_clasificacion` AS `id_clasificacion`, `l`.`nombre` AS `liga`, `e`.`nombre` AS `equipo`, `c`.`partidos_jugados` AS `partidos_jugados`, `c`.`puntos` AS `puntos`, `c`.`diferencia_goles` AS `diferencia_goles` FROM ((`clasificacion` `c` join `ligas` `l` on(`c`.`id_liga` = `l`.`id_liga`)) join `equipos` `e` on(`c`.`id_equipo` = `e`.`id_equipo`)) ORDER BY `c`.`puntos` DESC, `c`.`diferencia_goles` DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `equipos_con_derrotas`
--
DROP TABLE IF EXISTS `equipos_con_derrotas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `equipos_con_derrotas`  AS SELECT `e`.`nombre` AS `equipo`, `c`.`partidos_perdidos` AS `derrotas` FROM (`equipos` `e` join `clasificacion` `c` on(`e`.`id_equipo` = `c`.`id_equipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `equipos_con_empates`
--
DROP TABLE IF EXISTS `equipos_con_empates`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `equipos_con_empates`  AS SELECT `e`.`nombre` AS `equipo`, `c`.`partidos_empatados` AS `empates` FROM (`equipos` `e` join `clasificacion` `c` on(`e`.`id_equipo` = `c`.`id_equipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `equipos_con_liga`
--
DROP TABLE IF EXISTS `equipos_con_liga`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `equipos_con_liga`  AS SELECT `e`.`id_equipo` AS `id_equipo`, `e`.`nombre` AS `equipo`, `e`.`ciudad` AS `ciudad`, `l`.`nombre` AS `liga` FROM (`equipos` `e` join `ligas` `l` on(`e`.`id_liga` = `l`.`id_liga`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `equipos_con_partidos_jugados`
--
DROP TABLE IF EXISTS `equipos_con_partidos_jugados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `equipos_con_partidos_jugados`  AS SELECT `e`.`nombre` AS `equipo`, `c`.`partidos_jugados` AS `partidos_jugados` FROM (`equipos` `e` join `clasificacion` `c` on(`e`.`id_equipo` = `c`.`id_equipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `equipos_con_puntos`
--
DROP TABLE IF EXISTS `equipos_con_puntos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `equipos_con_puntos`  AS SELECT `e`.`nombre` AS `equipo`, `c`.`puntos` AS `puntos` FROM (`equipos` `e` join `clasificacion` `c` on(`e`.`id_equipo` = `c`.`id_equipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `equipos_con_victorias`
--
DROP TABLE IF EXISTS `equipos_con_victorias`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `equipos_con_victorias`  AS SELECT `e`.`nombre` AS `equipo`, `c`.`partidos_ganados` AS `victorias` FROM (`equipos` `e` join `clasificacion` `c` on(`e`.`id_equipo` = `c`.`id_equipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `equipos_partidos_sin_recibir_gol`
--
DROP TABLE IF EXISTS `equipos_partidos_sin_recibir_gol`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `equipos_partidos_sin_recibir_gol`  AS SELECT `e`.`nombre` AS `equipo`, coalesce(sum(case when `p`.`id_equipo_local` = `e`.`id_equipo` and `p`.`goles_visitante` = 0 then 1 else 0 end),0) + coalesce(sum(case when `p`.`id_equipo_visitante` = `e`.`id_equipo` and `p`.`goles_local` = 0 then 1 else 0 end),0) AS `partidos_sin_gol` FROM (`equipos` `e` left join `partidos` `p` on(`p`.`id_equipo_local` = `e`.`id_equipo` or `p`.`id_equipo_visitante` = `e`.`id_equipo`)) GROUP BY `e`.`id_equipo`, `e`.`nombre` ORDER BY coalesce(sum(case when `p`.`id_equipo_local` = `e`.`id_equipo` and `p`.`goles_visitante` = 0 then 1 else 0 end),0) + coalesce(sum(case when `p`.`id_equipo_visitante` = `e`.`id_equipo` and `p`.`goles_local` = 0 then 1 else 0 end),0) DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `jugadores_con_equipo_y_liga`
--
DROP TABLE IF EXISTS `jugadores_con_equipo_y_liga`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jugadores_con_equipo_y_liga`  AS SELECT `j`.`cedula` AS `cedula`, concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, `j`.`posicion` AS `posicion`, `e`.`nombre` AS `equipo`, `l`.`nombre` AS `liga` FROM ((`jugadores` `j` join `equipos` `e` on(`j`.`id_equipo` = `e`.`id_equipo`)) join `ligas` `l` on(`e`.`id_liga` = `l`.`id_liga`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `jugadores_con_goles_de_penalti`
--
DROP TABLE IF EXISTS `jugadores_con_goles_de_penalti`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jugadores_con_goles_de_penalti`  AS SELECT concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, count(`g`.`id_gol`) AS `goles_penalti` FROM (`jugadores` `j` left join `goles` `g` on(`j`.`cedula` = `g`.`id_jugador` and `g`.`tipo` = 'Penalti')) GROUP BY `j`.`cedula`, `j`.`nombre`, `j`.`apellido` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `jugadores_con_mas_de_5_goles`
--
DROP TABLE IF EXISTS `jugadores_con_mas_de_5_goles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jugadores_con_mas_de_5_goles`  AS SELECT concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, count(`g`.`id_gol`) AS `goles` FROM (`jugadores` `j` left join `goles` `g` on(`j`.`cedula` = `g`.`id_jugador`)) GROUP BY `j`.`cedula`, `j`.`nombre`, `j`.`apellido` HAVING `goles` > 5 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `jugadores_con_posicion_y_equipo`
--
DROP TABLE IF EXISTS `jugadores_con_posicion_y_equipo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jugadores_con_posicion_y_equipo`  AS SELECT concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, `j`.`posicion` AS `posicion`, `e`.`nombre` AS `equipo` FROM (`jugadores` `j` join `equipos` `e` on(`j`.`id_equipo` = `e`.`id_equipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `jugadores_con_tarjeta_roja`
--
DROP TABLE IF EXISTS `jugadores_con_tarjeta_roja`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jugadores_con_tarjeta_roja`  AS SELECT concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, count(`t`.`id_tarjeta`) AS `rojas` FROM (`jugadores` `j` left join `tarjetas` `t` on(`j`.`cedula` = `t`.`id_jugador` and `t`.`tipo` = 'Roja')) GROUP BY `j`.`cedula`, `j`.`nombre`, `j`.`apellido` HAVING `rojas` > 0 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `jugadores_con_total_de_goles`
--
DROP TABLE IF EXISTS `jugadores_con_total_de_goles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jugadores_con_total_de_goles`  AS SELECT concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, count(`g`.`id_gol`) AS `total_goles` FROM (`jugadores` `j` left join `goles` `g` on(`j`.`cedula` = `g`.`id_jugador`)) GROUP BY `j`.`cedula`, `j`.`nombre`, `j`.`apellido` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `jugadores_con_total_de_tarjetas`
--
DROP TABLE IF EXISTS `jugadores_con_total_de_tarjetas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jugadores_con_total_de_tarjetas`  AS SELECT concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, count(`t`.`id_tarjeta`) AS `total_tarjetas` FROM (`jugadores` `j` left join `tarjetas` `t` on(`j`.`cedula` = `t`.`id_jugador`)) GROUP BY `j`.`cedula`, `j`.`nombre`, `j`.`apellido` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `jugadores_extranjeros`
--
DROP TABLE IF EXISTS `jugadores_extranjeros`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jugadores_extranjeros`  AS SELECT concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, `j`.`nacionalidad` AS `nacionalidad`, `e`.`nombre` AS `equipo` FROM (`jugadores` `j` join `equipos` `e` on(`j`.`id_equipo` = `e`.`id_equipo`)) WHERE `j`.`nacionalidad` <> 'Colombia' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `jugador_maximo_goleador`
--
DROP TABLE IF EXISTS `jugador_maximo_goleador`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jugador_maximo_goleador`  AS SELECT concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, count(`g`.`id_gol`) AS `total_goles` FROM (`jugadores` `j` left join `goles` `g` on(`j`.`cedula` = `g`.`id_jugador`)) GROUP BY `j`.`cedula`, `j`.`nombre`, `j`.`apellido` ORDER BY count(`g`.`id_gol`) DESC LIMIT 0, 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `partidos_con_empate`
--
DROP TABLE IF EXISTS `partidos_con_empate`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `partidos_con_empate`  AS SELECT `p`.`id_partido` AS `id_partido`, `p`.`fecha_hora` AS `fecha_hora`, `p`.`estadio` AS `estadio`, `p`.`id_equipo_local` AS `id_equipo_local`, `p`.`id_equipo_visitante` AS `id_equipo_visitante`, `p`.`goles_local` AS `goles_local`, `p`.`goles_visitante` AS `goles_visitante`, `p`.`jornada` AS `jornada`, `p`.`id_liga` AS `id_liga`, `p`.`estado` AS `estado`, `p`.`created_at` AS `created_at`, `p`.`updated_at` AS `updated_at` FROM `partidos` AS `p` WHERE `p`.`goles_local` = `p`.`goles_visitante` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `partidos_con_mas_de_4_goles`
--
DROP TABLE IF EXISTS `partidos_con_mas_de_4_goles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `partidos_con_mas_de_4_goles`  AS SELECT `p`.`id_partido` AS `id_partido`, `p`.`fecha_hora` AS `fecha_hora`, `p`.`estadio` AS `estadio`, `p`.`id_equipo_local` AS `id_equipo_local`, `p`.`id_equipo_visitante` AS `id_equipo_visitante`, `p`.`goles_local` AS `goles_local`, `p`.`goles_visitante` AS `goles_visitante`, `p`.`jornada` AS `jornada`, `p`.`id_liga` AS `id_liga`, `p`.`estado` AS `estado`, `p`.`created_at` AS `created_at`, `p`.`updated_at` AS `updated_at` FROM `partidos` AS `p` WHERE `p`.`goles_local` + `p`.`goles_visitante` > 4 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `partidos_detalle`
--
DROP TABLE IF EXISTS `partidos_detalle`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `partidos_detalle`  AS SELECT `p`.`id_partido` AS `id_partido`, `p`.`fecha_hora` AS `fecha_hora`, `el`.`nombre` AS `equipo_local`, `ev`.`nombre` AS `equipo_visitante`, `p`.`goles_local` AS `goles_local`, `p`.`goles_visitante` AS `goles_visitante`, `p`.`estado` AS `estado` FROM ((`partidos` `p` join `equipos` `el` on(`p`.`id_equipo_local` = `el`.`id_equipo`)) join `equipos` `ev` on(`p`.`id_equipo_visitante` = `ev`.`id_equipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `partidos_finalizados`
--
DROP TABLE IF EXISTS `partidos_finalizados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `partidos_finalizados`  AS SELECT `partidos`.`id_partido` AS `id_partido`, `partidos`.`fecha_hora` AS `fecha_hora`, `partidos`.`estadio` AS `estadio`, `partidos`.`id_equipo_local` AS `id_equipo_local`, `partidos`.`id_equipo_visitante` AS `id_equipo_visitante`, `partidos`.`goles_local` AS `goles_local`, `partidos`.`goles_visitante` AS `goles_visitante`, `partidos`.`jornada` AS `jornada`, `partidos`.`id_liga` AS `id_liga`, `partidos`.`estado` AS `estado`, `partidos`.`created_at` AS `created_at`, `partidos`.`updated_at` AS `updated_at` FROM `partidos` WHERE `partidos`.`estado` = 'Finalizado' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `partidos_programados`
--
DROP TABLE IF EXISTS `partidos_programados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `partidos_programados`  AS SELECT `partidos`.`id_partido` AS `id_partido`, `partidos`.`fecha_hora` AS `fecha_hora`, `partidos`.`estadio` AS `estadio`, `partidos`.`id_equipo_local` AS `id_equipo_local`, `partidos`.`id_equipo_visitante` AS `id_equipo_visitante`, `partidos`.`goles_local` AS `goles_local`, `partidos`.`goles_visitante` AS `goles_visitante`, `partidos`.`jornada` AS `jornada`, `partidos`.`id_liga` AS `id_liga`, `partidos`.`estado` AS `estado`, `partidos`.`created_at` AS `created_at`, `partidos`.`updated_at` AS `updated_at` FROM `partidos` WHERE `partidos`.`estado` = 'Programado' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `partidos_suspendidos`
--
DROP TABLE IF EXISTS `partidos_suspendidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `partidos_suspendidos`  AS SELECT `partidos`.`id_partido` AS `id_partido`, `partidos`.`fecha_hora` AS `fecha_hora`, `partidos`.`estadio` AS `estadio`, `partidos`.`id_equipo_local` AS `id_equipo_local`, `partidos`.`id_equipo_visitante` AS `id_equipo_visitante`, `partidos`.`goles_local` AS `goles_local`, `partidos`.`goles_visitante` AS `goles_visitante`, `partidos`.`jornada` AS `jornada`, `partidos`.`id_liga` AS `id_liga`, `partidos`.`estado` AS `estado`, `partidos`.`created_at` AS `created_at`, `partidos`.`updated_at` AS `updated_at` FROM `partidos` WHERE `partidos`.`estado` = 'Suspendido' ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `arbitros_partido`
--
ALTER TABLE `arbitros_partido`
  ADD CONSTRAINT `fk_ap_arbitro` FOREIGN KEY (`id_arbitro`) REFERENCES `arbitros` (`id_arbitro`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ap_partido` FOREIGN KEY (`id_partido`) REFERENCES `partidos` (`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `clasificacion`
--
ALTER TABLE `clasificacion`
  ADD CONSTRAINT `fk_clasificacion_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_clasificacion_liga` FOREIGN KEY (`id_liga`) REFERENCES `ligas` (`id_liga`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD CONSTRAINT `fk_equipos_liga` FOREIGN KEY (`id_liga`) REFERENCES `ligas` (`id_liga`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `goles`
--
ALTER TABLE `goles`
  ADD CONSTRAINT `fk_goles_jugador` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`cedula`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_goles_partido` FOREIGN KEY (`id_partido`) REFERENCES `partidos` (`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `jugadores`
--
ALTER TABLE `jugadores`
  ADD CONSTRAINT `fk_jugadores_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id_equipo`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `partidos`
--
ALTER TABLE `partidos`
  ADD CONSTRAINT `fk_partidos_liga` FOREIGN KEY (`id_liga`) REFERENCES `ligas` (`id_liga`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_partidos_local` FOREIGN KEY (`id_equipo_local`) REFERENCES `equipos` (`id_equipo`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_partidos_visitante` FOREIGN KEY (`id_equipo_visitante`) REFERENCES `equipos` (`id_equipo`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `tarjetas`
--
ALTER TABLE `tarjetas`
  ADD CONSTRAINT `fk_tarjetas_jugador` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`cedula`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tarjetas_partido` FOREIGN KEY (`id_partido`) REFERENCES `partidos` (`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
