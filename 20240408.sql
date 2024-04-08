--제약조건
--SELECT * FROM USER_CONSTRAINTS;
--기본키
--ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 PRIMARY KEY(기본키로 지정할 컬럼명);
--외래키
--ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 FOREIGN KEY(외래키 지정할 컬럼명)
--REFERECES 참조할테이블명(참조할테이블의 기본키) [ON DELETE CASCADE | RESTRICT] 
DROP TABLE PERSON;
CREATE TABLE PERSON(	
    PID CHAR(4),
    PNAME VARCHAR2(30 BYTE), 
    AGE NUMBER(3,0)
);
--기본키를 추가하는 방법
ALTER TABLE PERSON ADD CONSTRAINT PK_PERSON_PID PRIMARY KEY(PID);
SELECT * FROM USER_CONSTRAINTS;
INSERT INTO PERSON VALUES('0001','홍길동',20);
INSERT INTO PERSON VALUES('0002','김길동',30);
INSERT INTO PERSON VALUES('0003','이길동',40);
INSERT INTO PERSON VALUES('0004','박길동',50);
--기본키 추가하는 두번째 방법
DROP TABLE PERSON;
CREATE TABLE PERSON(	
    PID CHAR(4),
    PNAME VARCHAR2(30 BYTE), 
    AGE NUMBER(3,0),
    CONSTRAINT PK_PERSON_PID PRIMARY KEY(PID)
);

--외래키 추가하는 방법
CREATE TABLE PERSON_ORDER(
	P_ORDER_NO NUMBER(5),
	P_ORDER_MEMO VARCHAR2(300),
	PID CHAR(4)
);




