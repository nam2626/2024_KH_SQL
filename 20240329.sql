alter user c##scott default tablespace users quota unlimited on users;

-- 학생 테이블
-- 학번, 이름, 학과명, 평점
CREATE TABLE STUDENT(
	STD_NO CHAR(8),
	STD_NAME VARCHAR2(50),
	STD_MAJOR VARCHAR2(45),
	STD_SCORE NUMBER(3,2)
);

INSERT INTO STUDENT(STD_NO, STD_NAME, STD_MAJOR, STD_SCORE)
VALUES('20201111','홍길동','컴퓨터공학과',3.24);

SELECT * FROM STUDENT;