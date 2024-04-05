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

--교차 조인(CROSS JOIN)
SELECT * FROM A CROSS JOIN B;
SELECT * FROM A , B;

--외부 조인(OUTER JOIN)
--두 테이블을 조인시 한쪽 테이블에 일치하는 행이 없어도 데이터를 포함해서 결과를 반환
--왼쪽 외부 조인(LEFT OUTER JOIN), 오른쪽 외부 조인(RIGHT OUTER JOIN)
--LEFT OUTER JOIN
SELECT A.*, B.*
FROM A, B 
WHERE A.CODE = B.CODE(+);

SELECT A.*, B.*
FROM A LEFT OUTER JOIN B
ON A.CODE = B.CODE;

--RIGHT OUTER JOIN
SELECT A.*, B.*
FROM A, B 
WHERE A.CODE(+) = B.CODE;

SELECT A.*, B.*
FROM A RIGHT OUTER JOIN B
ON A.CODE = B.CODE;

--학과 테이블
CREATE TABLE MAJOR(
	MAJOR_NO CHAR(2) PRIMARY KEY,
	MAJOR_NAME VARCHAR2(30)
);

--학과명 뽑음
SELECT DISTINCT STD_MAJOR FROM STUDENT;

--학과번호 랜덤으로 뽑음
SELECT CHR(DBMS_RANDOM.VALUE(65,90)) 
		|| FLOOR(DBMS_RANDOM.VALUE() * 10)  FROM DUAL;

SELECT CHR(DBMS_RANDOM.VALUE(65,90)) 
	|| FLOOR(DBMS_RANDOM.VALUE() * 10), STD_MAJOR  
FROM (SELECT DISTINCT STD_MAJOR FROM STUDENT);

	
INSERT INTO MAJOR
SELECT CHR(DBMS_RANDOM.VALUE(65,90)) 
	|| FLOOR(DBMS_RANDOM.VALUE() * 10), STD_MAJOR  
FROM (SELECT DISTINCT STD_MAJOR FROM STUDENT);

--학생 테이블에 학과번호 컬럼을 추가
ALTER TABLE STUDENT ADD MAJOR_NO CHAR(2);
--학생 테이블에 학과번호 업데이트 - 학과 테이블에 있는 데이터를 서브쿼리로 조회해서
UPDATE STUDENT SET MAJOR_NO = 
(SELECT MAJOR_NO FROM MAJOR WHERE MAJOR_NAME LIKE STD_MAJOR);
--학생 테이블에 학과명 컬럼을 삭제
ALTER TABLE STUDENT DROP COLUMN STD_MAJOR;

--학생 정보 출력시
--학번 이름 학과명 평점 조회
--동일 조인
SELECT S.STD_NO, S.STD_NAME, M.MAJOR_NAME, S.STD_SCORE 
FROM STUDENT S INNER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO; 

SELECT S.STD_NO, S.STD_NAME, M.MAJOR_NAME, S.STD_SCORE 
FROM STUDENT S, MAJOR M
WHERE S.MAJOR_NO = M.MAJOR_NO; 

--장학금 테이블
CREATE TABLE STUDENT_SCHOLARSHIP(
    SCHOLARSHIP_NO NUMBER,
    STD_NO CHAR(8),
    MONEY NUMBER
);

--장학금 받는 학생의 학번, 이름, 장학금 금액 조회
SELECT S.STD_NO, S.STD_NAME, SS.MONEY
FROM STUDENT S, STUDENT_SCHOLARSHIP SS
WHERE S.STD_NO = SS.STD_NO ;

SELECT S.STD_NO, S.STD_NAME, SS.MONEY
FROM STUDENT S INNER JOIN STUDENT_SCHOLARSHIP SS
ON S.STD_NO = SS.STD_NO;

--장학금 받는 학생의 학번, 이름, 학과명, 장학금 금액 조회 
SELECT S.STD_NO, S.STD_NAME, M.MAJOR_NAME, SS.MONEY  
FROM STUDENT S, MAJOR M, STUDENT_SCHOLARSHIP SS
WHERE S.MAJOR_NO = M.MAJOR_NO AND S.STD_NO = SS.STD_NO;

SELECT S.STD_NO, S.STD_NAME, M.MAJOR_NAME, SS.MONEY  
FROM STUDENT S INNER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO
INNER JOIN STUDENT_SCHOLARSHIP SS
ON S.STD_NO = SS.STD_NO;

--학과 데이터 2건만 추가
INSERT INTO MAJOR VALUES('A9', '국어국문학과');
INSERT INTO MAJOR VALUES('B2', '생활체육학과');

--학생정보 출력
--학번 이름 학과번호 평점 학과번호 학과명
SELECT S.*, M.*
FROM STUDENT S INNER JOIN  MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO; 

SELECT S.*, M.*
FROM STUDENT S LEFT OUTER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO; 

SELECT S.*, M.*
FROM STUDENT S RIGHT OUTER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO; 

--학과 테이블에서 학생 테이블에 사용되지 않은 데이터를 조회
--학과번호, 학과명
SELECT M.*
FROM STUDENT S RIGHT OUTER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO
WHERE S.STD_NO IS NULL;

--장학금을 받지 못한 학생들을 조회
--학번 이름 학과번호 평점
SELECT S.*
FROM STUDENT S LEFT OUTER JOIN STUDENT_SCHOLARSHIP SS
ON S.STD_NO = SS.STD_NO
WHERE SS.SCHOLARSHIP_NO IS NULL;
--학번 이름 학과명 평점
SELECT S.STD_NO, S.STD_NAME, M.MAJOR_NAME, S.STD_SCORE
FROM STUDENT S LEFT OUTER JOIN STUDENT_SCHOLARSHIP SS
ON S.STD_NO = SS.STD_NO
INNER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO
WHERE SS.SCHOLARSHIP_NO IS NULL;
--학과별로 장학금을 받지 못한 학생들의 인원수를 조회
SELECT M.MAJOR_NAME, COUNT(*) AS STUDENT_COUNT
FROM STUDENT S LEFT OUTER JOIN STUDENT_SCHOLARSHIP SS
ON S.STD_NO = SS.STD_NO
INNER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO
WHERE SS.SCHOLARSHIP_NO IS NULL
GROUP BY M.MAJOR_NAME;











