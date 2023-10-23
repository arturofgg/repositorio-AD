CREATE OR REPLACE TYPE VETERINARIO AS OBJECT (
ID VARCHAR2(25),
NOMBRE VARCHAR2(20),
DIRECCION NUMBER(5)
);
/

CREATE OR REPLACE TYPE MASCOTA AS OBJECT (
ID VARCHAR2(25),
RAZA VARCHAR2(20),
NOMBRE NUMBER(5),
VET REF VETERINARIO
);
/

CREATE TABLE VETERINARIOS OF VETERINARIO;

CREATE TABLE MASCOTAS OF MASCOTA;

INSERT INTO VETERINARIOS(1,'jesus perex', 'C/El Paquete 3');

INSERT INTO MASCOTAS VALUES(1,'perro','sprocket',
(select REF(v) from veterinarios v where v.id=1));

SELECT * FROM MASCOTAS;

SELECT NOMBRE, DEREF(VET) FROM MASCOTAS;

SELECT NOMBRE, RAZA, DEREF(M.VET).NOMBRE FROM MASCOTAS M;

SELECT NOMBRE, M.VET.DIRECCION FROM MASCOTAS M;

DROP TABLE MASCOTAS;
DROP TABLE VETERINARIOS;
DROP TYPE MASCOTA;
DROP TYPE VETERINARIO;