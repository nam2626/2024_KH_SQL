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
