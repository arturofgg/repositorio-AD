ALTER TYPE CUBO REPLACE AS OBJECT (
LARGO INTEGER,
ANCHO INTEGER,
ALTO INTEGER,
MEMBER FUNCTION superficie RETURN integer,
MEMBER FUNCTION  volumen RETURN integer,
MEMBER PROCEDURE  mostrar,
STATIC PROCEDURE nuevoCubo(largo INTEGER, ancho INTEGER, alto INTEGER)
);
/

CREATE OR REPLACE TYPE body CUBO AS
	MEMBER FUNCTION superficie return INTEGER IS 
	BEGIN
		return 2*(largo*ancho+largo*alto+ancho*alto);
	END;
	
	MEMBER FUNCTION volumen return INTEGER IS 
	BEGIN
		return largo*alto*ancho;
	END;
	
	MEMBER PROCEDURE mostrar is
	BEGIN
		DBMS_OUTPUT.PUT_LINE('El largo es ' || LARGO || 
		', el ancho es ' || ANCHO || ', el alto es ' || ALTO ||
		', la superficie es ' || superficie || 
		' y el volumen es ' || volumen ||'.');
	END;
	
	STATIC PROCEDURE nuevoCubo(largo INTEGER, ancho INTEGER, alto INTEGER) is
	BEGIN
		INSERT INTO CUBOS VALUES (largo,ancho,alto);
	END;
END;
/

CREATE TABLE CUBOS OF CUBO;
INSERT INTO CUBOS VALUES (10,10,10);
INSERT INTO CUBOS VALUES (3,4,5);

SELECT * FROM CUBOS;

SELECT c.volumen(), c.superficie() from cubos c where c.largo=10;

DECLARE 
	MI_CUBO CUBO;
BEGIN
	SELECT VALUE(C) INTO MI_CUBO FROM CUBOS C WHERE C.LARGO=10;
	MI_CUBO.MOSTRAR(); 
END;
/

DECLARE 
	MI_CUBO CUBO;
BEGIN
	SELECT VALUE(C) INTO MI_CUBO FROM CUBOS C WHERE C.LARGO=10;
	MI_CUBO.MOSTRAR(); 
END;
/

BEGIN
	CUBO.nuevoCubo(); 
END;
/