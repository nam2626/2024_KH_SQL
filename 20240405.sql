--조인
CREATE TABLE A(
	CODE CHAR(1),
	VAL NUMBER(1)
);
CREATE TABLE B(
	CODE CHAR(1),
	UNIT CHAR(1)
);
INSERT INTO A VALUES('A',1);
INSERT INTO A VALUES('B',2);
INSERT INTO A VALUES('C',3);
INSERT INTO A VALUES('D',4);

INSERT INTO B VALUES('A','+');
INSERT INTO B VALUES('B','-');
INSERT INTO B VALUES('C','*');
INSERT INTO B VALUES('F','/');

SELECT * FROM A;
SELECT * FROM B;

-- 동일 조인
SELECT A.CODE, A.VAL, B.CODE, B.UNIT
FROM A, B
WHERE A.CODE = B.CODE;

--INNER JOIN
SELECT A.CODE, A.VAL, B.CODE, B.UNIT
FROM A INNER JOIN B ON A.CODE = B.CODE;

--자연 조인(NATURAL JOIN)
SELECT * FROM A NATURAL JOIN B;





