--그룹 함수
--	테이블에 있는 데이터를 특정 컬럼을 기준으로 통계 값을 구하는 함수
--	SUM, AVG, COUNT, MAX, MIN, STDDEV, VARIANCE
-- 	SELECT 학과, AVG(평점) FROM 학생 GROUP BY 학과;
--	그룹함수 사용한 컬럼과, 그룹으로 묶은 컬럼만 조회가 가능
--	학과별 평점 총합을 조회
SELECT STD_MAJOR, SUM(STD_SCORE) AS TOTAL_SCORE 
FROM NEW_STUDENT
GROUP BY STD_MAJOR;
-- 학과별 평점 평균 조회
SELECT STD_MAJOR, TRUNC(AVG(STD_SCORE),2) AS AVG_SCORE 
FROM NEW_STUDENT
GROUP BY STD_MAJOR;
-- 학과별 평점의 최대값, 최소값을 조회
SELECT STD_MAJOR, MAX(STD_SCORE), MIN(STD_SCORE), COUNT(*)  
FROM NEW_STUDENT
GROUP BY STD_MAJOR;
-- 학과별 인원수를 조회, 평점이 3.0 이상인 학생들만 조회
SELECT STD_MAJOR, COUNT(*) AS MAJOR_COUNT
FROM NEW_STUDENT
WHERE STD_SCORE >= 3
GROUP BY STD_MAJOR; 

SELECT STD_MAJOR, COUNT(*) AS MAJOR_COUNT 
FROM NEW_STUDENT
GROUP BY STD_MAJOR;

--현재 학생 테이블에 있는 전체 점수 총합, 평균, 최대/최소값, 학생 수 조회
SELECT SUM(STD_SCORE), AVG(STD_SCORE), MAX(STD_SCORE),
	MIN(STD_SCORE) ,COUNT(*) 
FROM NEW_STUDENT;

--현재 학생 테이블에 있는 데이터를 기준으로 학과별, 인원수를 조회
--단 조회하는 인원수가 3명 이상인 학과만 조회
SELECT STD_MAJOR, COUNT(*) AS MAJOR_COUNT 
FROM NEW_STUDENT
GROUP BY STD_MAJOR 
HAVING COUNT(*) >= 3 ;
--학과별 인원수 조회시 학과 평균 점수가 2.0 이하인 학과만 조회
SELECT STD_MAJOR, COUNT(*) AS MAJOR_COUNT, AVG(STD_SCORE) AS AVG_SCORE 
FROM NEW_STUDENT
GROUP BY STD_MAJOR 
HAVING AVG(STD_SCORE) <= 2.0;

--학생 테이블 제거 후 아래 테이블로 생성 후 샘플데이터 저장
CREATE TABLE STUDENT(
	STD_NO CHAR(8) PRIMARY KEY,
	STD_NAME VARCHAR2(30) NOT NULL,
	STD_MAJOR VARCHAR2(30),
	STD_SCORE NUMBER(3,2) DEFAULT 0 NOT NULL,
    STD_GENDER CHAR(1)
);

--입학한 년도별, 학과별, 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT SUBSTR(STD_NO,1,4), STD_MAJOR, STD_GENDER, 
	COUNT(*) AS STUDENT_COUNT, AVG(STD_SCORE) AS AVG_SCORE,
	SUM(STD_SCORE) AS SUM_SCORE
FROM STUDENT
GROUP BY SUBSTR(STD_NO,1,4), STD_MAJOR, STD_GENDER ;

--입학한 년도별, 학과별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT SUBSTR(STD_NO,1,4), STD_MAJOR, 
	COUNT(*) AS STUDENT_COUNT, AVG(STD_SCORE) AS AVG_SCORE,
	SUM(STD_SCORE) AS SUM_SCORE
FROM STUDENT
GROUP BY SUBSTR(STD_NO,1,4), STD_MAJOR;

--입학한 년도별, 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT SUBSTR(STD_NO,1,4),
	COUNT(*) AS STUDENT_COUNT, AVG(STD_SCORE) AS AVG_SCORE,
	SUM(STD_SCORE) AS SUM_SCORE
FROM STUDENT
GROUP BY SUBSTR(STD_NO,1,4) ;
--학과별로 인원수, 평점 평균, 평점 총합를 조회하세요.

--학과별, 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.

--성별로 인원수, 평점 평균, 평점 총합를 조회하세요.

--전체 인원수, 평점 평균, 평점 총합를 조회하세요.