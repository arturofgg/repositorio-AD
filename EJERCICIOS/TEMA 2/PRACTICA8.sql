CREATE OR REPLACE TYPE DIRECCION AS OBJECT(
CALLE VARCHAR(25),
CIUDAD VARCHAR(20),
CODIGO_POST NUMBER(5)
);
/

CREATE TYPE tabla_anidada AS TABLE OF DIRECCION;
/

CREATE TABLE ejemplo_table_anidada(
id number(2),
apellidos varchar2(35),
direc tabla_anidada) nested table direc store as Direc_anidada;

Desc tabla_anidada;
Desc ejemplo_table_anidada;

INSERT INTO ejemplo_table_anidada VALUES(1,'RAMOS',tabla_anidada(
	DIRECCION('calle Manantiales,2','Guadalajara',19984),
	DIRECCION('calle Manants,45','Guadalajara',19234),
	DIRECCION('calle Maiales,13','Madrid',23984),
	DIRECCION('calle Tiales,3','Guadalajara',43294))
);
INSERT INTO ejemplo_table_anidada VALUES(2,'MARTIN',tabla_anidada(
	DIRECCION('calle perro','Barcerlona',12834))
);

SELECT * FROM ejemplo_table_anidada;
SELECT E.direc from ejemplo_table_anidada E where E.id=1;
SELECT dir.calle FROM ejemplo_table_anidada E , TABLE(E.direc) dir where E.id=1;
SELECT dir.calle FROM ejemplo_table_anidada E , TABLE(E.direc) dir where E.id=1 and dir.ciudad='Guadalajara';

CREATE OR REPLACE PROCEDURE VER_DIREC2(IDENT NUMBER) AS 
CURSOR C1 IS SELECT dir.calle FROM ejemplo_table_anidada E, TABLE(E.direc) dir where E.id=IDENT
BEGIN 
	FOR I IN C1 LOOP
		DBMS_OUTPUT.PUT_LINE(I.calle);
	END LOOP;
END;
/
	
BEGIN VER_DIREC2(1);
END;
/

INSERT INTO TABLE(SELECT E.direc FROM ejemplo_table_anidada E where id=1)VALUES(DIRECCION('Calle Los naranjos,99','Murcia','12324'));
SELECT direc from ejemplo_table_anidada where id=1;

