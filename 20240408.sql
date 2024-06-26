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
	PID CHAR(4),
	CONSTRAINT PK_P_ORDER_NO PRIMARY KEY(P_ORDER_NO),
	CONSTRAINT FK_PO_PID FOREIGN KEY(PID)
	REFERENCES PERSON(PID)
);
--기본키
ALTER TABLE PERSON_ORDER 
ADD CONSTRAINT PK_P_ORDER_NO PRIMARY KEY(P_ORDER_NO);
--외래키
ALTER TABLE PERSON_ORDER
ADD CONSTRAINT FK_PO_PID FOREIGN KEY(PID)
REFERENCES PERSON(PID);

INSERT INTO PERSON_ORDER VALUES(1, '지시 내용', '0001');
INSERT INTO PERSON_ORDER VALUES(2, '지시 내용', '0002');
INSERT INTO PERSON_ORDER VALUES(3, '지시 내용', '0003');
--에러, PERSON 테이블에 해당 PID 값이 없을때
INSERT INTO PERSON_ORDER VALUES(4, '지시 내용', '0005');

SELECT * FROM PERSON;
SELECT * FROM PERSON_ORDER;

--부모 레코드를 지우기전에 자식 레코드를 먼저 삭제
DELETE FROM PERSON_ORDER WHERE PID LIKE '0001';
--PERSON 테이블에 PID가 0001인 데이터를 삭제 -> RESTRICT는 자식 레코드가 있으면 멈춤
DELETE FROM PERSON WHERE PID LIKE '0001';

--제약조건 삭제 - FK_PO_PID
ALTER TABLE PERSON_ORDER DROP CONSTRAINT FK_PO_PID;

--외래키 제약조건, CASCADE -> 삭제시 자식 레코드도 같이 삭제
ALTER TABLE PERSON_ORDER ADD CONSTRAINT FK_PO_PID
FOREIGN KEY(PID) REFERENCES PERSON(PID) ON DELETE CASCADE;
--외래키 제약조건, SET NULL -> 삭제시 자식 레코드 값을 NULL로 변경
ALTER TABLE PERSON_ORDER ADD CONSTRAINT FK_PO_PID
FOREIGN KEY(PID) REFERENCES PERSON(PID) ON DELETE SET NULL;
--PERSON 테이블에 PID가 0003인 데이터를 삭제
DELETE FROM PERSON WHERE PID LIKE '0003';
--PERSON, PERSON_ORDER 테이블 확인
SELECT * FROM PERSON;
SELECT * FROM PERSON_ORDER;

DROP TABLE PERSON CASCADE CONSTRAINTS;

SELECT * FROM USER_CONSTRAINTS WHERE CONSTRAINT_NAME LIKE '%FK%';

--STUDENT 테이블의 학과번호를 외래키로 지정, MAJOR의 테이블의 학과번호로 지정
SELECT * FROM MAJOR;

ALTER TABLE STUDENT ADD CONSTRAINT FK_MAJOR_NO FOREIGN KEY(MAJOR_NO)
REFERENCES MAJOR(MAJOR_NO) ON DELETE CASCADE;
--STUDENT_SCHOLARSHIP 테이블의 학번을 외래키로 지정, STUDENT 테이블의 학번으로 지정
--매칭되는 데이터가 없으면 에러가 남, 부모키가 없습니다.
--일치하지 않는 데이터를 처리(삭제, 수정)
ALTER TABLE STUDENT_SCHOLARSHIP 
ADD CONSTRAINT FK_STD_NO FOREIGN KEY(STD_NO)
REFERENCES STUDENT(STD_NO);

--학번이 일치하지 않는 데이터를 장학금 테이블에서 삭제
DELETE FROM STUDENT_SCHOLARSHIP WHERE STD_NO
IN(SELECT SS.STD_NO 
FROM STUDENT S RIGHT OUTER JOIN STUDENT_SCHOLARSHIP SS 
ON S.STD_NO = SS.STD_NO
WHERE S.STD_NO IS NULL);

SELECT SS.STD_NO 
FROM STUDENT S RIGHT OUTER JOIN STUDENT_SCHOLARSHIP SS 
ON S.STD_NO = SS.STD_NO
WHERE S.STD_NO IS NULL;

--CHECK 제약조건
--컬럼에 들어올 값의 범위 및 제약을 거는 방법
--ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 CHECK(조건식)
--PERSON 테이블에 나이가 0보다 큰값만 저장되게끔 제약조건을 설정
DELETE FROM PERSON;
ALTER TABLE PERSON DROP CONSTRAINT CHECK_AGE;
ALTER TABLE PERSON ADD CONSTRAINT CHECK_AGE CHECK(AGE BETWEEN 0 AND 100);
--데이터 추가 나이가 0이하인 데이터를 INSERT 
INSERT INTO PERSON VALUES('0006','임길동',-10);
INSERT INTO PERSON VALUES('0006','임길동',10);

--PERSON 테이블에 데이터 추가시 이름에 공백이 들어가지 않도록 제약조건을 설정
ALTER TABLE PERSON ADD CONSTRAINT CHECK_NAME CHECK(PNAME NOT LIKE '% %');
INSERT INTO PERSON VALUES('0007','임길동',10);
ALTER TABLE PERSON DROP CONSTRAINT CHECK_NAME;
--ALTER TABLE PERSON ADD CONSTRAINT CHECK_NAME CHECK(PNAME <> '% %'); (X)
DELETE FROM PERSON WHERE PID = '0008';
INSERT INTO PERSON VALUES('0008','곽 길동',10);
SELECT INSTR('곽길동',' ') FROM DUAL;
ALTER TABLE PERSON ADD CONSTRAINT CHECK_NAME CHECK(INSTR(PNAME,' ') != 0);
--이런식으로 여러개 컬럼을 체크하는 제약은 조건은 두지 않음
--ALTER TABLE PERSON ADD CONSTRAINT CHECK_COLUMN CHECK(AGE > 0 AND INSTR(PNAME,' ') != 0);

--학생 테이블에 평점이 0.0~4.5까지만 저장되게끔 제약조건을 추가
ALTER TABLE STUDENT ADD CONSTRAINT CHECK_SCORE_RANGE 
CHECK(STD_SCORE >= 0 AND STD_SCORE <= 4.5);

ALTER TABLE STUDENT ADD CONSTRAINT CHECK_SCORE_RANGE 
CHECK(STD_SCORE BETWEEN 0 AND 4.5);

ALTER TABLE STUDENT DROP CONSTRAINT CHECK_SCORE_RANGE;
--학생 이름은 6글자 이하로만 등록 되게끔 제약조건을 추가
ALTER TABLE STUDENT 
ADD CONSTRAINT CHECK_NAME_LENGTH CHECK(LENGTH(STD_NAME) <= 6);
--데이터 오류가 발생하는지 체크
INSERT INTO STUDENT 
VALUES('11112222','김철수안녕하',3.6,'M','L0');

------------------------------------------------------------------------
--정렬 ORDER BY 컬럼명 [ASC | DESC], 컬럼명 [ASC | DESC]....;
--ASC : 오름차순(기본값), DESC : 내림차순

--PERSON 테이블 전체 조회시 나이 기준으로 정렬
SELECT * FROM PERSON ORDER BY AGE; --오름차순
SELECT * FROM PERSON ORDER BY AGE DESC; --내림차순

--학생 테이블 조회시
--점수 기준으로 내림차순 정렬, 학번 기준으로 내림차순 정렬
SELECT * FROM STUDENT
ORDER BY STD_SCORE DESC, STD_NO DESC;

SELECT ROWNUM, S.* FROM STUDENT S
ORDER BY S.STD_SCORE DESC;

SELECT ROW_NUMBER() OVER(ORDER BY S.STD_SCORE DESC), S.* FROM STUDENT S;

--------------------------------------------------------------------------
--서브쿼리(Sub Query)
--	하나의 SQL문에 또 다른 SQL문이 있는 형태
--	단일 행, 멀티 행, 다중 컬럼, 스칼라(컬럼에 서브쿼리가 들어가는 형태)

-- 조건식에 들어가는 서브쿼리
-- 평점이 최고점에 해당하는 학생 정보를 조회
--평점이 최대값인 점수를 조회
SELECT MAX(STD_SCORE) FROM STUDENT;
--서브쿼리를 조건식에 적용해서 조회
SELECT * FROM STUDENT 
WHERE STD_SCORE = (SELECT MAX(STD_SCORE) FROM STUDENT);
-- 평점이 평균 이상인 학생 정보를 조회
SELECT * FROM STUDENT 
WHERE STD_SCORE >= (SELECT AVG(STD_SCORE) FROM STUDENT);
--평점이 최고점인 학생과, 최저점인 학생을 조회
--조회할 컬럼은 학번, 이름, 학과명, 평점, 성별
SELECT * FROM STUDENT
WHERE STD_SCORE = (SELECT MAX(STD_SCORE) FROM STUDENT) OR
STD_SCORE = (SELECT MIN(STD_SCORE) FROM STUDENT);

SELECT * FROM STUDENT
WHERE STD_SCORE IN(
(SELECT MAX(STD_SCORE) FROM STUDENT),
(SELECT MIN(STD_SCORE) FROM STUDENT)
);

--평균 이하인 학생들의 평점을 0.5점 증가
UPDATE STUDENT SET STD_SCORE = STD_SCORE  + 0.5
WHERE STD_SCORE <= (SELECT AVG(STD_SCORE) FROM STUDENT);

--장학금을 받는 학생들만조회, 단, IN 서브쿼리를 활용해서 조회
SELECT * FROM STUDENT
WHERE STD_NO IN(SELECT STD_NO FROM STUDENT_SCHOLARSHIP);

--장학금을 못 받는 학생들만조회, 단, IN 서브쿼리를 활용해서 조회
--불일치 쿼리
SELECT * FROM STUDENT
WHERE STD_NO NOT IN(SELECT STD_NO FROM STUDENT_SCHOLARSHIP);

--학과별로 최고점을 가진 학생들을 조회
--1. 학과별로 최고점을 가진 점수를 조회, 학과 번호, 최고점 조회
SELECT MAJOR_NO, MAX(STD_SCORE)
FROM STUDENT
GROUP BY MAJOR_NO;

--2. 서브 쿼리를 이용해서 다중 컬럼 비교
SELECT * FROM STUDENT
WHERE (MAJOR_NO, STD_SCORE) IN(
	SELECT MAJOR_NO, MAX(STD_SCORE)
	FROM STUDENT
	GROUP BY MAJOR_NO
);

--3. 조인을 이용해서 조회
SELECT S.*
FROM 
STUDENT S INNER JOIN
(SELECT MAJOR_NO, MAX(STD_SCORE) AS MAX_SCORE
FROM STUDENT
GROUP BY MAJOR_NO) M
ON S.MAJOR_NO = M.MAJOR_NO
WHERE S.STD_SCORE = M.MAX_SCORE;

---FROM 절에 들어가는 서브쿼리
--학생정보 조회시 학번, 이름, 학과명, 평점을 조회
--평점을 기준으로 내림차순 정렬하여 조회
--SELECT 후에 ORDER BY가 실행되기 때문에 ROWNUM이 뒤죽박죽 상태가 된다.
SELECT ROWNUM, S.STD_NO, S.STD_NAME, S.STD_SCORE, M.MAJOR_NAME
FROM STUDENT S INNER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO
ORDER BY S.STD_SCORE DESC;
--이 것을 해결해기 위해 서브쿼리로 작업
SELECT ROWNUM, S.*
FROM 
(SELECT S.STD_NO, S.STD_NAME, S.STD_SCORE, M.MAJOR_NAME
FROM STUDENT S INNER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO
ORDER BY S.STD_SCORE DESC
) S;
--제일 위에 데이터 5건만 조회
SELECT ROWNUM, S.*
FROM 
(SELECT S.STD_NO, S.STD_NAME, S.STD_SCORE, M.MAJOR_NAME
FROM STUDENT S INNER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO
ORDER BY S.STD_SCORE DESC
) S
WHERE ROWNUM <= 5;

-- 행번호가 6번부터 10번 데이터까지만 조회
SELECT * FROM 
(
SELECT ROWNUM AS RW, S.*
FROM 
	(SELECT S.STD_NO, S.STD_NAME, S.STD_SCORE, M.MAJOR_NAME
	FROM STUDENT S INNER JOIN MAJOR M
	ON S.MAJOR_NO = M.MAJOR_NO
	ORDER BY S.STD_SCORE DESC
	) S
)
WHERE RW BETWEEN 6 AND 10;

--장학금 받는 학생들 중 제일 많이 장학금을 받는 학생 TOP3 학생 목록 조회
--학번, 이름, 학과명, 장학금 금액
SELECT * FROM
(
SELECT 
	DENSE_RANK() OVER(ORDER BY SS.MONEY DESC) AS MONEY_RANK,
	S.STD_NO, S.STD_NAME, M.MAJOR_NAME, SS.MONEY
FROM STUDENT S INNER JOIN STUDENT_SCHOLARSHIP SS 
ON S.STD_NO = SS.STD_NO
INNER JOIN MAJOR M
ON S.MAJOR_NO = M.MAJOR_NO
)
WHERE MONEY_RANK <= 3;

----------------------------------------------------
----최대 금액과 최소 금액를 가진 차량의 정보를 조회
SELECT MAX(CAR_PRICE) FROM CAR;
SELECT MIN(CAR_PRICE) FROM CAR;

SELECT * FROM CAR
WHERE CAR_PRICE IN(
(SELECT MAX(CAR_PRICE) FROM CAR),
(SELECT MIN(CAR_PRICE) FROM CAR)
)

SELECT * FROM CAR
WHERE 
CAR_PRICE = (SELECT MAX(CAR_PRICE) FROM CAR)
OR
CAR_PRICE = (SELECT MIN(CAR_PRICE) FROM CAR);

--제조사별 차량 종류 개수, 평균 정가를 조회
--제조사명, 개수, 정가 평균 컬럼
--조인 버전
SELECT CM.CAR_MAKER_NAME, COUNT(*), AVG(C.CAR_PRICE)
FROM car C INNER JOIN CAR_MAKER CM
ON C.CAR_MAKER_CODE = CM.CAR_MAKER_CODE
GROUP BY CM.CAR_MAKER_NAME;
--서브쿼리 버전
SELECT (SELECT CM.CAR_MAKER_NAME FROM CAR_MAKER CM 
	WHERE C.CAR_MAKER_CODE = CM.CAR_MAKER_CODE) AS CAR_MAKER_NAME, 
	CAR_COUNT, AVG_PRICE
FROM 
(SELECT 
	C.CAR_MAKER_CODE, COUNT(*) AS CAR_COUNT,
	AVG(C.CAR_PRICE) AS AVG_PRICE
FROM CAR C
GROUP BY C.CAR_MAKER_CODE) C;

--학생정보 조회시 학번, 이름, 학과명, 평점, 성별
--학과명은 서브쿼리를 이용해서 조회
SELECT S.STD_NO, S.STD_NAME, 
(
	SELECT M.MAJOR_NAME 
	FROM MAJOR M 
	WHERE M.MAJOR_NO = S.MAJOR_NO
) AS MAJOR_NAME,
S.STD_SCORE, S.STD_GENDER 
FROM STUDENT S;

--월별 최다 판매 차량 대수를 조회
--1. 월별, 차량별 총 판매 대수 조회 (month, car_no, sum_ea)
SELECT TO_CHAR(CS.CAR_SELL_DATE,'MM') AS MONTH, CS.CAR_ID,
SUM(CS.CAR_SELL_EA) AS SUM_EA 
FROM CAR_SELL CS
GROUP BY TO_CHAR(CS.CAR_SELL_DATE,'MM'), CS.CAR_ID; 
--2. 1번 데이터를 기준으로 월별 최다 판매대수를 구하면
SELECT MONTH, MAX(SUM_EA) AS MAX_EA 
FROM 
(SELECT TO_CHAR(CS.CAR_SELL_DATE,'MM') AS MONTH, CS.CAR_ID,
SUM(CS.CAR_SELL_EA) AS SUM_EA 
FROM CAR_SELL CS
GROUP BY TO_CHAR(CS.CAR_SELL_DATE,'MM'), CS.CAR_ID)
GROUP BY MONTH;
--3. 1번과 2번을 기준으로 월별 최다 판매 차량 대수를 조회, 다중 컬럼 비교식 참고
SELECT C.CAR_NAME, MONTH, SUM_EA
FROM 
(SELECT TO_CHAR(CS.CAR_SELL_DATE,'MM') AS MONTH, CS.CAR_ID,
SUM(CS.CAR_SELL_EA) AS SUM_EA 
FROM CAR_SELL CS
GROUP BY TO_CHAR(CS.CAR_SELL_DATE,'MM'), CS.CAR_ID) CT 
INNER JOIN CAR C ON CT.CAR_ID = C.CAR_ID
WHERE 
(CT.MONTH, CT.SUM_EA) IN(SELECT MONTH, MAX(SUM_EA) AS MAX_EA 
FROM 
(SELECT TO_CHAR(CS.CAR_SELL_DATE,'MM') AS MONTH, CS.CAR_ID,
SUM(CS.CAR_SELL_EA) AS SUM_EA 
FROM CAR_SELL CS
GROUP BY TO_CHAR(CS.CAR_SELL_DATE,'MM'), CS.CAR_ID)
GROUP BY MONTH);

--판매가 한번도 안된 자동차들 목록 조회 not in 사용
SELECT C.CAR_NAME
FROM CAR C
WHERE C.CAR_ID NOT IN (SELECT DISTINCT CS.CAR_ID FROM CAR_SELL CS);
--판매가 안된 자동차들을 기준으로 금액이 평균 이상인 자동차 조회
SELECT C.* FROM CAR C LEFT JOIN CAR_SELL CS
ON C.CAR_ID = CS.CAR_ID
WHERE CS.CAR_ID IS NULL;

SELECT C.* FROM CAR C LEFT JOIN CAR_SELL CS
ON C.CAR_ID = CS.CAR_ID
WHERE CS.CAR_ID IS NULL AND C.CAR_PRICE >= 
(SELECT AVG(C.CAR_PRICE) FROM CAR C LEFT JOIN CAR_SELL CS
ON C.CAR_ID = CS.CAR_ID
WHERE CS.CAR_ID IS NULL);
--판매가 안된 자동차들을 기준으로 제일 많이 안팔린 모델을 보유 중인 제조사 조회
SELECT CAR_MAKER_NAME, CAR_COUNT
FROM 
(SELECT 
	RANK() OVER(ORDER BY CC.CAR_COUNT DESC) AS RANK_NO,
	CM.CAR_MAKER_NAME, CC.CAR_COUNT
FROM 
(SELECT C.CAR_MAKER_CODE, COUNT(*) AS CAR_COUNT
FROM CAR C LEFT JOIN CAR_SELL CS
ON C.CAR_ID = CS.CAR_ID
WHERE CS.CAR_ID IS NULL
GROUP BY C.CAR_MAKER_CODE
ORDER BY CAR_COUNT DESC) CC JOIN CAR_MAKER CM
ON CC.CAR_MAKER_CODE = CM.CAR_MAKER_CODE)
WHERE RANK_NO = 1;
--판매가 안된 자동차들을 기준으로 금액이 평균 이상인 자동차 금액을 30% 할인, 소수점은 절삭
UPDATE CAR SET CAR_PRICE = TRUNC(CAR_PRICE * 0.7)
WHERE CAR_ID IN(
SELECT C.CAR_ID FROM CAR C LEFT JOIN CAR_SELL CS
ON C.CAR_ID = CS.CAR_ID
WHERE CS.CAR_ID IS NULL AND C.CAR_PRICE >= 
(SELECT AVG(C.CAR_PRICE) FROM CAR C LEFT JOIN CAR_SELL CS
ON C.CAR_ID = CS.CAR_ID
WHERE CS.CAR_ID IS NULL));









