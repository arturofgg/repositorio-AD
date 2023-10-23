CREATE OR REPLACE TYPE HIJOS AS OBJECT(
NOMBRE VARCHAR(30)
);
/
CREATE TYPE tabla_HIJOS AS TABLE OF HIJOS;
/
*esto es distinto, aunque funciona^^^^*

*asi >>>*
create type tabla_HIJOS as table of varchar(30);/

CREATE TABLE TABLA_EMPLEADO(
IDEMP number(2),
NOMBRE varchar2(35),
APELLIDOS VARCHAR(30),
HIJXS tabla_HIJOS) nested table HIJXS store as T_HIJOS;

INSERT INTO TABLA_EMPLEADO VALUES(
1,
'FERNANDO',
'MORENO',
tabla_HIJOS(HIJOS('ELENA'),HIJOS('PABLO')) **HIJOS ES SOLO SI SE HACE CON EL OBJETO, SI PONEMOS SOLO EL NOMBRE DE LA TABLA NO HACE FALTA
);
INSERT INTO TABLA_EMPLEADO VALUES(
2,
'DAVID',
'SANCHEZ',
tabla_HIJOS(HIJOS('CARMEN'),HIJOS('CANDELA')) **HIJOS ES SOLO SI SE HACE CON EL OBJETO, SI PONEMOS SOLO EL NOMBRE DE LA TABLA NO HACE FALTA
);

select object_name,object_type,status from dba_objects where object_name like '%HIJO%';
SELECT SEGMENT_NAME,SEGMENT_TYPE FROM DBA_SEGMENTS WHERE SEGMENT_NAME LIKE '%HIJO%';
select idemp,nombre,apellidos from tabla_empleado;
select hij.nombre from tabla_empleado e, TABLE(e.hijxs) hij where e.idemp=1;
insert into TABLE(select e.hijxs from tabla_empleado e where idemp=1) values(hijos('Cayetana'));**ESTO NO HACE FALTA PARA EL EJERCICIO ES SOLO UN INSERT
update tabla_empleado set hijxs = tabla_hijos(hijos('Carmen'),hijos('Candela'),hijos('Cayetana')) where idemp=1; 
**HIJOS ES SOLO SI SE HACE CON EL OBJETO, SI PONEMOS SOLO EL NOMBRE DE LA TABLA NO HACE FALTA