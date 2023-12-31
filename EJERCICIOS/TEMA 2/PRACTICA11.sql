CREATE OR REPLACE TYPE tip_telefonos AS VARRAY(3) OF VARCHAR(15);
/

CREATE OR REPLACE TYPE tip_direccion AS OBJECT(
calle varchar(50),
poblacion varchar(50), 
codpos varchar(20),
provincia varchar(40)
);
/

CREATE OR REPLACE TYPE tip_cliente AS OBJECT(
idcliente number,
nombre varchar(50),
direc tip_direccion,
nif varchar(9),
telef  tip_telefonos
);
/

CREATE OR REPLACE TYPE tip_producto  AS OBJECT(
idproducto number,
descripcion varchar(80),
pvp number,
stockactual number
);

/
CREATE OR REPLACE TYPE tip_lineaventa  AS OBJECT(
numerolinea number,
idproducto REF tip_producto,
cantidad number
);
/

CREATE OR REPLACE TYPE tip_linea_venta AS TABLE OF tip_lineaventa;
/

CREATE OR REPLACE TYPE tip_venta  AS OBJECT(
idventa number,
idcliente ref tip_cliente,
fechaventa date,
lineas tip_linea_venta,
member function total_venta return number);
/

--3
CREATE OR REPLACE TYPE BODY tip_venta AS
MEMBER FUNCTION total_venta return NUMBER IS
TOTAL NUMBER:=0;
LINEA TIP_LINEAVENTA;
PRODUCT TIP_PRODUCTO;
	BEGIN
		FOR I IN 1..LINEAS.COUNT LOOP
			LINEA:=LINEAS(I);
			SELECT DEREF(LINEA.IDPRODUCTO) INTO PRODUCT FROM DUAL;
			TOTAL:=TOTAL+LINEA.CANTIDAD*PRODUCT.PVP;
		END LOOP;
		return TOTAL;
	END;
END;
/

--4
CREATE TABLE tabla_clientes OF tip_cliente(
idcliente PRIMARY KEY 
);

CREATE TABLE tabla_productos OF tip_producto(
idproducto PRIMARY KEY 
);

CREATE TABLE tabla_ventas OF tip_venta(
idventa PRIMARY KEY
) NESTED TABLE LINEAS STORE AS TABLA_LINEAS;

--5
INSERT INTO tabla_clientes VALUES(1,'Luis Garcia',tip_direccion('calle Las Flores, 23','Guadalajara','19003','Guadalajara'),'34343434L', tip_telefonos('94986665','94986666'));
INSERT INTO tabla_clientes VALUES(2,'Ana Serrano',tip_direccion('calle Galiana, 6','Guadalajara','19004','Guadalajara'),'76767676F', tip_telefonos('94980009'));
INSERT INTO tabla_productos VALUES(1,'Caja de cristal de murano', 100, 5);
INSERT INTO tabla_productos VALUES(2,'Bicicleta City', 120, 15);
INSERT INTO tabla_productos VALUES(3,'100 lapices de colores', 20, 5);
INSERT INTO tabla_productos VALUES(4,'IPad', 600, 5);
INSERT INTO tabla_productos VALUES(5,'Ordenador portatil', 400, 10);
INSERT INTO tabla_ventas values(1,(select ref (C) from tabla_clientes C where C.idcliente=1),sysdate,tip_linea_venta(tip_lineaventa(1,(select ref(P) from tabla_productos P where idproducto=1),1),tip_lineaventa(2,(select ref(P) from tabla_productos P where idproducto=2),2)));
INSERT INTO tabla_ventas values(2,(select ref (C) from tabla_clientes C where C.idcliente=1),sysdate,tip_linea_venta(tip_lineaventa(1,(select ref(P) from tabla_productos P where idproducto=1),2),tip_lineaventa(2,(select ref(P) from tabla_productos P where idproducto=2),1),tip_lineaventa(3,(select ref(P) from tabla_productos P where idproducto=3),4)));

--6.1
SELECT v.lineas FROM tabla_ventas v where v.idventa=2;
select lin.* from tabla_ventas v, table(v.lineas) lin where v.idventa=2;	
--6.2	
select lin.numerolinea,lin.cantidad,deref(lin.idproducto) from tabla_ventas v,table(v.lineas) lin where v.idventa=2;
--6.3
select idventa,lin.* from tabla_ventas v, table(v.lineas) lin;
--6.4 
select nombre from tabla_clientes where idcliente=2;
--6.5
update tabla_clientes set nombre='Rosa Serrano' where idcliente=2;
--6.6
select c.direc from tabla_clientes c where idcliente=2;
update tabla_clientes set direc=tip_direccion('calle Estopa, 34', 'Guadalajara','19004','Guadalajara') where idcliente=2;
--update tabla_clientes set direc.calle='calle Estopa, 34' where direc.calle='calle Galiana, 6';
--6.7
select * from tabla_clientes where idcliente=1;
select value(c) from tabla_clientes c where idcliente=1;
update tabla_clientes set telef=tip_telefonos('94986665','94986666','90000000') where idcliente=1;
--6.8
select v.idcliente.nombre from tabla_ventas v where v.idventa=2;
select DEREF(v.idcliente).nombre from tabla_ventas v where v.idventa=2;
--6.9
select DEREF(v.idcliente) from tabla_ventas v where v.idventa=2;
--6.10
select v.idventa, v.total_venta() from tabla_ventas v where v.idcliente.idcliente=1;
select v.idventa,v.total_venta() from tabla_ventas v where deref(v.idcliente).idcliente=1;
--6.11
SELECT v.idventa, deref(idcliente), v.fechaventa from tabla_ventas v;
--6.12
CREATE OR REPLACE PROCEDURE VER_VENTA(ID NUMBER) AS
	LIN NUMBER;
	CANT NUMBER;
	IMPORTE NUMBER;
	TOTAL_V NUMBER;
	PRODUC TIP_PRODUCTO:=TIP_PRODUCTO(NULL,NULL,NULL,NULL);
	CLI TIP_CLIENTE:=TIP_CLIENTE(NULL,NULL,NULL,NULL,NULL);
	DIR TIP_DIRECCION:=TIP_DIRECCION(NULL,NULL,NULL,NULL);
	FEC DATE;
	
CURSOR C1 IS SELECT lin.numerolinea, DEREF(lin.idproducto), lin.cantidad
from tabla_ventas v, TABLE(v.lineas) lin WHERE v.idventa=ID;
BEGIN
	SELECT DEREF(idcliente),fechaventa, v.total_venta() into CLI, FEC, TOTAL_V
	FROM tabla_ventas v where idventa=ID;
	DIR:=CLI.DIREC;
	DBMS_OUTPUT.PUT_LINE('NUMERO DE VENTA:'||ID||'*FECHA DE VENTEA: '||FEC);
	DBMS_OUTPUT.PUT_LINE('CLIENTE: '||CLI.NOMBRE);
	DBMS_OUTPUT.PUT_LINE('DIRECCION: '||DIR.CALLE);
	DBMS_OUTPUT.PUT_LINE('*******************************************');
OPEN C1;
FETCH C1 INTO LIN, PRODUC, CANT;
WHILE C1%FOUND LOOP
	IMPORTE:=CANT*PRODUC.PVP;
	DBMS_OUTPUT.PUT_LINE(LIN||'*'||PRODUC.DESCRIPCION||'*'||PRODUC.PVP||'*'||CANT||'*'||IMPORTE);
FETCH C1 INTO LIN,PRODUC,CANT;
END LOOP;
CLOSE C1;
DBMS_OUTPUT.PUT_LINE('TOTAL VENTA: '||TOTAL_V);
END;
/

BEGIN
	VER_VENTA(2);
END;
/