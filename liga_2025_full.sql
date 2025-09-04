
-- LIGA_2025 - Esquema completo + datos de ejemplo + 25 vistas + 30 procedimientos
-- Generado: 2025-09-03
-- Charset y zona
SET NAMES utf8mb4;
SET time_zone = '+00:00';

DROP DATABASE IF EXISTS liga_2025;
CREATE DATABASE liga_2025 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE liga_2025;

-- =====================
-- TABLAS
-- =====================

CREATE TABLE ligas (
  id_liga INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100),
  pais VARCHAR(50),
  temporada VARCHAR(20),
  fecha_inicio DATE,
  fecha_fin DATE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_liga)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE equipos (
  id_equipo INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100),
  ciudad VARCHAR(50),
  estadio VARCHAR(100),
  fundacion YEAR,
  presidente VARCHAR(100),
  entrenador VARCHAR(100),
  id_liga INT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_equipo),
  KEY idx_equipos_liga (id_liga)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE jugadores (
  cedula VARCHAR(20) NOT NULL,
  nombre VARCHAR(100),
  apellido VARCHAR(100),
  fecha_nacimiento DATE,
  nacionalidad VARCHAR(50),
  posicion ENUM('Portero','Defensa','Centrocampista','Delantero'),
  numero_camiseta INT,
  id_equipo INT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (cedula),
  KEY idx_jugadores_equipo (id_equipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE partidos (
  id_partido INT NOT NULL AUTO_INCREMENT,
  fecha_hora DATETIME,
  estadio VARCHAR(100),
  id_equipo_local INT,
  id_equipo_visitante INT,
  goles_local INT DEFAULT 0,
  goles_visitante INT DEFAULT 0,
  jornada INT,
  id_liga INT,
  estado ENUM('Programado','En juego','Finalizado','Suspendido') DEFAULT 'Programado',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_partido),
  KEY idx_partidos_liga (id_liga),
  KEY idx_partidos_local (id_equipo_local),
  KEY idx_partidos_visitante (id_equipo_visitante)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE goles (
  id_gol INT NOT NULL AUTO_INCREMENT,
  id_partido INT,
  id_jugador VARCHAR(20),
  minuto INT,
  tipo ENUM('Normal','Penalti','Falta directa','Autogol'),
  descripcion TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_gol),
  KEY idx_goles_partido (id_partido),
  KEY idx_goles_jugador (id_jugador)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tarjetas (
  id_tarjeta INT NOT NULL AUTO_INCREMENT,
  id_partido INT,
  id_jugador VARCHAR(20),
  minuto INT,
  tipo ENUM('Amarilla','Roja'),
  motivo TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_tarjeta),
  KEY idx_tarjetas_partido (id_partido),
  KEY idx_tarjetas_jugador (id_jugador)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE clasificacion (
  id_clasificacion INT NOT NULL AUTO_INCREMENT,
  id_liga INT,
  id_equipo INT,
  partidos_jugados INT DEFAULT 0,
  partidos_ganados INT DEFAULT 0,
  partidos_empatados INT DEFAULT 0,
  partidos_perdidos INT DEFAULT 0,
  goles_a_favor INT DEFAULT 0,
  goles_en_contra INT DEFAULT 0,
  diferencia_goles INT AS (goles_a_favor - goles_en_contra) PERSISTENT,
  puntos INT DEFAULT 0,
  temporada VARCHAR(20),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_clasificacion),
  KEY idx_clasificacion_liga (id_liga),
  KEY idx_clasificacion_equipo (id_equipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE arbitros (
  id_arbitro INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100),
  apellido VARCHAR(100),
  nacionalidad VARCHAR(50),
  fecha_nacimiento DATE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_arbitro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE arbitros_partido (
  id_arbitro_partido INT NOT NULL AUTO_INCREMENT,
  id_arbitro INT,
  id_partido INT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_arbitro_partido),
  KEY idx_ap_arbitro (id_arbitro),
  KEY idx_ap_partido (id_partido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================
-- FOREIGN KEYS (con CASCADE)
-- =====================

ALTER TABLE equipos
  ADD CONSTRAINT fk_equipos_liga FOREIGN KEY (id_liga) REFERENCES ligas(id_liga) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE jugadores
  ADD CONSTRAINT fk_jugadores_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE partidos
  ADD CONSTRAINT fk_partidos_liga FOREIGN KEY (id_liga) REFERENCES ligas(id_liga) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT fk_partidos_local FOREIGN KEY (id_equipo_local) REFERENCES equipos(id_equipo) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT fk_partidos_visitante FOREIGN KEY (id_equipo_visitante) REFERENCES equipos(id_equipo) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE goles
  ADD CONSTRAINT fk_goles_partido FOREIGN KEY (id_partido) REFERENCES partidos(id_partido) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_goles_jugador FOREIGN KEY (id_jugador) REFERENCES jugadores(cedula) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tarjetas
  ADD CONSTRAINT fk_tarjetas_partido FOREIGN KEY (id_partido) REFERENCES partidos(id_partido) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_tarjetas_jugador FOREIGN KEY (id_jugador) REFERENCES jugadores(cedula) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE clasificacion
  ADD CONSTRAINT fk_clasificacion_liga FOREIGN KEY (id_liga) REFERENCES ligas(id_liga) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_clasificacion_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE arbitros_partido
  ADD CONSTRAINT fk_ap_arbitro FOREIGN KEY (id_arbitro) REFERENCES arbitros(id_arbitro) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_ap_partido FOREIGN KEY (id_partido) REFERENCES partidos(id_partido) ON DELETE CASCADE ON UPDATE CASCADE;

-- =====================
-- DATOS DE EJEMPLO (mínimos para que no esté vacía)
-- =====================

INSERT INTO ligas (nombre, pais, temporada, fecha_inicio, fecha_fin)
VALUES ('Liga Profesional Colombiana', 'Colombia', '2025', '2025-01-20', '2025-12-10');

INSERT INTO equipos (nombre, ciudad, estadio, fundacion, presidente, entrenador, id_liga)
VALUES 
('Atlético Nacional', 'Medellín', 'Atanasio Girardot', 1947, 'Presidente A', 'Entrenador A', 1),
('Millonarios FC', 'Bogotá', 'El Campín', 1946, 'Presidente B', 'Entrenador B', 1),
('Deportivo Cali', 'Cali', 'Palmaseca', 1912, 'Presidente C', 'Entrenador C', 1),
('Junior FC', 'Barranquilla', 'Metropolitano', 1924, 'Presidente D', 'Entrenador D', 1);

INSERT INTO jugadores (cedula, nombre, apellido, fecha_nacimiento, nacionalidad, posicion, numero_camiseta, id_equipo)
VALUES
('1001001', 'David', 'Ospina', '1988-08-31', 'Colombia', 'Portero', 1, 1),
('1001002', 'Yerson', 'Mosquera', '1994-02-04', 'Colombia', 'Defensa', 3, 1),
('2002001', 'Juan', 'Pérez', '1995-05-20', 'Colombia', 'Centrocampista', 8, 2),
('2002002', 'Carlos', 'López', '1997-10-15', 'Colombia', 'Delantero', 9, 2),
('3003001', 'Jorge', 'Ramírez', '1994-06-01', 'Colombia', 'Defensa', 5, 3),
('4004001', 'Miguel', 'Ángel', '1996-03-10', 'Argentina', 'Delantero', 11, 4);

INSERT INTO partidos (fecha_hora, estadio, id_equipo_local, id_equipo_visitante, goles_local, goles_visitante, jornada, id_liga, estado)
VALUES
('2025-02-01 18:00:00', 'Atanasio Girardot', 1, 2, 2, 1, 1, 1, 'Finalizado'),
('2025-02-08 20:00:00', 'El Campín', 2, 3, 0, 0, 2, 1, 'Finalizado'),
('2025-02-15 17:00:00', 'Palmaseca', 3, 4, 1, 3, 3, 1, 'Finalizado');

INSERT INTO goles (id_partido, id_jugador, minuto, tipo, descripcion)
VALUES
(1, '1001002', 30, 'Normal', 'Gol de cabeza en tiro de esquina'),
(1, '2002002', 55, 'Penalti', 'Gol de penalti bien ejecutado'),
(3, '4004001', 12, 'Normal', 'Remate dentro del área');

INSERT INTO tarjetas (id_partido, id_jugador, minuto, tipo, motivo)
VALUES
(1, '1001001', 70, 'Amarilla', 'Reclamos al árbitro'),
(2, '3003001', 40, 'Roja', 'Falta fuerte sobre delantero');

INSERT INTO arbitros (nombre, apellido, nacionalidad, fecha_nacimiento)
VALUES ('Wilmar', 'Roldán', 'Colombia', '1980-01-25'), ('Andrés', 'Cuesta', 'Colombia', '1985-03-12');

INSERT INTO arbitros_partido (id_arbitro, id_partido)
VALUES (1,1), (2,2);

INSERT INTO clasificacion (id_liga, id_equipo, partidos_jugados, partidos_ganados, partidos_empatados, partidos_perdidos, goles_a_favor, goles_en_contra, puntos, temporada)
VALUES
(1,1,1,1,0,0,2,1,3,'2025'),
(1,2,2,0,2,0,1,1,2,'2025'),
(1,3,3,1,0,2,2,5,3,'2025'),
(1,4,3,2,0,1,6,4,6,'2025');

-- =====================
-- VISTAS (25)
-- =====================

DROP VIEW IF EXISTS arbitros_con_total_de_partidos;
CREATE VIEW arbitros_con_total_de_partidos AS
SELECT CONCAT(a.nombre,' ',a.apellido) AS arbitro, COUNT(ap.id_partido) AS total_partidos
FROM arbitros a
LEFT JOIN arbitros_partido ap ON a.id_arbitro = ap.id_arbitro
GROUP BY a.id_arbitro, a.nombre, a.apellido;

DROP VIEW IF EXISTS arbitros_en_partidos;
CREATE VIEW arbitros_en_partidos AS
SELECT ap.id_arbitro_partido, CONCAT(a.nombre,' ',a.apellido) AS arbitro, p.id_partido, p.fecha_hora
FROM arbitros_partido ap
JOIN arbitros a ON ap.id_arbitro = a.id_arbitro
JOIN partidos p ON ap.id_partido = p.id_partido;

DROP VIEW IF EXISTS clasificacion_completa;
CREATE VIEW clasificacion_completa AS
SELECT c.id_clasificacion, l.nombre AS liga, e.nombre AS equipo, c.partidos_jugados, c.puntos, c.diferencia_goles
FROM clasificacion c
JOIN ligas l ON c.id_liga = l.id_liga
JOIN equipos e ON c.id_equipo = e.id_equipo
ORDER BY c.puntos DESC, c.diferencia_goles DESC;

DROP VIEW IF EXISTS equipos_con_derrotas;
CREATE VIEW equipos_con_derrotas AS
SELECT e.nombre AS equipo, c.partidos_perdidos AS derrotas
FROM equipos e JOIN clasificacion c ON e.id_equipo = c.id_equipo;

DROP VIEW IF EXISTS equipos_con_empates;
CREATE VIEW equipos_con_empates AS
SELECT e.nombre AS equipo, c.partidos_empatados AS empates
FROM equipos e JOIN clasificacion c ON e.id_equipo = c.id_equipo;

DROP VIEW IF EXISTS equipos_con_liga;
CREATE VIEW equipos_con_liga AS
SELECT e.id_equipo, e.nombre AS equipo, e.ciudad, l.nombre AS liga
FROM equipos e JOIN ligas l ON e.id_liga = l.id_liga;

DROP VIEW IF EXISTS equipos_con_partidos_jugados;
CREATE VIEW equipos_con_partidos_jugados AS
SELECT e.nombre AS equipo, c.partidos_jugados
FROM equipos e JOIN clasificacion c ON e.id_equipo = c.id_equipo;

DROP VIEW IF EXISTS equipos_con_puntos;
CREATE VIEW equipos_con_puntos AS
SELECT e.nombre AS equipo, c.puntos
FROM equipos e JOIN clasificacion c ON e.id_equipo = c.id_equipo;

DROP VIEW IF EXISTS equipos_con_victorias;
CREATE VIEW equipos_con_victorias AS
SELECT e.nombre AS equipo, c.partidos_ganados AS victorias
FROM equipos e JOIN clasificacion c ON e.id_equipo = c.id_equipo;

DROP VIEW IF EXISTS equipos_partidos_sin_recibir_gol;
CREATE VIEW equipos_partidos_sin_recibir_gol AS
SELECT e.nombre AS equipo,
       COALESCE(SUM(CASE WHEN p.id_equipo_local = e.id_equipo AND p.goles_visitante = 0 THEN 1 ELSE 0 END),0)
     + COALESCE(SUM(CASE WHEN p.id_equipo_visitante = e.id_equipo AND p.goles_local = 0 THEN 1 ELSE 0 END),0)
     AS partidos_sin_gol
FROM equipos e
LEFT JOIN partidos p ON (p.id_equipo_local = e.id_equipo OR p.id_equipo_visitante = e.id_equipo)
GROUP BY e.id_equipo, e.nombre
ORDER BY partidos_sin_gol DESC;

DROP VIEW IF EXISTS jugadores_con_equipo_y_liga;
CREATE VIEW jugadores_con_equipo_y_liga AS
SELECT j.cedula, CONCAT(j.nombre,' ',j.apellido) AS jugador, j.posicion, e.nombre AS equipo, l.nombre AS liga
FROM jugadores j
JOIN equipos e ON j.id_equipo = e.id_equipo
JOIN ligas l ON e.id_liga = l.id_liga;

DROP VIEW IF EXISTS jugadores_con_goles_de_penalti;
CREATE VIEW jugadores_con_goles_de_penalti AS
SELECT CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(g.id_gol) AS goles_penalti
FROM jugadores j
LEFT JOIN goles g ON j.cedula = g.id_jugador AND g.tipo = 'Penalti'
GROUP BY j.cedula, j.nombre, j.apellido;

DROP VIEW IF EXISTS jugadores_con_mas_de_5_goles;
CREATE VIEW jugadores_con_mas_de_5_goles AS
SELECT CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(g.id_gol) AS goles
FROM jugadores j
LEFT JOIN goles g ON j.cedula = g.id_jugador
GROUP BY j.cedula, j.nombre, j.apellido
HAVING goles > 5;

DROP VIEW IF EXISTS jugadores_con_posicion_y_equipo;
CREATE VIEW jugadores_con_posicion_y_equipo AS
SELECT CONCAT(j.nombre,' ',j.apellido) AS jugador, j.posicion, e.nombre AS equipo
FROM jugadores j JOIN equipos e ON j.id_equipo = e.id_equipo;

DROP VIEW IF EXISTS jugadores_con_tarjeta_roja;
CREATE VIEW jugadores_con_tarjeta_roja AS
SELECT CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(t.id_tarjeta) AS rojas
FROM jugadores j LEFT JOIN tarjetas t ON j.cedula = t.id_jugador AND t.tipo = 'Roja'
GROUP BY j.cedula, j.nombre, j.apellido HAVING rojas > 0;

DROP VIEW IF EXISTS jugadores_con_total_de_goles;
CREATE VIEW jugadores_con_total_de_goles AS
SELECT CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(g.id_gol) AS total_goles
FROM jugadores j LEFT JOIN goles g ON j.cedula = g.id_jugador
GROUP BY j.cedula, j.nombre, j.apellido;

DROP VIEW IF EXISTS jugadores_con_total_de_tarjetas;
CREATE VIEW jugadores_con_total_de_tarjetas AS
SELECT CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(t.id_tarjeta) AS total_tarjetas
FROM jugadores j LEFT JOIN tarjetas t ON j.cedula = t.id_jugador
GROUP BY j.cedula, j.nombre, j.apellido;

DROP VIEW IF EXISTS jugadores_extranjeros;
CREATE VIEW jugadores_extranjeros AS
SELECT CONCAT(j.nombre,' ',j.apellido) AS jugador, j.nacionalidad, e.nombre AS equipo
FROM jugadores j JOIN equipos e ON j.id_equipo = e.id_equipo
WHERE j.nacionalidad <> 'Colombia';

DROP VIEW IF EXISTS jugador_maximo_goleador;
CREATE VIEW jugador_maximo_goleador AS
SELECT CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(g.id_gol) AS total_goles
FROM jugadores j LEFT JOIN goles g ON j.cedula = g.id_jugador
GROUP BY j.cedula, j.nombre, j.apellido
ORDER BY total_goles DESC LIMIT 1;

DROP VIEW IF EXISTS partidos_con_empate;
CREATE VIEW partidos_con_empate AS
SELECT p.* FROM partidos p WHERE p.goles_local = p.goles_visitante;

DROP VIEW IF EXISTS partidos_con_mas_de_4_goles;
CREATE VIEW partidos_con_mas_de_4_goles AS
SELECT p.* FROM partidos p WHERE (p.goles_local + p.goles_visitante) > 4;

DROP VIEW IF EXISTS partidos_detalle;
CREATE VIEW partidos_detalle AS
SELECT p.id_partido, p.fecha_hora, el.nombre AS equipo_local, ev.nombre AS equipo_visitante,
       p.goles_local, p.goles_visitante, p.estado
FROM partidos p
JOIN equipos el ON p.id_equipo_local = el.id_equipo
JOIN equipos ev ON p.id_equipo_visitante = ev.id_equipo;

DROP VIEW IF EXISTS partidos_finalizados;
CREATE VIEW partidos_finalizados AS SELECT * FROM partidos WHERE estado = 'Finalizado';

DROP VIEW IF EXISTS partidos_programados;
CREATE VIEW partidos_programados AS SELECT * FROM partidos WHERE estado = 'Programado';

DROP VIEW IF EXISTS partidos_suspendidos;
CREATE VIEW partidos_suspendidos AS SELECT * FROM partidos WHERE estado = 'Suspendido';

-- =====================
-- PROCEDIMIENTOS (30)
-- =====================
DELIMITER $$

-- CONSULTAS / REPORTES (1-15)

CREATE PROCEDURE sp_obtenerEquipos()
BEGIN
  SELECT * FROM equipos;
END$$

CREATE PROCEDURE sp_obtenerJugadoresPorEquipo(IN p_equipoId INT)
BEGIN
  SELECT * FROM jugadores WHERE id_equipo = p_equipoId;
END$$

CREATE PROCEDURE sp_obtenerPartidosPorLiga(IN p_ligaId INT)
BEGIN
  SELECT * FROM partidos WHERE id_liga = p_ligaId;
END$$

CREATE PROCEDURE sp_maximoGoleador()
BEGIN
  SELECT j.cedula, CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(g.id_gol) AS goles
  FROM jugadores j LEFT JOIN goles g ON j.cedula = g.id_jugador
  GROUP BY j.cedula, j.nombre, j.apellido
  ORDER BY goles DESC LIMIT 1;
END$$

CREATE PROCEDURE sp_jugadoresConRojas()
BEGIN
  SELECT j.cedula, CONCAT(j.nombre,' ',j.apellido) AS jugador, COUNT(t.id_tarjeta) AS rojas
  FROM jugadores j JOIN tarjetas t ON j.cedula = t.id_jugador
  WHERE t.tipo='Roja'
  GROUP BY j.cedula, j.nombre, j.apellido;
END$$

CREATE PROCEDURE sp_obtenerClasificacionEquipo(IN p_equipoId INT)
BEGIN
  SELECT * FROM clasificacion WHERE id_equipo = p_equipoId;
END$$

CREATE PROCEDURE sp_obtenerArbitrosPorPartido(IN p_partidoId INT)
BEGIN
  SELECT a.nombre, a.apellido
  FROM arbitros a JOIN arbitros_partido ap ON a.id_arbitro = ap.id_arbitro
  WHERE ap.id_partido = p_partidoId;
END$$

CREATE PROCEDURE sp_resultadosEquipo(IN p_equipoId INT)
BEGIN
  SELECT p.id_partido, p.goles_local, p.goles_visitante, p.estado
  FROM partidos p
  WHERE p.id_equipo_local = p_equipoId OR p.id_equipo_visitante = p_equipoId;
END$$

CREATE PROCEDURE sp_partidosFinalizados()
BEGIN
  SELECT * FROM partidos WHERE estado = 'Finalizado';
END$$

CREATE PROCEDURE sp_partidosProgramados()
BEGIN
  SELECT * FROM partidos WHERE estado = 'Programado';
END$$

CREATE PROCEDURE sp_totalGolesJugador(IN p_jugadorCedula VARCHAR(20))
BEGIN
  SELECT COUNT(*) AS goles FROM goles WHERE id_jugador = p_jugadorCedula;
END$$

CREATE PROCEDURE sp_totalTarjetasJugador(IN p_jugadorCedula VARCHAR(20))
BEGIN
  SELECT COUNT(*) AS tarjetas FROM tarjetas WHERE id_jugador = p_jugadorCedula;
END$$

CREATE PROCEDURE sp_jugadoresExtranjeros()
BEGIN
  SELECT * FROM jugadores WHERE nacionalidad <> 'Colombia';
END$$

CREATE PROCEDURE sp_goleadoresPartido(IN p_partidoId INT)
BEGIN
  SELECT j.nombre, j.apellido, g.minuto, g.tipo
  FROM goles g JOIN jugadores j ON g.id_jugador = j.cedula
  WHERE g.id_partido = p_partidoId;
END$$

CREATE PROCEDURE sp_equiposConMasPuntos(IN p_puntosMin INT)
BEGIN
  SELECT e.nombre, c.puntos
  FROM equipos e JOIN clasificacion c ON e.id_equipo = c.id_equipo
  WHERE c.puntos >= p_puntosMin;
END$$

-- ACCIONES / MUTACIONES (16-30)

CREATE PROCEDURE sp_insertarEquipo(IN p_nombre VARCHAR(100), IN p_ciudad VARCHAR(50), IN p_estadio VARCHAR(100), IN p_fundacion YEAR, IN p_presidente VARCHAR(100), IN p_entrenador VARCHAR(100), IN p_ligaId INT)
BEGIN
  INSERT INTO equipos (nombre, ciudad, estadio, fundacion, presidente, entrenador, id_liga)
  VALUES (p_nombre, p_ciudad, p_estadio, p_fundacion, p_presidente, p_entrenador, p_ligaId);
END$$

CREATE PROCEDURE sp_insertarJugador(IN p_cedula VARCHAR(20), IN p_nombre VARCHAR(100), IN p_apellido VARCHAR(100), IN p_fecha_nac DATE, IN p_nacionalidad VARCHAR(50), IN p_posicion VARCHAR(20), IN p_numero INT, IN p_equipoId INT)
BEGIN
  INSERT INTO jugadores (cedula, nombre, apellido, fecha_nacimiento, nacionalidad, posicion, numero_camiseta, id_equipo)
  VALUES (p_cedula, p_nombre, p_apellido, p_fecha_nac, p_nacionalidad, p_posicion, p_numero, p_equipoId);
END$$

CREATE PROCEDURE sp_insertarPartido(IN p_fecha DATETIME, IN p_estadio VARCHAR(100), IN p_localId INT, IN p_visitaId INT, IN p_golesL INT, IN p_golesV INT, IN p_jornada INT, IN p_ligaId INT, IN p_estado VARCHAR(20))
BEGIN
  INSERT INTO partidos (fecha_hora, estadio, id_equipo_local, id_equipo_visitante, goles_local, goles_visitante, jornada, id_liga, estado)
  VALUES (p_fecha, p_estadio, p_localId, p_visitaId, p_golesL, p_golesV, p_jornada, p_ligaId, p_estado);
END$$

CREATE PROCEDURE sp_insertarGol(IN p_partidoId INT, IN p_jugadorCedula VARCHAR(20), IN p_minuto INT, IN p_tipo VARCHAR(20), IN p_desc TEXT)
BEGIN
  INSERT INTO goles (id_partido, id_jugador, minuto, tipo, descripcion)
  VALUES (p_partidoId, p_jugadorCedula, p_minuto, p_tipo, p_desc);
END$$

CREATE PROCEDURE sp_insertarTarjeta(IN p_partidoId INT, IN p_jugadorCedula VARCHAR(20), IN p_minuto INT, IN p_tipo VARCHAR(20), IN p_motivo TEXT)
BEGIN
  INSERT INTO tarjetas (id_partido, id_jugador, minuto, tipo, motivo)
  VALUES (p_partidoId, p_jugadorCedula, p_minuto, p_tipo, p_motivo);
END$$

CREATE PROCEDURE sp_actualizarPuntosEquipo(IN p_equipoId INT, IN p_puntos INT)
BEGIN
  UPDATE clasificacion SET puntos = p_puntos WHERE id_equipo = p_equipoId;
END$$

CREATE PROCEDURE sp_actualizarEntrenador(IN p_equipoId INT, IN p_nuevoEntrenador VARCHAR(100))
BEGIN
  UPDATE equipos SET entrenador = p_nuevoEntrenador WHERE id_equipo = p_equipoId;
END$$

CREATE PROCEDURE sp_actualizarEstadoPartido(IN p_partidoId INT, IN p_nuevoEstado VARCHAR(20))
BEGIN
  UPDATE partidos SET estado = p_nuevoEstado WHERE id_partido = p_partidoId;
END$$

CREATE PROCEDURE sp_eliminarJugador(IN p_jugadorCedula VARCHAR(20))
BEGIN
  DELETE FROM jugadores WHERE cedula = p_jugadorCedula;
END$$

CREATE PROCEDURE sp_eliminarEquipo(IN p_equipoId INT)
BEGIN
  DELETE FROM equipos WHERE id_equipo = p_equipoId;
END$$

CREATE PROCEDURE sp_eliminarPartido(IN p_partidoId INT)
BEGIN
  DELETE FROM partidos WHERE id_partido = p_partidoId;
END$$

CREATE PROCEDURE sp_eliminarGol(IN p_golId INT)
BEGIN
  DELETE FROM goles WHERE id_gol = p_golId;
END$$

CREATE PROCEDURE sp_eliminarTarjeta(IN p_tarjetaId INT)
BEGIN
  DELETE FROM tarjetas WHERE id_tarjeta = p_tarjetaId;
END$$

CREATE PROCEDURE sp_insertarArbitro(IN p_nombre VARCHAR(100), IN p_apellido VARCHAR(100), IN p_nacionalidad VARCHAR(50), IN p_fecha_nac DATE)
BEGIN
  INSERT INTO arbitros (nombre, apellido, nacionalidad, fecha_nacimiento)
  VALUES (p_nombre, p_apellido, p_nacionalidad, p_fecha_nac);
END$$

DELIMITER ;


-- Fin del script
