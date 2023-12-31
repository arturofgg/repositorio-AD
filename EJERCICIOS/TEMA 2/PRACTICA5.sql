ALTER TYPE TIPO_EMPLEADO REPLACE AS OBJECT(
RUT VARCHAR(10),
NOMBRE VARCHAR(10),
CARGO VARCHAR(9),
FECHAING DATE,
SUELDO NUMBER(9),
COMISION NUMBER(9),
ANTICIPO NUMBER(9),
MEMBER FUNCTION SUELDO_LIQUIDO RETURN NUMBER,
MEMBER PROCEDURE AUMENTO_SUELDO(AUMENTO NUMBER),
MEMBER PROCEDURE SETANTICIPO (ANTICIPO NUMBER)
);
/

CREATE OR REPLACE TYPE body TIPO_EMPLEADO AS
MEMBER FUNCTION SUELDO_LIQUIDO return NUMBER IS 
	BEGIN
		return (SUELDO+COMISION)-ANTICIPO;
	END;
	
MEMBER PROCEDURE AUMENTO_SUELDO(AUMENTO NUMBER) IS
		NUEVO_SUELDO NUMBER;
	BEGIN
		NUEVO_SUELDO:=SUELDO+AUMENTO;
		DBMS_OUTPUT.PUT_LINE(NUEVO_SUELDO);
	END;
	
	MEMBER PROCEDURE SETANTICIPO(ANTICIPO NUMBER) IS
	BEGIN
		SELF.ANTICIPO:=ANTICIPO;
	END;
END;
/

CREATE TABLE EMPLEADO OF TIPO_EMPLEADO;
INSERT INTO EMPLEADO VALUES ('1','PEPE','DIRECTOR',SYSDATE,2000,500,0);
INSERT INTO EMPLEADO VALUES ('2','JUAN','VENDEDOR',SYSDATE,1000,300,0);

SELECT * FROM EMPLEADO;

SELECT E.SUELDO_LIQUIDO() FROM EMPLEADO E WHERE SUELDO=2000;

DECLARE 
	MI_EMP TIPO_EMPLEADO;
BEGIN
	SELECT VALUE(E) INTO MI_EMP FROM EMPLEADO E WHERE E.RUT='2';
	MI_EMP.AUMENTO_SUELDO(100);
	UPDATE EMPLEADO E SET E.SUELDO=MI_EMP.SUELDO WHERE E.RUT=2;
END;
/

DECLARE 
	MI_EMP TIPO_EMPLEADO;
BEGIN
	SELECT VALUE(E) INTO MI_EMP FROM EMPLEADO E WHERE E.RUT='1';
	MI_EMP.SETANTICIPO(300);
	UPDATE EMPLEADO SET ANTICIPO=SELF.ANTICIPO WHERE RUT='1';
END;
/


 
	