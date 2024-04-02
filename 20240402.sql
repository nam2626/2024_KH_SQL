--사원정보
--		사번, 이름, 직급명, 부서명, 급여, 입사일
CREATE TABLE EMPLOYEE(
	EMP_NO CHAR(9) PRIMARY KEY,
	EMP_NAME VARCHAR2(15) NOT NULL,
	EMP_POSITION VARCHAR2(30) DEFAULT '사원' NOT NULL,
	EMP_DEPARTMENT VARCHAR2(30),
	EMP_SALARY NUMBER(12) DEFAULT 0,
	EMP_COURSE_DATE DATE DEFAULT SYSDATE
);

SELECT SYSDATE FROM DUAL; --DUAL 임시 테이블, 값이나 연산결과 확인할때 주로 사용

CREATE TABLE PERSON(
	PNAME VARCHAR2(30),
	AGE NUMBER(3)
);

CREATE TABLE NEW_PERSON(
	PNAME CHAR(30),
	AGE NUMBER(3)
);
--DML(데이터 조작어)
--	INSERT, DELETE, UPDATE, SELECT

--INSERT INTO 테이블명(컬럼명1, 컬럼명2,....) VALUES(데이터1, 데이터2, ....)
--INSERT INTO 테이블명 VALUES(데이터1, 데이터2, ....)
INSERT INTO PERSON(PNAME, AGE) VALUES('홍길동', 20);
INSERT INTO PERSON VALUES('김철수', 33);

--여러개 데이터 INSERT
INSERT ALL 
	INTO PERSON(PNAME, AGE) VALUES('김씨', 20)
	INTO PERSON VALUES('이씨', 30)
SELECT * FROM DUAL;

--학생 테이블 데이터 3건 등록하는 INSERT문 작성
INSERT INTO NEW_STUDENT
VALUES('20241111','김철수','컴퓨터공학과',3.4);
INSERT INTO NEW_STUDENT
VALUES('20243333','박호수','문학과',4.4);
INSERT INTO NEW_STUDENT(STD_NO,STD_NEW_NAME,STD_MAJOR,STD_SCORE)
VALUES('20242222','이영수','수학과',1.4);

--사원정보 1건 등록 날짜는 문자열로 저장
--EMP_NO,EMP_NAME,EMP_POSITION,EMP_DEPARTMENT,EMP_SALARY,EMP_COURSE_DATE
INSERT INTO EMPLOYEE(EMP_NO,EMP_NAME,EMP_POSITION,
					EMP_DEPARTMENT,EMP_SALARY,EMP_COURSE_DATE)
VALUES('A20231111','김철수','과장','회계부',45000000,'2023-09-12');
INSERT INTO EMPLOYEE
VALUES('A20232223','김영희','대리','회계부','45000000','2023-09-12');
INSERT INTO EMPLOYEE
VALUES(202322231,'김영희','대리','회계부','45000000','2023-09-12');
INSERT INTO EMPLOYEE
VALUES(202322231,김영희,'대리','회계부','45000000','2023-09-12');

--SELECT 데이터 조회
--SELECT 조회할 컬럼1, 조회할 컬럼2, ....
--FROM 조회할 테이블 ....
--WHERE 조건절
--GROUP BY 그룹으로 묶을 컬럼 HAVING 그룹함수를 이용한 조건식
--ORDER BY 정렬할 기준 컬럼  [ASC | DESC]
--PERSON 테이블의 전체 컬럼, 모든 데이터 조회
SELECT * FROM PERSON;
SELECT AGE, PNAME FROM PERSON;
SELECT PNAME FROM PERSON;
--AS 는 해당 컬럼명의 별칭
SELECT PNAME AS 이름, AGE AS 나이 FROM PERSON;
SELECT PNAME, LENGTH(PNAME) AS NAME_LENGTH, AGE FROM PERSON;
--학생 테이블의 데이터 중 학과명만 조회
SELECT DISTINCT STD_MAJOR FROM NEW_STUDENT;
--조건절
--관계연산자 : > < >= <= = <>
--논리연산자 : NOT, AND, OR
--나이가 30세 이상인 사람만 조회
SELECT * FROM PERSON WHERE AGE >= 30;
--나이가 30세가 아닌 사람만 조회 != <>
SELECT * FROM PERSON WHERE AGE != 30;
--나이가 30대인 사람만 조회
SELECT * FROM PERSON WHERE AGE >= 30 AND AGE <= 39;
SELECT * FROM PERSON WHERE AGE BETWEEN 30 AND 39;
--컬럼 IN(....) 해당 컬럼의 값이 IN 안에 존재하면 true, 아니면 false 
SELECT * FROM PERSON WHERE AGE IN(30, 33, 35);
--이름이 홍길동인 사람을 조회
SELECT * FROM PERSON WHERE PNAME = '홍길동';
SELECT * FROM PERSON WHERE PNAME LIKE '홍길동';
--고정길이 문자열을 비교 했을때
SELECT * FROM NEW_PERSON 
WHERE PNAME = '한미연'; --TRUE
SELECT * FROM NEW_PERSON 
WHERE PNAME LIKE '한미연'; --전체비교로 하기떄문에 FALSE
-- % 와일드 카드 문자, 글자개수가 0개 이상 올수 있다.
--성이 김씨로 시작하는 사람을 조회
SELECT * FROM PERSON WHERE PNAME LIKE '김%';
SELECT * FROM PERSON WHERE PNAME = '김%';
--이름에 '미' 가 들어가는 사람을 조회
SELECT * FROM PERSON WHERE PNAME LIKE '%미%';
--이름이 '민'으로 끝나는 사람을 조회
SELECT * FROM PERSON WHERE PNAME LIKE '%민';
-- _ 와일드카드 문자 1글자
SELECT * FROM PERSON WHERE PNAME LIKE '김__';
SELECT * FROM PERSON WHERE PNAME LIKE '김_';
--학점이 2.5이상 3.5이하인 학생 목록을 조회
SELECT * FROM NEW_STUDENT WHERE STD_SCORE BETWEEN 2.5 AND 3.5;
--학과명이 경제학과인 학생만 조회
SELECT * FROM NEW_STUDENT WHERE STD_MAJOR LIKE '경제학과';
--학생 이름이 수로 끝나는 학생만 조회
SELECT * FROM NEW_STUDENT WHERE STD_NEW_NAME LIKE '%수';
--학과명에 경이 들어가는 학생만 조회
SELECT * FROM NEW_STUDENT WHERE STD_MAJOR LIKE '%경%';
--입사일이 2023년도인 전 직원을 조회
SELECT * FROM EMPLOYEE 
WHERE EMP_COURSE_DATE >= '2023-01-01' AND EMP_COURSE_DATE <= '2023-12-31';
SELECT * FROM EMPLOYEE 
WHERE EMP_COURSE_DATE BETWEEN  '2023-01-01' AND '2023-12-31';

--UPDATE
-- + - * /
--UPDATE 테이블명 SET 수정할컬럼명 = 수정할 값,.... WHERE 조건식
--PERSON 테이블의 데이터 중 20세 미만인 데이터는 나이를 5씩 증가
UPDATE PERSON SET AGE = AGE + 5 WHERE AGE < 20;
--학생 데이터 중 점수 1.5 미만이면 이름 제적으로 수정하겠다.
UPDATE NEW_STUDENT SET STD_NEW_NAME = '제적'
WHERE STD_SCORE < 1.5;
--PERSON 테이블에 나이가 NULL 값인 데이터를 조회
SELECT * FROM PERSON WHERE AGE IS NULL;
SELECT * FROM PERSON WHERE AGE IS NOT NULL;
--PERSON 테이블에 나이가 NULL인 데이터를 0으로 수정
UPDATE PERSON SET AGE = 0 WHERE AGE IS NULL;

--DELETE 삭제
--DELETE FROM 테이블 WHERE 조건절;
--PERSON 테이블의 데이터 중 나이가 20세 미만은 전부 삭제
DELETE FROM PERSON WHERE AGE < 20;





