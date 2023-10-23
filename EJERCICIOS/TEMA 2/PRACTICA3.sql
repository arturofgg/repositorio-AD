CREATE OR REPLACE TYPE tipo_triangulo AS OBJECT (
BASE NUMBER,
ALTURA NUMBER,
MEMBER FUNCTION area RETURN NUMBER
);
/

CREATE OR REPLACE TYPE body tipo_triangulo AS
	MEMBER FUNCTION area return NUMBER IS 
	BEGIN
		return (base*altura)/2;
	END;
END;
/

CREATE TABLE tipo_triangulos (id number, triangulo tipo_triangulo);
INSERT INTO tipo_triangulos VALUES (1, tipo_triangulo(5,5));
INSERT INTO tipo_triangulos VALUES (2, tipo_triangulo(10,10));

SELECT * FROM tipo_triangulos;

DECLARE
	CURSOR triangulos IS SELECT * FROM tipo_triangulos;
BEGIN
	FOR i IN triangulos LOOP
	DBMS_OUTPUT.PUT_LINE('El triangulo con id: ' || i.ID || 
	' con base: ' || i.triangulo.BASE || ' y altura: ' || i.triangulo.ALTURA ||
	' tiene un area de: ' || i.triangulo.area());
	END LOOP;
END;
/