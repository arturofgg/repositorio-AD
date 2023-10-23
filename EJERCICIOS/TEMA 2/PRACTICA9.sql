CREATE OR REPLACE TYPE TELEFONO AS OBJECT(tipo varchar2(30), numero number);
/

CREATE OR REPLACE TYPE listin AS TABLE OF TELEFONO;
/

CREATE TABLE clientes(
id_cliente number,
nombre varchar2(30),
apellido varchar2(30),
direccion varchar2(30),
poblacion varchar2(30),
provincia varchar2(30),
telefonos listin) nested table telefonos store as tel_tab;

INSERT INTO clientes VALUES(1,'Paco','Perez','sol','madrid','madrid',listin(TELEFONO('MOVIL',633883394),TELEFONO('FIJO',938392034),TELEFONO('MOVIL',647409234)));
INSERT INTO clientes VALUES(2,'Ramirez','Kevin','sol','madrid','madrid', listin(TELEFONO('MOVIL',633865394),TELEFONO('FIJO',932342034),TELEFONO('MOVIL',647429394)));
INSERT INTO clientes VALUES(3,'Jesus','Garcia','sol','madrid','madrid', listin(TELEFONO('MOVIL',633834394),TELEFONO('FIJO',938309434),TELEFONO('MOVIL',640939494)));

SELECT * FROM clientes;
SELECT SEGMENT_NAME,SEGMENT_TYPE FROM DBA_SEGMENTS WHERE SEGMENT_NAME LIKE '%TELEFONO%';
select * from dba_objects where object_name like '%TELEFONO%';
select * from user_nested_tables;

select cli.* from clientes c, TABLE(c.telefonos) cli where c.id_cliente=3;
update clientes set telefonos = listin(TELEFONO('FIJO',934444444),TELEFONO('MOVIL PERSONAL',655555555),TELEFONO('MOVIL EMPRESA',644444444)) where id_cliente=1; 

SELECT cli.*from clientes c, TABLE(c.telefonos) cli;
SELECT c.id_cliente, c.nombre, cli.* from clientes c, TABLE(c.telefonos) cli;

DECLARE
	id_cliente number;
    nombre varchar2(30);
    --numero number;
	--tipo varchar2(30);
	tlf listin;
	CURSOR C_GENERAL IS SELECT id_cliente, nombre,tlf FROM clientes c;
BEGIN
	OPEN C_GENERAL;
    LOOP
        FETCH C_GENERAL INTO id_cliente,nombre,tlf;
        EXIT WHEN C_GENERAL%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID:' || id_cliente || 'NOMBRE: ' || nombre);
        FOR i IN 1..tlf.COUNT LOOP 

            DBMS_OUTPUT.PUT_LINE('telefono:' || tlf(i) || 'tipo' || tlf(i));
        END LOOP;
	end loop;
	close C_GENERAL;
end;
/