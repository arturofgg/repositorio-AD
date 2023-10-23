CREATE OR REPLACE TYPE colec_hijos as varray(10) of varchar2(30);
CREATE TABLE EMPLEADO(idpem number , nombre varchar(30), apellido varchar(30), hijos colec_hijos);

INSERT INTO EMPLEADO(1, 'Francisco', 'Perez', colec_hijos('Luis', 'Ursula'));
INSERT INTO EMPLEADO(2, 'Esperanza', 'Jimenez', colec_hijos('Jose', 'Carlos','Pedro'));

SELECT * FROM EMPLEADO;
SELECT e.hijos FROM EMPLEADO e WHERE idemp=1;
SELECT e.hijos FROM EMPLEADO e;


DECLARE 
	v_hijos colec_hijos;
	cuenta number;
BEGIN
	select hijos INTO v_hijos from empleado e where e.idemp=1;
	CUENTA:=v_hijos.count;
	dbms_output.put_line(' total de hijos es: ' || cuenta);
END;
/


DECLARE	cursor c_hijos is select * from empleados;
	v_id number;
	v_nombre varchar(30);
	v_apelldio varchar(30);
	v_hijos colec_hijos;
BEGIN
open c_hijos;
LOOP
	fetch c_hijos into v_id, v_nombre, v_apelldio, v_hijos;
	exit when c_hijos%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE('IDEMP:' ||v_id|| ' NOMBRE: '||v_nombre|| ' APELLIDO: '|| v_apelldio);
		FOR I IN v_hijos.FIRST..v_hijos.LAST LOOP
			DBMS_OUTPUT.PUT_LINE('EL hijo: ' ||i||' se llama '||v_hijos(i));
		end LOOP;
END LOOP;
END;
/


BEGIN
	FOR i IN (SELECT * FROM EMPLEADOS) LOOP	
		DBMS_OUTPUT.PUT_LINE('IDEMP: ' ||i.idemp|| ' NOMBRE: '||i.nombre ||' APELLIDO: '|| i.apellido);
		DBMS_OUTPUT.PUT_LINE('total de hijos es: '||i.hijos.count);
	END LOOP;
END;
/


DECLARE 
	v_hijos colec_hijos;
BEGIN
	SELECT hijos into v_hijos WHERE idemp=1;
	
	FOR I IN v_hijos.FIRST..v_hijos.LAST LOOP
		DBMS_OUTPUT.PUT_LINE('EL hijo: ' ||i||' se llama '||v_hijos(i));
	end LOOP;

	v_hijos.EXTEND();
	v_hijos(v_hijos.LAST) := 'Antonio';
	DBMS_OUTPUT.PUT_LINE('Hijos despues de añadir');

	FOR I IN v_hijos.FIRST..v_hijos.LAST LOOP
		DBMS_OUTPUT.PUT_LINE('EL hijo: ' ||i||' se llama '||v_hijos(i));
	end LOOP;
	
	UPDATE EMPLEADO;
END;
/


DECLARE 
	v_hijos colec_hijos;
BEGIN
	SELECT hijos into v_hijos WHERE idemp=1;
	
	FOR I IN v_hijos.FIRST..v_hijos.LAST LOOP
		DBMS_OUTPUT.PUT_LINE('EL hijo: ' ||i||' se llama '||v_hijos(i));
	end LOOP;

	v_hijos.EXTEND(3,1);
	DBMS_OUTPUT.PUT_LINE('Hijos despues de añadir');

	FOR I IN v_hijos.FIRST..v_hijos.LAST LOOP
		DBMS_OUTPUT.PUT_LINE('EL hijo: ' ||i||' se llama '||v_hijos(i));
	end LOOP;
END;
/