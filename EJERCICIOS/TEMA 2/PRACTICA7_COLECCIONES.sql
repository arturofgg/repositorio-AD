CREATE OR REPLACE TYPE COLEC_DEPARTAMENTO AS VARRAY(7) OF VARCHAR(30);
/
CREATE TABLE DEPARTAMENTOS(
REGION VARCHAR2(25), 
NOMBRES_DEPT COLEC_DEPARTAMENTO
);

INSERT INTO DEPARTAMENTOS VALUES(
'EUROPA',
COLEC_DEPARTAMENTO('SHIPPING','SALES','FINANCES')
);
INSERT INTO DEPARTAMENTOS VALUES(
'AMERICA',
COLEC_DEPARTAMENTO('SALES','FINANCES','SHIPPING')
);
INSERT INTO DEPARTAMENTOS VALUES(
'ASIA',
COLEC_DEPARTAMENTO('FINANCES','PAYROLL','SHIPPING','SALES')
);

SELECT * FROM DEPARTAMENTOS;

DECLARE
	V_COLEC COLEC_DEPARTAMENTO:=COLEC_DEPARTAMENTO('BENEFITS','ADVERTISING','CONTRACTING','EXECUTIVE','MARKETING');
BEGIN
	UPDATE DEPARTAMENTOS SET NOMBRES_DEPT=V_COLEC WHERE REGION='EUROPA';
	FOR I IN V_COLEC.FIRST..V_COLEC.LAST LOOP
		DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO=' || V_COLEC(I));
	END LOOP;
END;
/

DECLARE
	REG DEPARTAMENTOS.REGION%TYPE;
    NOMBRES_DEPT COLEC_DEPARTAMENTO;
    cursor DEP_cursor is SELECT * FROM DEPARTAMENTOS;
BEGIN
    OPEN DEP_cursor;
    LOOP
        FETCH DEP_cursor INTO REG,NOMBRES_DEPT;
        EXIT WHEN DEP_cursor%NOTFOUND;--EL LOOP SE VA A SALIR CUANDO EL CURSOR NO ENCUENTRE NADA MAS
        DBMS_OUTPUT.PUT_LINE('REGION:' || REG);
        FOR i IN 1..NOMBRES_DEPT.COUNT LOOP 
		--SE CREA UN BUCLE DENTRO DE OTRO, EL PRIMERO PARA LOS EMPLEADOS Y EL SEGUNDO PARA LOS HIJOS DE ESTOS
		--EN SQL LOS ARRAYS EMPIEZAN EN 1 NO EN 0
            DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO (' || i || ') ' || NOMBRES_DEPT(i));
        END LOOP;
    END LOOP;
    CLOSE DEP_cursor;
END;
/