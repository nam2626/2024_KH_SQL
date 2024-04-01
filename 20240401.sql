--DDL
--	데이터베이스의 객체 및 구성 요소를 정의 및 변경, 삭제
--	CREATE : 데이터베이스 구성 요소를 생성(테이블, 인덱스, 시퀸스, 사용자....)
--	ALTER : 생성된 요소를 변경할 때 사용
--	DROP : 생성된 요소를 삭제할 때 사용
-- 	TRUNCATE : 테이블의 모든 행을 빠르게 삭제하고, 공간을 해제 구조는 유지함

--테이블 생성구문
--	PERSON 테이블 생성
--		이름 -> 문자열
--		나이 -> 숫자
CREATE TABLE PERSON(
	PNAME VARCHAR2(30),
	AGE NUMBER(3)
);

--데이터 5건 넣는 SQL문 작성
INSERT INTO PERSON (PNAME, AGE) VALUES ('John', 25);
INSERT INTO PERSON (PNAME, AGE) VALUES ('Emma', 30);
INSERT INTO PERSON (PNAME, AGE) VALUES ('Michael', 40);
INSERT INTO PERSON (PNAME, AGE) VALUES ('Sophia', 22);
INSERT INTO PERSON (PNAME, AGE) VALUES ('William', 35);
INSERT INTO PERSON (PNAME) VALUES ('TEST');

--테이블 삭제 구문 --> 삭제시 모든 데이터가 날아간다.
DROP TABLE PERSON;
--테이블 데이터 삭제 구문 --> 테이블은 남고, 데이터만 전부 삭제
TRUNCATE TABLE PERSON;

--학생 테이블
-- 학번, 이름, 학과명, 평점
CREATE TABLE STUDENT(
	STD_NO CHAR(8) PRIMARY KEY, -- 기본키 설정을 할때
	STD_NAME VARCHAR2(30) NOT NULL, --데이터를 반드시 입력을 받아야할 때
	STD_MAJOR VARCHAR2(30),
	STD_SCORE NUMBER(3,2) DEFAULT 0 -- 데이터가 안들어왔을 때 기본값 설정
);

--학생 데이터 5건 저장
INSERT INTO STUDENT (STD_NO, STD_NAME, STD_MAJOR, STD_SCORE) 
VALUES ('20240001', '홍길동', '컴퓨터 공학', 3.5);
INSERT INTO STUDENT (STD_NO, STD_NAME, STD_MAJOR, STD_SCORE) 
VALUES ('20240002', '김영희', '수학', NULL);
INSERT INTO STUDENT (STD_NO, STD_NAME, STD_MAJOR, STD_SCORE) 
VALUES ('20240003', '이철수', NULL, 2.8);
INSERT INTO STUDENT (STD_NO, STD_NAME, STD_MAJOR, STD_SCORE) 
VALUES ('20240004', '박영희', '생물학', 4.3);
INSERT INTO STUDENT (STD_NO, STD_NAME, STD_MAJOR, STD_SCORE) 
VALUES ('20240005', '정재현', '물리학', 1.9);



DROP TABLE STUDENT;







