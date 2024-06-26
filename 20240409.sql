-- index
-- 테이블에 있는 데이터를 빠르게 검색하기 위한 용도 나온 데이터 베이스 객체
-- 테이블 하나 이상의 컬럼으로 인덱스를 만들 수 있음
-- 오라클에서는 기본적으로 테이블 기본키로 인덱스가 설정 되어 있음
SELECT * FROM USER_INDEXES; --모든 인덱스 정보 조회
--CREATE [UNIQUE] INDEX 인덱스명 ON 테이블명(컬럼1, 컬럼2....);
CREATE INDEX PERSON_IDX ON PERSON(PNAME);
--리빌딩 작업
--데이터를 추가 삭제 수정등의 작업을 하다보면 트리가 한쪽로 치우쳐지는 현상이 나기 때문
ALTER INDEX PERSON_IDX REBUILD;
--인덱스 삭제
DROP INDEX PERSON_IDX;

CREATE UNIQUE INDEX PERSON_IDX ON PERSON(PNAME);

SELECT * FROM PERSON;
--UNIQUE 속성 때문에 이름이 중복된 데이터를 넣을 수 없다.
INSERT INTO PERSON VALUES('0000','홍길동',20);

--CAR_SELL 테이블에 판매날짜에 인덱스 적용
CREATE INDEX CAR_SELL_IDX_SELL_DATE ON CAR_SELL(CAR_SELL_DATE);

--시퀸스
--자동으로 증가하는 순번을 반환하는 데이터베이스 객체
CREATE SEQUENCE NO_SEQ;

SELECT NO_SEQ.NEXTVAL FROM DUAL;
SELECT NO_SEQ.CURRVAL FROM DUAL;

CREATE SEQUENCE TEST_SEQ
INCREMENT BY 2
START WITH 4
MINVALUE 4
MAXVALUE 10
CYCLE --NOCYCLE
CACHE 2;

CREATE SEQUENCE TEST_SEQ
INCREMENT BY -1
START WITH 1
MINVALUE 1
MAXVALUE 10
CYCLE --NOCYCLE
CACHE 5 --NOCACHE;

DROP SEQUENCE TEST_SEQ;

SELECT TEST_SEQ.NEXTVAL FROM DUAL;
--시퀸스 목록
SELECT * FROM USER_SEQUENCES;

--제공되는 암호화 함수 
SELECT STANDARD_HASH('암호화할 데이터','SHA512'),
	LENGTH(STANDARD_HASH('암호화할 데이터','SHA512')) FROM DUAL;
SELECT STANDARD_HASH('123456','SHA512'),
	LENGTH(STANDARD_HASH('123456','SHA512')) FROM DUAL;


---------------------
CREATE TABLE BOARD_MEMBER (
	BOARD_MEMBER_ID	VARCHAR2(50)		NOT NULL,
	BOARD_MEMBER_NAME	VARCHAR2(50)		NULL,
	BOARD_MEMBER_PASSWD	CHAR(128)		NOT NULL,
	BOARD_MEMBER_NICK	VARCHAR2(50)		NULL
);

CREATE TABLE BOARD (
	BOARD_NO	NUMBER		NOT NULL,
	BOARD_MEMBER_ID	VARCHAR2(50)		NOT NULL,
	BOARD_TITLE	VARCHAR2(150)		NULL,
	BOARD_CONTENT	VARCHAR2(3000)		NULL,
	BOARD_COUNT	NUMBER	DEFAULT 0	NULL,
	BOARD_WRITE_DATE	DATE	DEFAULT SYSDATE	NULL
);

CREATE TABLE BOARD_CONTENT_LIKE (
	BOARD_MEMBER_ID	VARCHAR2(50)		NOT NULL,
	BOARD_NO	NUMBER		NOT NULL
);

CREATE TABLE BOARD_CONTENT_HATE (
	BOARD_MEMBER_ID	VARCHAR2(50)		NOT NULL,
	BOARD_NO	NUMBER		NOT NULL
);

CREATE TABLE BOARD_COMMENT (
	BOARD_COMMENT_NO	NUMBER		NOT NULL,
	BOARD_MEMBER_ID	VARCHAR2(50)		NOT NULL,
	BOARD_NO	NUMBER		NOT NULL,
	BOARD_COMMENT_CONTENT	VARCHAR2(1000)		NULL,
	BOARD_COMMENT_WRITE_DATE	DATE	DEFAULT SYSDATE	NULL
);

CREATE TABLE BOARD_COMMENT_LIKE (
	BOARD_MEMBER_ID	VARCHAR2(50)		NOT NULL,
	BOARD_COMMENT_NO	NUMBER		NOT NULL
);

CREATE TABLE BOARD_COMMENT_HATE (
	BOARD_MEMBER_ID	VARCHAR2(50)		NOT NULL,
	BOARD_COMMENT_NO	NUMBER		NOT NULL
);

CREATE TABLE BOARD_FILE (
	BOARD_FILE_NO	CHAR(10)		NOT NULL,
	BOARD_NO	NUMBER		NOT NULL,
	BOARD_FILE_URL	VARCHAR2(100)		NULL
);

--제약조건
--기본키, 외래키 적용
--회원 아이디 기본키
ALTER TABLE BOARD_MEMBER 
ADD CONSTRAINT PK_MEMBER_ID PRIMARY KEY(BOARD_MEMBER_ID);
--게시판 글번호 기본키
ALTER TABLE BOARD
ADD CONSTRAINT PK_BOARD_NO PRIMARY KEY(BOARD_NO);
--게시글 첨부파일 파일번호 기본키
ALTER TABLE BOARD_FILE
ADD CONSTRAINT PK_BOARD_FILE_NO PRIMARY KEY(BOARD_FILE_NO);
--댓글 번호 기본키
ALTER TABLE BOARD_COMMENT
ADD CONSTRAINT PK_BOARD_COMMENT_NO PRIMARY KEY(BOARD_COMMENT_NO);

--게시판 테이블에 회원 아이디를 외래키로 지정
ALTER TABLE BOARD ADD CONSTRAINT FK_BOARD_MEMBER_ID
FOREIGN KEY(BOARD_MEMBER_ID) REFERENCES BOARD_MEMBER(BOARD_MEMBER_ID)
ON DELETE CASCADE;

--댓글 테이블 회원 아이디, 게시판 글번호를 외래키로 지정
ALTER TABLE BOARD_COMMENT ADD CONSTRAINT FK_COMMENT_BOARD_MEMBER_ID
FOREIGN KEY(BOARD_MEMBER_ID) REFERENCES BOARD_MEMBER(BOARD_MEMBER_ID)
ON DELETE CASCADE;

ALTER TABLE BOARD_COMMENT ADD CONSTRAINT FK_COMMENT_BOARD_NO
FOREIGN KEY(BOARD_NO) REFERENCES BOARD(BOARD_NO) ON DELETE CASCADE;

--게시글 좋아요, 싫어요, 회원아이디, 게시글 번호
ALTER TABLE BOARD_CONTENT_LIKE ADD CONSTRAINT FK_BCL_MEMBER_ID
FOREIGN KEY(BOARD_MEMBER_ID) REFERENCES BOARD_MEMBER(BOARD_MEMBER_ID)
ON DELETE CASCADE;

ALTER TABLE BOARD_CONTENT_LIKE ADD CONSTRAINT FK_BCL_BOARD_NO
FOREIGN KEY(BOARD_NO) REFERENCES BOARD(BOARD_NO)
ON DELETE CASCADE;

ALTER TABLE BOARD_CONTENT_HATE ADD CONSTRAINT FK_BCH_MEMBER_ID
FOREIGN KEY(BOARD_MEMBER_ID) REFERENCES BOARD_MEMBER(BOARD_MEMBER_ID)
ON DELETE CASCADE;

ALTER TABLE BOARD_CONTENT_HATE ADD CONSTRAINT FK_BCH_BOARD_NO
FOREIGN KEY(BOARD_NO) REFERENCES BOARD(BOARD_NO)
ON DELETE CASCADE;

--댓글 좋아요 싫어요, 회원 아이디, 댓글 번호
ALTER TABLE BOARD_COMMENT_LIKE ADD CONSTRAINT FK_BCML_MEMBER_ID
FOREIGN KEY(BOARD_MEMBER_ID) REFERENCES BOARD_MEMBER(BOARD_MEMBER_ID)
ON DELETE CASCADE;

ALTER TABLE BOARD_COMMENT_LIKE ADD CONSTRAINT FK_BCML_BOARD_NO
FOREIGN KEY(BOARD_COMMENT_NO) REFERENCES BOARD_COMMENT(BOARD_COMMENT_NO)
ON DELETE CASCADE;

ALTER TABLE BOARD_COMMENT_HATE ADD CONSTRAINT FK_BCMH_MEMBER_ID
FOREIGN KEY(BOARD_MEMBER_ID) REFERENCES BOARD_MEMBER(BOARD_MEMBER_ID)
ON DELETE CASCADE;

ALTER TABLE BOARD_COMMENT_HATE ADD CONSTRAINT FK_BCMH_BOARD_NO
FOREIGN KEY(BOARD_COMMENT_NO) REFERENCES BOARD_COMMENT(BOARD_COMMENT_NO)
ON DELETE CASCADE;

--첨부파일, 글번호
ALTER TABLE BOARD_FILE ADD CONSTRAINT FK_BOARD_FILE_BNO
FOREIGN KEY(BOARD_NO) REFERENCES BOARD(BOARD_NO)
ON DELETE CASCADE;

--게시판 글번호, 댓글 번호를 관리할 시퀸스
--글번호 : 490번부터 시작
--board_seq 시퀸스 작성
CREATE SEQUENCE BOARD_SEQ
START WITH 490;
SELECT BOARD_SEQ.NEXTVAL FROM DUAL;
SELECT BOARD_SEQ.CURRVAL FROM DUAL;
--댓글 번호 시퀸스
CREATE SEQUENCE BOARD_COMMENT_SEQ;

--샘플데이터
--페이징, 조회, 서브쿼리, 그룹함수, 조인
--전체 게시글 조회
--글번호, 제목, 작성자(닉네임) 조회수, 작성일
SELECT 
	B.BOARD_NO, B.BOARD_TITLE, 
	BM.BOARD_MEMBER_NICK, B.BOARD_COUNT, B.BOARD_WRITE_DATE  
FROM BOARD B JOIN BOARD_MEMBER BM
ON B.BOARD_MEMBER_ID = BM.BOARD_MEMBER_ID
ORDER BY B.BOARD_NO DESC;

--글 번호별 좋아요/싫어요의 총합을 조회
--글번호, 좋아요 총합
SELECT BCL.BOARD_NO, COUNT(*) AS BOARD_LIKE_COUNT
FROM BOARD_CONTENT_LIKE BCL
GROUP BY BCL.BOARD_NO;
--글번호, 싫어요 총합
SELECT BCH.BOARD_NO, COUNT(*) AS BOARD_HATE_COUNT
FROM BOARD_CONTENT_HATE BCH
GROUP BY BCH.BOARD_NO;

--전체 게시글 조회
--글번호, 제목, 작성자(닉네임) 조회수, 작성일, 좋아요, 싫어요
SELECT 
	B.BOARD_NO, B.BOARD_TITLE, 
	BM.BOARD_MEMBER_NICK, B.BOARD_COUNT, B.BOARD_WRITE_DATE,
	NVL(BCL.BOARD_LIKE_COUNT,0) AS BOARD_LIKE_COUNT,
	NVL(BCH.BOARD_HATE_COUNT,0) AS BOARD_LIKE_COUNT
FROM BOARD B JOIN BOARD_MEMBER BM
ON B.BOARD_MEMBER_ID = BM.BOARD_MEMBER_ID
LEFT JOIN 
(SELECT BCL.BOARD_NO, COUNT(*) AS BOARD_LIKE_COUNT 
FROM BOARD_CONTENT_LIKE BCL GROUP BY BCL.BOARD_NO) BCL 
ON BCL.BOARD_NO = B.BOARD_NO
LEFT JOIN
(SELECT BCH.BOARD_NO, COUNT(*) AS BOARD_HATE_COUNT
FROM BOARD_CONTENT_HATE BCH GROUP BY BCH.BOARD_NO) BCH
ON BCH.BOARD_NO = B.BOARD_NO
ORDER BY B.BOARD_NO DESC;

--다른 버전
SELECT 
	B.BOARD_NO, B.BOARD_TITLE, 
	BM.BOARD_MEMBER_NICK, B.BOARD_COUNT, B.BOARD_WRITE_DATE,
	(SELECT COUNT(*) FROM BOARD_CONTENT_LIKE BCL 
	WHERE B.BOARD_NO = BCL.BOARD_NO) AS BOARD_LIKE_COUNT ,
	(SELECT COUNT(*) FROM BOARD_CONTENT_HATE BCH 
	WHERE B.BOARD_NO = BCH.BOARD_NO) AS BOARD_HATE_COUNT
FROM BOARD B JOIN BOARD_MEMBER BM
ON B.BOARD_MEMBER_ID = BM.BOARD_MEMBER_ID
ORDER BY B.BOARD_NO DESC;

--페이지 번호를 조회
--이전에 만든 쿼리문에 행번호를 추가, 행번호는 최근 게시글부터 1로 시작해야함
SELECT 
	ROW_NUMBER() OVER(ORDER BY B.BOARD_NO DESC),
	B.BOARD_NO, B.BOARD_TITLE, 
	BM.BOARD_MEMBER_NICK, B.BOARD_COUNT, B.BOARD_WRITE_DATE,
	NVL(BCL.BOARD_LIKE_COUNT,0) AS BOARD_LIKE_COUNT,
	NVL(BCH.BOARD_HATE_COUNT,0) AS BOARD_LIKE_COUNT
FROM BOARD B JOIN BOARD_MEMBER BM
ON B.BOARD_MEMBER_ID = BM.BOARD_MEMBER_ID
LEFT JOIN 
(SELECT BCL.BOARD_NO, COUNT(*) AS BOARD_LIKE_COUNT 
FROM BOARD_CONTENT_LIKE BCL GROUP BY BCL.BOARD_NO) BCL 
ON BCL.BOARD_NO = B.BOARD_NO
LEFT JOIN
(SELECT BCH.BOARD_NO, COUNT(*) AS BOARD_HATE_COUNT
FROM BOARD_CONTENT_HATE BCH GROUP BY BCH.BOARD_NO) BCH
ON BCH.BOARD_NO = B.BOARD_NO
ORDER BY B.BOARD_NO DESC;

--행번호를 페이지 번호로 변경
SELECT 
	CEIL(ROW_NUMBER() OVER(ORDER BY B.BOARD_NO DESC) / 20) AS PAGE,
	B.BOARD_NO, B.BOARD_TITLE, 
	BM.BOARD_MEMBER_NICK, B.BOARD_COUNT, B.BOARD_WRITE_DATE,
	NVL(BCL.BOARD_LIKE_COUNT,0) AS BOARD_LIKE_COUNT,
	NVL(BCH.BOARD_HATE_COUNT,0) AS BOARD_LIKE_COUNT
FROM BOARD B JOIN BOARD_MEMBER BM
ON B.BOARD_MEMBER_ID = BM.BOARD_MEMBER_ID
LEFT JOIN 
(SELECT BCL.BOARD_NO, COUNT(*) AS BOARD_LIKE_COUNT 
FROM BOARD_CONTENT_LIKE BCL GROUP BY BCL.BOARD_NO) BCL 
ON BCL.BOARD_NO = B.BOARD_NO
LEFT JOIN
(SELECT BCH.BOARD_NO, COUNT(*) AS BOARD_HATE_COUNT
FROM BOARD_CONTENT_HATE BCH GROUP BY BCH.BOARD_NO) BCH
ON BCH.BOARD_NO = B.BOARD_NO
ORDER BY B.BOARD_NO DESC;

--2번 페이지에 해당하는 게시글 목록 조회
SELECT * FROM(
SELECT 
	CEIL(ROW_NUMBER() OVER(ORDER BY B.BOARD_NO DESC) / 20) AS PAGE,
	B.BOARD_NO, B.BOARD_TITLE, 
	BM.BOARD_MEMBER_NICK, B.BOARD_COUNT, B.BOARD_WRITE_DATE,
	NVL(BCL.BOARD_LIKE_COUNT,0) AS BOARD_LIKE_COUNT,
	NVL(BCH.BOARD_HATE_COUNT,0) AS BOARD_HATE_COUNT
FROM BOARD B JOIN BOARD_MEMBER BM
ON B.BOARD_MEMBER_ID = BM.BOARD_MEMBER_ID
LEFT JOIN 
(SELECT BCL.BOARD_NO, COUNT(*) AS BOARD_LIKE_COUNT 
FROM BOARD_CONTENT_LIKE BCL GROUP BY BCL.BOARD_NO) BCL 
ON BCL.BOARD_NO = B.BOARD_NO
LEFT JOIN
(SELECT BCH.BOARD_NO, COUNT(*) AS BOARD_HATE_COUNT
FROM BOARD_CONTENT_HATE BCH GROUP BY BCH.BOARD_NO) BCH
ON BCH.BOARD_NO = B.BOARD_NO)
WHERE PAGE = 2;
--뷰
--일명 가상 테이블로 물리적으로 생성된 테이블이 아니라
--여러개의 테이블을 조인하여 만드는 가상 테이블로
--복잡한 쿼리문을 보다 간단하게 만들어 줄수가 있고,
--데이터만 공개 되기 때문에 데이터 원본이 있는 테이블은 알수가 없음
--데이터를 수정, 삭제, 추가를 할 수 없다.`
--뷰 권한 부여 --> 관리자 계정
GRANT CREATE VIEW TO C##SCOTT;

CREATE OR REPLACE VIEW BOARD_VIEW
AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY B.BOARD_NO DESC) AS RW,
	B.BOARD_NO, B.BOARD_TITLE, 
	BM.BOARD_MEMBER_NICK, B.BOARD_COUNT, B.BOARD_WRITE_DATE,
	NVL(BCL.BOARD_LIKE_COUNT,0) AS BOARD_LIKE_COUNT,
	NVL(BCH.BOARD_HATE_COUNT,0) AS BOARD_HATE_COUNT
FROM BOARD B JOIN BOARD_MEMBER BM
ON B.BOARD_MEMBER_ID = BM.BOARD_MEMBER_ID
LEFT JOIN 
(SELECT BCL.BOARD_NO, COUNT(*) AS BOARD_LIKE_COUNT 
FROM BOARD_CONTENT_LIKE BCL GROUP BY BCL.BOARD_NO) BCL 
ON BCL.BOARD_NO = B.BOARD_NO
LEFT JOIN
(SELECT BCH.BOARD_NO, COUNT(*) AS BOARD_HATE_COUNT
FROM BOARD_CONTENT_HATE BCH GROUP BY BCH.BOARD_NO) BCH
ON BCH.BOARD_NO = B.BOARD_NO;

SELECT * FROM BOARD_VIEW;

SELECT * FROM 
(SELECT CEIL(RW / 20) AS PAGE, BV.* FROM BOARD_VIEW BV)
WHERE PAGE = 2;

SELECT * FROM BOARD_VIEW WHERE RW BETWEEN 21 AND 40;

--댓글
--게시글 번호 236번에 해당하는 모든 댓글을 조회
SELECT * FROM BOARD_COMMENT BC
WHERE BC.BOARD_NO = 236;

--게시글 번호별로 댓글 개수를 조회 
SELECT BC.BOARD_NO, COUNT(*) AS COMMENT_COUNT
FROM BOARD_COMMENT BC
GROUP BY BC.BOARD_NO;

--게시글 목록 출력시 댓글 개수를 같이 추가해서 조회
SELECT 
	ROW_NUMBER() OVER(ORDER BY B.BOARD_NO DESC) AS RW,
	B.BOARD_NO, B.BOARD_TITLE, 
	BM.BOARD_MEMBER_NICK, B.BOARD_COUNT, B.BOARD_WRITE_DATE,
	NVL(BCL.BOARD_LIKE_COUNT,0) AS BOARD_LIKE_COUNT,
	NVL(BCH.BOARD_HATE_COUNT,0) AS BOARD_HATE_COUNT,
	NVL(BCC.COMMENT_COUNT,0) AS COMMENT_COUNT
FROM BOARD B JOIN BOARD_MEMBER BM
ON B.BOARD_MEMBER_ID = BM.BOARD_MEMBER_ID
LEFT JOIN 
(SELECT BCL.BOARD_NO, COUNT(*) AS BOARD_LIKE_COUNT 
FROM BOARD_CONTENT_LIKE BCL GROUP BY BCL.BOARD_NO) BCL 
ON BCL.BOARD_NO = B.BOARD_NO
LEFT JOIN
(SELECT BCH.BOARD_NO, COUNT(*) AS BOARD_HATE_COUNT
FROM BOARD_CONTENT_HATE BCH GROUP BY BCH.BOARD_NO) BCH
ON BCH.BOARD_NO = B.BOARD_NO
LEFT JOIN 
(SELECT BC.BOARD_NO, COUNT(*) AS COMMENT_COUNT
FROM BOARD_COMMENT BC
GROUP BY BC.BOARD_NO) BCC
ON BCC.BOARD_NO = B.BOARD_NO;

--기존 게시글 목록 보여주는 뷰도 최신화
CREATE OR REPLACE VIEW BOARD_VIEW
AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY B.BOARD_NO DESC) AS RW,
	B.BOARD_NO, B.BOARD_TITLE, 
	BM.BOARD_MEMBER_NICK, B.BOARD_COUNT, B.BOARD_WRITE_DATE,
	NVL(BCL.BOARD_LIKE_COUNT,0) AS BOARD_LIKE_COUNT,
	NVL(BCH.BOARD_HATE_COUNT,0) AS BOARD_HATE_COUNT,
	NVL(BCC.COMMENT_COUNT,0) AS COMMENT_COUNT
FROM BOARD B JOIN BOARD_MEMBER BM
ON B.BOARD_MEMBER_ID = BM.BOARD_MEMBER_ID
LEFT JOIN 
(SELECT BCL.BOARD_NO, COUNT(*) AS BOARD_LIKE_COUNT 
FROM BOARD_CONTENT_LIKE BCL GROUP BY BCL.BOARD_NO) BCL 
ON BCL.BOARD_NO = B.BOARD_NO
LEFT JOIN
(SELECT BCH.BOARD_NO, COUNT(*) AS BOARD_HATE_COUNT
FROM BOARD_CONTENT_HATE BCH GROUP BY BCH.BOARD_NO) BCH
ON BCH.BOARD_NO = B.BOARD_NO
LEFT JOIN 
(SELECT BC.BOARD_NO, COUNT(*) AS COMMENT_COUNT
FROM BOARD_COMMENT BC
GROUP BY BC.BOARD_NO) BCC
ON BCC.BOARD_NO = B.BOARD_NO;

SELECT * FROM BOARD_VIEW;

--댓글
--댓글번호, 게시글번호, 작성자, 작성일, 댓글 내용, 댓글 좋아요, 싫어요
SELECT BC.* , 
NVL(BOARD_COMMENT_LIKE,0) AS BOARD_COMMENT_LIKE,
NVL(BOARD_COMMENT_HATE,0) AS BOARD_COMMENT_HATE
FROM 
BOARD_COMMENT BC LEFT JOIN
(SELECT BCL.BOARD_COMMENT_NO, COUNT(*) AS BOARD_COMMENT_LIKE
FROM BOARD_COMMENT_LIKE BCL GROUP BY BCL.BOARD_COMMENT_NO) BCL
ON BC.BOARD_COMMENT_NO = BCL.BOARD_COMMENT_NO
LEFT JOIN
(SELECT BCH.BOARD_COMMENT_NO, COUNT(*) AS BOARD_COMMENT_HATE
FROM BOARD_COMMENT_HATE BCH GROUP BY BCH.BOARD_COMMENT_NO) BCH
ON BC.BOARD_COMMENT_NO = BCH.BOARD_COMMENT_NO

--댓글에 행번호를 붙여줌, 정렬 기준은 작성일을 기준으로 내림차순 정렬
SELECT ROW_NUMBER() OVER(ORDER BY BC.BOARD_COMMENT_WRITE_DATE DESC), BC.*, 
NVL(BOARD_COMMENT_LIKE,0) AS BOARD_COMMENT_LIKE,
NVL(BOARD_COMMENT_HATE,0) AS BOARD_COMMENT_HATE
FROM 
BOARD_COMMENT BC LEFT JOIN
(SELECT BCL.BOARD_COMMENT_NO, COUNT(*) AS BOARD_COMMENT_LIKE
FROM BOARD_COMMENT_LIKE BCL GROUP BY BCL.BOARD_COMMENT_NO) BCL
ON BC.BOARD_COMMENT_NO = BCL.BOARD_COMMENT_NO
LEFT JOIN
(SELECT BCH.BOARD_COMMENT_NO, COUNT(*) AS BOARD_COMMENT_HATE
FROM BOARD_COMMENT_HATE BCH GROUP BY BCH.BOARD_COMMENT_NO) BCH
ON BC.BOARD_COMMENT_NO = BCH.BOARD_COMMENT_NO;
--특정 게시글 목록을 조회
SELECT ROW_NUMBER() OVER(ORDER BY BC.BOARD_COMMENT_WRITE_DATE DESC), BC.*, 
NVL(BOARD_COMMENT_LIKE,0) AS BOARD_COMMENT_LIKE,
NVL(BOARD_COMMENT_HATE,0) AS BOARD_COMMENT_HATE
FROM 
BOARD_COMMENT BC LEFT JOIN
(SELECT BCL.BOARD_COMMENT_NO, COUNT(*) AS BOARD_COMMENT_LIKE
FROM BOARD_COMMENT_LIKE BCL GROUP BY BCL.BOARD_COMMENT_NO) BCL
ON BC.BOARD_COMMENT_NO = BCL.BOARD_COMMENT_NO
LEFT JOIN
(SELECT BCH.BOARD_COMMENT_NO, COUNT(*) AS BOARD_COMMENT_HATE
FROM BOARD_COMMENT_HATE BCH GROUP BY BCH.BOARD_COMMENT_NO) BCH
ON BC.BOARD_COMMENT_NO = BCH.BOARD_COMMENT_NO
WHERE BC.BOARD_NO = 221;

--뷰
CREATE OR REPLACE VIEW BOARD_COMMENT_LIST
AS
SELECT 
BC.*, 
NVL(BOARD_COMMENT_LIKE,0) AS BOARD_COMMENT_LIKE,
NVL(BOARD_COMMENT_HATE,0) AS BOARD_COMMENT_HATE
FROM 
BOARD_COMMENT BC LEFT JOIN
(SELECT BCL.BOARD_COMMENT_NO, COUNT(*) AS BOARD_COMMENT_LIKE
FROM BOARD_COMMENT_LIKE BCL GROUP BY BCL.BOARD_COMMENT_NO) BCL
ON BC.BOARD_COMMENT_NO = BCL.BOARD_COMMENT_NO
LEFT JOIN
(SELECT BCH.BOARD_COMMENT_NO, COUNT(*) AS BOARD_COMMENT_HATE
FROM BOARD_COMMENT_HATE BCH GROUP BY BCH.BOARD_COMMENT_NO) BCH
ON BC.BOARD_COMMENT_NO = BCH.BOARD_COMMENT_NO;

--뷰로 조회
SELECT 
ROW_NUMBER() OVER(ORDER BY BCL.BOARD_COMMENT_WRITE_DATE DESC) AS RW, 
BCL.* 
FROM BOARD_COMMENT_LIST BCL WHERE BOARD_NO = 221;

--게시글을 작성한 회원들의 게시글 개수, 좋아요를 받은 총 횟수, 싫어요를 받은 총 횟수를 조회
--회원이 쓴 게시글 번호만 조회
SELECT
	BM.BOARD_MEMBER_ID, COUNT(B.BOARD_NO) AS COUNT_POST,
	NVL(SUM(BCL.BOARD_LIKE),0) AS TOTAL_LIKE,
	NVL(SUM(BCH.BOARD_HATE),0) AS TOTAL_HATE
FROM
BOARD_MEMBER BM LEFT JOIN BOARD B
ON BM.BOARD_MEMBER_ID = B.BOARD_MEMBER_ID
LEFT JOIN
(SELECT BCL.BOARD_NO, COUNT(*) AS BOARD_LIKE
FROM BOARD_CONTENT_LIKE BCL GROUP BY BCL.BOARD_NO) BCL
ON B.BOARD_NO = BCL.BOARD_NO
LEFT JOIN
(SELECT BCH.BOARD_NO, COUNT(*) AS BOARD_HATE
FROM BOARD_CONTENT_HATE BCH GROUP BY BCH.BOARD_NO) BCH
ON B.BOARD_NO = BCH.BOARD_NO
GROUP BY BM.BOARD_MEMBER_ID;


