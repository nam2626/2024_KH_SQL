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
----------------------------------
-- 트리거
----------------------------------
CREATE TABLE DATA_LOG(
	LOG_DATE DATE DEFAULT SYSDATE,
	LOG_DETAIL VARCHAR2(1000)	
);

CREATE OR REPLACE TRIGGER UPDATE_MAJOR
BEFORE
	UPDATE ON MAJOR
FOR EACH ROW 
BEGIN 
	INSERT INTO DATA_LOG(LOG_DETAIL) 
	VALUES(:OLD.MAJOR_NO || '-' || :OLD.MAJOR_NAME || ','
	|| :NEW.MAJOR_NO || '-' || :NEW.MAJOR_NAME);
END;

CREATE OR REPLACE TRIGGER INSERT_MAJOR
AFTER
	INSERT ON MAJOR
FOR EACH ROW 
BEGIN 
	INSERT INTO DATA_LOG(LOG_DETAIL) 
	VALUES(:NEW.MAJOR_NO || '-' || :NEW.MAJOR_NAME);
END;

CREATE OR REPLACE TRIGGER DELETE_MAJOR
AFTER
	DELETE ON MAJOR
FOR EACH ROW 
BEGIN 
	INSERT INTO DATA_LOG(LOG_DETAIL) 
	VALUES(:OLD.MAJOR_NO || '-' || :OLD.MAJOR_NAME);
END;
--학생 테이블 트리거
--수정 및 삭제가 발생했을때 해당 정보를 data_log 테이블 저장
--수정되는 값이나 삭제되는 값을 메세지에 포함
--INSERTING, UPDATING, DELETING
CREATE OR REPLACE TRIGGER UPDATE_STUDENT
AFTER
INSERT OR UPDATE OR DELETE ON STUDENT
FOR EACH ROW    `
BEGIN 
    IF INSERTING THEN
        INSERT INTO DATA_LOG(LOG_DETAIL) 
		VALUES(:NEW.STD_NO || ' - ' || :NEW.STD_NAME 
		|| ' - ' || :NEW.STD_SCORE || ' - ' || :NEW.MAJOR_NO || ' - ' || 'INSERT');
    ELSIF DELETING THEN
        INSERT INTO DATA_LOG(LOG_DETAIL) 
		VALUES(:OLD.STD_NO || ' - ' || :OLD.STD_NAME 
		|| ' - ' || :OLD.STD_SCORE || ' - ' || :OLD.MAJOR_NO || ' - ' || 'DELETE');
    ELSE
        INSERT INTO DATA_LOG(LOG_DETAIL) 
		VALUES(:OLD.STD_NO || ' - ' || :OLD.STD_NAME 
		|| ' - ' || :OLD.STD_SCORE || ' - ' || :OLD.MAJOR_NO || ' - ' || '/' ||
		:NEW.STD_NO || ' - ' || :NEW.STD_NAME 
		|| ' - ' || :NEW.STD_SCORE || ' - ' || :NEW.MAJOR_NO || ' - ' || 'UPDATE');    
    END IF;
    
END;

--함수 문제
--자동차 제조사 명을 매개변수로 받아서 해당 자동차의 총 판매 대수를 리턴하는 함수
CREATE OR REPLACE FUNCTION TOTAL_CAR_MAKER_SELL_EA(MAKER IN VARCHAR2)
RETURN NUMBER
IS
    TOTAL_EA NUMBER := 0;
BEGIN
    SELECT SUM(CS.CAR_SELL_EA) INTO TOTAL_EA FROM CAR_SELL CS JOIN CAR C ON CS.CAR_ID = C.CAR_ID
    JOIN CAR_MAKER CM ON C.CAR_MAKER_CODE = CM.CAR_MAKER_CODE
    WHERE CM.CAR_MAKER_NAME = MAKER;
    
    RETURN TOTAL_EA;
END;
--학생 테이블에 있는 데이터를 기준으로 평점의 최대값을 리턴하는 함수
CREATE OR REPLACE FUNCTION STUDENT_MAX_SCORE
RETURN NUMBER
IS
    SCORE NUMBER;
BEGIN
    SELECT MAX(STD_SCORE) INTO SCORE FROM STUDENT;
    RETURN SCORE;
END;

SELECT STUDENT_MAX_SCORE() FROM DUAL;
--학생 테이블에 있는 데이터를 기준으로 평점의 최소값을 리턴하는 함수
CREATE OR REPLACE FUNCTION STUDENT_MIN_SCORE
RETURN NUMBER
IS
    SCORE NUMBER;
BEGIN
    SELECT MIN(STD_SCORE) INTO SCORE FROM STUDENT;
    RETURN SCORE;
END;

SELECT STUDENT_MIN_SCORE() FROM DUAL;

--트리거
--게시판 테이블에 게시글 등록한 사람과, 등록일시, 추가한 데이터 기록
--게시판 테이블에 게시글 수정한 데이터의 수정일시, 변경 전후의 데이터를 기록
--게시판 테이블에 게시글 삭제일시, 삭제한 게시글 번호

SELECT SYS_CONTEXT('USERENV','SESSION_USER') FROM DUAL;

--로그를 저장할 테이블
CREATE TABLE BOARD_LOG (
    LOG_ID          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ACTION_TYPE     VARCHAR2(10),
    USER_ID         VARCHAR2(50),
    BOARD_NO         NUMBER,
    POST_TITLE      VARCHAR2(150),
    POST_CONTENT    VARCHAR2(3000),
    BEFORE_TITLE    VARCHAR2(150),
    BEFORE_CONTENT  VARCHAR2(3000),
    ACTION_TIMESTAMP TIMESTAMP DEFAULT SYSTIMESTAMP
);

--현재 접속 중인 사용자
SELECT SYS_CONTEXT('USERENV','SESSION_USER') FROM DUAL;


CREATE OR REPLACE TRIGGER TRG_BOARD_ACTIONS
AFTER INSERT OR UPDATE OR DELETE ON BOARD
FOR EACH ROW
DECLARE
	--변수 선언 부분
    V_USER_ID VARCHAR2(50);
BEGIN
	SELECT SYS_CONTEXT('USERENV','SESSION_USER') INTO V_USER_ID FROM DUAL;

    IF INSERTING THEN
        INSERT INTO BOARD_LOG (
            ACTION_TYPE, USER_ID, BOARD_NO, POST_TITLE, POST_CONTENT, ACTION_TIMESTAMP
        ) VALUES (
            'INSERT', V_USER_ID, :NEW.BOARD_NO, :NEW.BOARD_TITLE, :NEW.BOARD_CONTENT, SYSTIMESTAMP
        );
    ELSIF UPDATING THEN
        INSERT INTO BOARD_LOG (
            ACTION_TYPE, USER_ID, BOARD_NO, POST_TITLE, POST_CONTENT, BEFORE_TITLE, BEFORE_CONTENT, ACTION_TIMESTAMP
        ) VALUES (
            'UPDATE', V_USER_ID, :NEW.BOARD_NO, :NEW.BOARD_TITLE, :NEW.BOARD_CONTENT, :OLD.BOARD_TITLE, :OLD.BOARD_CONTENT, SYSTIMESTAMP
        );
    ELSIF DELETING THEN
        INSERT INTO BOARD_LOG (
            ACTION_TYPE, USER_ID, BOARD_NO, ACTION_TIMESTAMP
        ) VALUES (
            'DELETE', V_USER_ID, :OLD.BOARD_NO, SYSTIMESTAMP
        );
    END IF;
END;

INSERT INTO BOARD(BOARD_NO,BOARD_MEMBER_ID,BOARD_TITLE,BOARD_CONTENT,BOARD_COUNT)
VALUES(BOARD_SEQ.NEXTVAL, 'gt1442','제목','내용',0);


INSERT INTO "C##SCOTT".BOARD(BOARD_NO,BOARD_MEMBER_ID,BOARD_TITLE,BOARD_CONTENT,BOARD_COUNT)
VALUES("C##SCOTT".BOARD_SEQ.NEXTVAL, 'gt1442','제목','내용',0);

--다른 계정 생성 및 테이블/시퀸스 접근 권한 부여
CREATE USER c##user1 IDENTIFIED BY 123456;
GRANT resource, CONNECT TO c##user1;
GRANT INSERT, DELETE, UPDATE, SELECT ON c##scott.board TO c##user1;
GRANT ALTER, SELECT ON c##scott.board_seq TO c##user1;

SELECT * FROM C##SCOTT.board;

INSERT INTO "C##SCOTT".BOARD(BOARD_NO,BOARD_MEMBER_ID,BOARD_TITLE,BOARD_CONTENT,BOARD_COUNT)
VALUES("C##SCOTT".BOARD_SEQ.NEXTVAL, 'gt1442','제목','내용',0);
--------------------------------
--프로시저
--	sql 쿼리문으로 로직을 조합해서 사용하는 데이터베이스 코드
--	sql문과 제어문을 이용해서 데이터를 검색, 삽입, 수정, 삭제를 할 수 있음,
--	결과를 외부로 전달할 수도 있음
--------------------------------
--매개변수가 없을때
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE PROCEDURE_EX1
IS 
	TEST_VAR VARCHAR2(100);
BEGIN
	TEST_VAR := 'AAAAA';
	DBMS_OUTPUT.PUT_LINE(TEST_VAR);
END;

BEGIN
	PROCEDURE_EX1();
END;

--매개변수 있을 경우
CREATE OR REPLACE PROCEDURE PROCEDURE_EX2(
	PID IN VARCHAR2,
	NAME IN VARCHAR2,
	AGE IN NUMBER
) 
IS
	TEST_VAR VARCHAR2(100);
BEGIN
	TEST_VAR := 'AAAAAA';
	DBMS_OUTPUT.PUT_LINE(TEST_VAR || ' ' || NAME || ' ' || AGE);	
	INSERT INTO PERSON VALUES(PID,NAME,AGE);
	COMMIT;
END;

BEGIN
	PROCEDURE_EX2('0010','김철수',33);
END;
--값을 외부로 전달하려고 할 때
CREATE OR REPLACE PROCEDURE PROCEDURE_EX3(
	NUM IN NUMBER,
	RESULT OUT NUMBER
)
IS 
	I NUMBER;
	FAC NUMBER;
BEGIN
	I := 1;
	FAC := 1;

	--반복문 이용해서 NUM까지 곱하는 팩토리얼 작성
	FOR I IN 1 .. NUM
	LOOP	
		FAC := FAC * I;
	END LOOP;
	RESULT := FAC;
END;

DECLARE
	FAC NUMBER;
BEGIN
	PROCEDURE_EX3(5,FAC);
	DBMS_OUTPUT.PUT_LINE(FAC);
END;

--사용자 EXCEPTION 처리
CREATE OR REPLACE PROCEDURE PROCEDURE_EX4(
	NUM IN NUMBER,
	RESULT OUT NUMBER
)
IS 
	I NUMBER;
	FAC NUMBER;
	USER_EXCEPTION EXCEPTION;
BEGIN
	IF NUM = 0 THEN
		RAISE USER_EXCEPTION;
	
	I := 1;
	FAC := 1;

	FOR I IN 1 .. NUM
	LOOP	
		FAC := FAC * I;
	END LOOP;
	RESULT := FAC;
EXCEPTION
	WHEN USER_EXCEPTION THEN
		DBMS_OUTPUT.PUT_LINE('0보다 큰 값을 넣어야 합니다.');
		RESULT := -1;
	WHEN OTHERS THEN --위에 어떤한 EXCEPTION도 맞지 않는 경우
		DBMS_OUTPUT.PUT_LINE('Exception 발생');
		RESULT := -1;
END;

DECLARE
	FAC NUMBER;
BEGIN
	PROCEDURE_EX4(6,FAC);
	DBMS_OUTPUT.PUT_LINE(FAC);
END;










