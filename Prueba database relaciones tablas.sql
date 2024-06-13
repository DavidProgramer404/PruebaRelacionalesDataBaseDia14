--Crear DataBase
create database prueba_db_relacionales;

--Parte 1: Creación del Modelo
--Tablas: Películas y Tags

CREATE TABLE Peliculas (
    id SERIAL not null PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    anno INT NOT NULL
);
select * from peliculas;

CREATE TABLE Tags (
    id SERIAL not null PRIMARY KEY,
    tag VARCHAR(32) not null
);
select * from Tags;

CREATE TABLE PeliculaTags (
    pelicula_id INT,
    tag_id INT,
    PRIMARY KEY (pelicula_id, tag_id),
    FOREIGN KEY (pelicula_id) REFERENCES Peliculas(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);
select * from peliculaTags;

--Tablas: Preguntas, Respuestas y Usuarios

CREATE TABLE Usuarios (
    id SERIAL NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    edad INT NOT NULL
);
select * from usuarios;

CREATE TABLE Preguntas (
    id SERIAL NOT NULL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR
);
select * from preguntas;

CREATE TABLE Respuestas (
    id SERIAL NOT NULL PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INT,
    pregunta_id INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (pregunta_id) REFERENCES Preguntas(id)
);
select * from respuestas;

--Parte 2: Insertar Registros
--Insertar 5 películas y 5 tags

INSERT INTO Peliculas (id, nombre, anno) VALUES 
(1, 'El Viaje de Chihiro', 2001),
(2, 'La La Land', 2016),
(3, 'Parasite', 2019),
(4, 'Inception', 2010),
(5, 'Coco', 2017);

SELECT* FROM PELICULAS;

INSERT INTO Tags (id, tag) VALUES 
(1, 'Animación'),
(2, 'Musical'),
(3, 'Drama'),
(4, 'Thriller'),
(5, 'Familiar');

SELECT * FROM TAGS

INSERT INTO PeliculaTags (pelicula_id, tag_id) VALUES 
(1, 1), (1, 3), (1, 5),
(2, 2), (2, 3);

SELECT * FROM PeliculaTags;

--Parte 3: Contar la cantidad de tags por película

SELECT p.nombre, COUNT(pt.tag_id) as cantidad_tags
	FROM Peliculas p
	LEFT JOIN PeliculaTags pt ON p.id = pt.pelicula_id
	GROUP BY p.id;

--Parte 4: Agregar Registros a Preguntas, Respuestas y Usuarios
--Insertar Preguntas
INSERT INTO Preguntas (id, pregunta,respuesta_correcta) values
(1,'¿Cuál es la capital de Chile?','Santiago de Chile' ),
(2, '¿Cual es el resultado de 5+5','10'),
(3, '¿Quien descubrio america?','Cristóbal Colón'),
(4,'¿Quien fue el fundador de Microsoft','Bill Gates'),
(5,'¿Quein fue el creador de PostgreSQL','Michael Stonebraker');
SELECT * FROM PREGUNTAS;

--Insertar Usuarios
INSERT INTO Usuarios (id, nombre, edad) VALUES 
(1, 'Pedro', 25),
(2, 'Juan', 30),
(3, 'Diego', 20);
SELECT * FROM USUARIOS;


--Insertar Respuestas
INSERT INTO Respuestas (id, respuesta, usuario_id, pregunta_id) VALUES 
(1, 'Santiago de Chile', 1, 1),        -- Usuario 1 responde correctamente a la pregunta 1
(2, 'Santiago de Chile', 2, 1),        -- Usuario 2 responde correctamente a la pregunta 1
(3, '10', 3, 2),                       -- Usuario 3 responde correctamente a la pregunta 2
(4, 'Shakespeare', 1, 3),              -- Usuario 1 responde incorrectamente a la pregunta 3
(5, 'Python', 2, 4);                  -- Usuario 2 responde incorrectamente a la pregunta 4
SELECT * FROM RESPUESTAS;

--Parte 5: Contar la cantidad de respuestas correctas por usuario
SELECT r.usuario_id, COUNT(*) AS respuestas_correctas
FROM Respuestas r
JOIN Preguntas p ON r.pregunta_id = p.id
WHERE r.respuesta = p.respuesta_correcta
GROUP BY r.usuario_id;

--Parte 6: Contar la cantidad de respuestas correctas por pregunta
SELECT p.id, COUNT(*) AS usuarios_correctos
FROM Preguntas p
JOIN Respuestas r ON p.id = r.pregunta_id
WHERE r.respuesta = p.respuesta_correcta
GROUP BY p.id;


--Parte 7: Implementar borrado en cascada y borrar un usuario
-- Nota: El borrado en cascada ya está implementado en la definición de la tabla

-- Borrando el primer usuario para probar el borrado en cascada
DELETE FROM Usuarios WHERE id = 1;

--Parte 8: Crear una restricción para impedir insertar usuarios menores de 18 años
ALTER TABLE Usuarios ADD CONSTRAINT chk_edad CHECK (edad >= 18);

--Parte 9: Alterar la tabla para agregar el campo de email único
ALTER TABLE Usuarios ADD COLUMN email VARCHAR(255) UNIQUE;
SELECT * FROM USUARIOS;



