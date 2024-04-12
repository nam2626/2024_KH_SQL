--그룹함수 테스트용 테이블
CREATE TABLE GROUP_TEST(
	CODE VARCHAR2(1),
	VAL NUMBER(3)
);

INSERT INTO GROUP_TEST VALUES('A',10);
INSERT INTO GROUP_TEST VALUES('B',20);
INSERT INTO GROUP_TEST VALUES('C',NULL);
INSERT INTO GROUP_TEST VALUES('D',30);
INSERT INTO GROUP_TEST VALUES('F',40);
--그룹함수는 NULL 값을 제외하고 계산함
SELECT SUM(VAL), AVG(VAL), AVG(NVL(VAL,0)),COUNT(*),COUNT(VAL)
FROM GROUP_TEST;
-------------------------------------------------------------------
-- 함수
CREATE OR REPLACE FUNCTION GET_ODD_EVEN(N IN NUMBER)
RETURN VARCHAR2
IS
	MSG VARCHAR2(100);
BEGIN
	IF N = 0 THEN 
		MSG := '0입니다.';
	ELSIF MOD(N,2) = 1 THEN
		MSG := '홀수 입니다.';
	ELSE
		MSG := '짝수 입니다.';
	END IF;
	RETURN MSG;
END;

SELECT GET_ODD_EVEN(3), GET_ODD_EVEN(4), GET_ODD_EVEN(0) FROM DUAL;

--성적 등급 구하는 함수
--성적 등급 : A+, A, B+, B, C+, C, D+, D, F
CREATE OR REPLACE FUNCTION GET_SCORE_GRADE(SCORE IN NUMBER)
RETURN VARCHAR2
IS
	GRADE VARCHAR2(2);
	TEMP NUMBER;
BEGIN
	TEMP := TRUNC(SCORE / 0.5,0);
	IF TEMP = 9 THEN 
		GRADE := 'A+';
	ELSIF TEMP = 8 THEN 
			GRADE := 'A';
	ELSIF TEMP = 7 THEN 
			GRADE := 'B+';
	ELSIF TEMP = 6 THEN 
			GRADE := 'B';
	ELSIF TEMP = 5 THEN 
			GRADE := 'C+';
	ELSIF TEMP = 4 THEN 
			GRADE := 'C';
	ELSIF TEMP = 3 THEN 
			GRADE := 'D+';
	ELSIF TEMP = 2 THEN 
			GRADE := 'D';
	ELSE
		GRADE := 'F';
	END IF;
	RETURN GRADE;
END;
----
CREATE OR REPLACE FUNCTION GET_SCORE_GRADE(SCORE IN NUMBER)
RETURN VARCHAR2
IS
	--변수 선언
	GRADE VARCHAR2(2);
BEGIN
	--실행할 코드
	IF SCORE = 4.5 THEN 
		GRADE := 'A+';
	ELSIF SCORE >= 4.0 THEN 
			GRADE := 'A';
	ELSIF SCORE >= 3.5 THEN 
			GRADE := 'B+';
	ELSIF SCORE >= 3 THEN 
			GRADE := 'B';
	ELSIF SCORE >= 2.5 THEN 
			GRADE := 'C+';
	ELSIF SCORE >= 2.0 THEN 
			GRADE := 'C';
	ELSIF SCORE >= 1.5 THEN 
			GRADE := 'D+';
	ELSIF SCORE >= 1.0 THEN 
			GRADE := 'D';
	ELSE
		GRADE := 'F';
	END IF;
	RETURN GRADE;
END;
SELECT GET_SCORE_GRADE(3.4) FROM DUAL;

-----------------------------
--학과번호를 받아서 학과명 리턴 함수
-----------------------------
CREATE OR REPLACE FUNCTION GET_MAJOR_NAME(IN_MAJOR_NO IN VARCHAR2)
RETURN VARCHAR2
IS 
	NAME VARCHAR2(30);
BEGIN
	SELECT MAJOR_NAME INTO NAME FROM MAJOR WHERE MAJOR_NO = IN_MAJOR_NO;
	RETURN NAME;
END;
/;
SELECT 
	S.*, GET_MAJOR_NAME(S.MAJOR_NO), 
	GET_SCORE_GRADE(S.STD_SCORE) 
FROM STUDENT S;

SELECT GET_MAJOR_NAME('AA') FROM DUAL;
---반복문
CREATE OR REPLACE FUNCTION TOTAL_NUM(NUM IN NUMBER)
RETURN NUMBER
IS
	TOTAL NUMBER;
	I NUMBER;
BEGIN
	TOTAL := 0;
	I := 1;

	LOOP
		TOTAL := TOTAL + I;
		I := I + 1;
		EXIT WHEN I > NUM;
	END LOOP;

	TOTAL := 0;
	I := 1;

	WHILE(I <= NUM)
	LOOP
		TOTAL := TOTAL + I;
		I := I + 1;
	END LOOP;

	TOTAL := 0;
	I := 1;
	
	FOR I IN 1 .. NUM
	LOOP
		TOTAL := TOTAL + I;
	END LOOP;

	RETURN TOTAL;
END;

SELECT TOTAL_NUM(10) FROM DUAL;









