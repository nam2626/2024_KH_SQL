--함수
--DUAL 임시 테이블, 값을 확인하는 용도
--SYSDATE, 현재 날짜 시간 값
SELECT 'HELLO', 10+2 FROM DUAL;
SELECT SYSDATE FROM DUAL;

--문자열 함수
--INITCAP : 각 단어별 첫글자는 대문자로 변환, 나머지는 소문자로 변환
SELECT INITCAP('hello world') FROM DUAL;
SELECT INITCAP('HELLO WORLD') FROM DUAL;
--LOWER : 알파벳 모두 소문자로 변경
--UPPER : 알파벳 모두 대문자로 변경
SELECT LOWER('Hello World'), UPPER('Hello World') FROM DUAL;  
--LENGTH : 글자 개수
SELECT LENGTH('Hello'), LENGTH('안녕하세요') FROM DUAL;
--LENGTHB : 글자의 바이트 수
SELECT LENGTHB('Hello'), LENGTHB('안녕하세요') FROM DUAL;
--PERSON, NEW_PERSON 테이블의 PNAME을 LENGTH를 이용해서 조회
SELECT LENGTH(PNAME), LENGTHB(PNAME) FROM PERSON;
SELECT LENGTH(PNAME), LENGTHB(PNAME) FROM NEW_PERSON;
--CONCAT : 두 문자열을 하나로 합치기
SELECT CONCAT('HELLO', 'WORLD') FROM DUAL; 
--전화번호 데이터가 '010' '1111' '1234'를 CONCAT 함수를 이용해서 하나의 문자열로 합치기
SELECT CONCAT(CONCAT('010','1111'),'1234') FROM DUAL; 
SELECT CONCAT(CONCAT('010',1111),1234) FROM DUAL; 
-- || : 양쪽의 데이터를 하나의 문자열로 합쳐줌
SELECT '010' || '1111' || '1234' FROM DUAL;
SELECT '010' || 1111 || '1234' FROM DUAL;
--PERSON 테이블의 내용을 김철수-20 이런 형식으로 조회
SELECT PNAME || '-' || AGE AS RESULT FROM PERSON;

SELECT * FROM USER_TABLES;
--모든 테이블 DROP SQL문 작성
SELECT 'DROP TABLE ' || TABLE_NAME || ';' FROM USER_TABLES;
--문자열 추출
--SUBSTR : 문자열 부분 추출(문자 기준으로 추출)
SELECT SUBSTR('1234567890',5,4) FROM DUAL;
SELECT SUBSTR('안녕하세요',2,3) FROM DUAL;
--주민등록번호 '841113-1246121' --> '841113-1******' 마스킹 처리
SELECT SUBSTR('841113-1246121',1,8) || '******' FROM DUAL;
--PERSON 테이블의 전체 데이터 조회시 이름 가운에데 * 마스킹 처리해서 조회
--SUBSTR, LENGTH
SELECT SUBSTR(PNAME,1,1) || '*' || SUBSTR(PNAME,LENGTH(PNAME),1) AS PNAME,
	AGE FROM PERSON;
--바이트 단위로 문자열 추출
SELECT SUBSTRB('안녕하세요',2,3) FROM DUAL;
SELECT SUBSTRB('ABCDEFG',2,3) FROM DUAL;

--문자열 검색 INSTR - 검색결과가 있으면 0보다 큰 값, 검색 결과가 없으면 0
SELECT INSTR('abcdefg','cd') FROM DUAL;
SELECT INSTR('abcdefg','cdf') FROM DUAL;
--HELLO WORLD 문자열에 공백이 있는지 체크
SELECT INSTR('HELLO WORLD',' ') FROM DUAL;
--테이블 NAME 컬럼에 공백을 넣지 않는 조건
--CHECK(INSTR(NAME,' ') = 0) -->이런 형태로 테이블의 제약조건에 들어감

--문자열 바꾸기
SELECT REPLACE('AAAAAAABBBBBCCCC','B','F') FROM DUAL;
--학생 테이블의 이름 데이터를 학과명을 공학, 학으로 변경하는 UPDATE문을 작성
UPDATE NEW_STUDENT SET STD_MAJOR = REPLACE(STD_MAJOR,'공학','학')
WHERE INSTR(STD_MAJOR,'공학') <> 0;

--LPAD, RPAD : 원하는 문자열 개수만큼 남은 부분에 지정한 문자열로 채워주는 함수
SELECT RPAD('871211-1',14,'*') FROM DUAL; 
SELECT LPAD('871211-1',14,'*') FROM DUAL; 

SELECT LPAD('ABC',10,'1234') FROM DUAL;
SELECT RPAD('ABC',10,'1234') FROM DUAL;

--TRIM : 필요없는 좌우 공백을 제거
SELECT TRIM('      A   B   C       '),'      A   B   C       ' FROM DUAL;
SELECT LENGTH(TRIM('      A   B   C       ')),
LENGTH('      A   B   C       ') FROM DUAL;
--LTRIM, RTRIM : 좌우에 지정한 문자열을 제거
SELECT LTRIM('AAAABBBBBCCCCCDDDDDDAAAAA','A') FROM DUAL;
SELECT RTRIM('AAAABBBBBCCCCCDDDDDDAAAAA','A') FROM DUAL;
SELECT LTRIM('AABAACBBBBBCCCCCDDDDDDAAAAA','ABC') FROM DUAL;
SELECT RTRIM('AAABACBBBBBCCCCCDDDDDDAACABAA','ABC') FROM DUAL;
----------------------------------------------------------------------------
---ROUND : 원하는 자리수에서 반올림
---   -2 -1   0 1 2
--- 1  2  3 . 4 5 6
SELECT ROUND(123.456,-2) FROM DUAL;
SELECT ROUND(123.456,-1) FROM DUAL;
SELECT ROUND(123.456,0) FROM DUAL;
SELECT ROUND(123.456,1) FROM DUAL;
SELECT ROUND(123.456,2) FROM DUAL;
--올림 : CEIL, 내림 : FLOOR
SELECT CEIL(123.456), FLOOR(123.456) FROM DUAL;
--TRUNC : 원하는 자리수에서 데이터를 자름
SELECT TRUNC(123.456,-2) FROM DUAL;
SELECT TRUNC(123.456,-1) FROM DUAL;
SELECT TRUNC(123.456,0) FROM DUAL;
SELECT TRUNC(123.456,1) FROM DUAL;
SELECT TRUNC(123.456,2) FROM DUAL;
--나머지 나누기 -> 6 % 4
SELECT MOD(6,4) FROM DUAL;
--POWER(N,M) : N의 M승
SELECT POWER(2,10) FROM DUAL;
--TO_NUMBER('문자열') : 문자열을 숫자로 바꿔주는 함수
SELECT '123' + 123, '123' / '2', TO_NUMBER('123') / 2  FROM DUAL;
-------------------------------------------------------------------
--날짜시간
SELECT SYSDATE FROM DUAL;
--오라클에서 지정된 현재 날짜 시간의 출력 포멧을 변경 - 현재 연결된 세션에서만 가능
ALTER SESSION SET nls_date_format = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET nls_date_format = 'YY/MM/DD';
--TO_CHAR(데이터, '형식') 문자열로 변환
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL; --HH 12시간 기준
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL; --HH24 24시간 기준
SELECT TO_CHAR(SYSDATE, 'MON MONTH DY DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON MONTH DY DAY','NLS_DATE_LANGUAGE=ENGLISH') FROM DUAL;
--숫자 포맷팅
-- 9 : 숫자 한자리, 없는 경우 생략
-- 0 : 숫자 한자리, 없는 경우 0 출력
-- L : 통화 기호(지역 설정 기준)
-- , : 천단위 구분 기호
-- G : 천단위 구분 기호(지역 설정 기준)
-- FM : 불필요한 공백 제거
-- PR : 음수일 경우 <> 표시
SELECT TO_CHAR(1234567.89, 'FM9,999,999.000') AS NUM1,
TO_CHAR(1234567.89, '09,999,999.999') AS NUM2
FROM DUAL;
SELECT TO_CHAR(1234567.89, 'FML9,999,999.000') FROM DUAL;
SELECT TO_CHAR(-1234567.89, 'FM9,999,999.000PR') FROM DUAL;
SELECT TO_CHAR(1234567.89, 'FM9,999,999.000PR') FROM DUAL;
SELECT TO_CHAR(1234567.89, 'FM9,999,999') FROM DUAL;
SELECT TO_CHAR(123, 'FM999999999999'),TO_CHAR(123, 'FM00000000000') FROM DUAL;

--오늘 날짜부터 지정된 날짜기 남은 개월 수
SELECT ABS(MONTHS_BETWEEN(SYSDATE,'2024-12-31')) FROM DUAL;
--지정 날짜부터 몇 개월 후 날짜
SELECT ADD_MONTHS(SYSDATE,2) FROM DUAL;
--주어진 날짜 기준으로 돌아오는 날짜(원하는 요일)
SELECT NEXT_DAY(SYSDATE,'수') FROM DUAL;
--주어진 날짜 기준으로 날짜가 속한 달의 마지막 날
SELECT LAST_DAY(SYSDATE) FROM DUAL;
--내일 날짜 출력
SELECT SYSDATE + 1 FROM DUAL;
--문자열 날짜로 변경
SELECT TO_DATE('2024-04-02','YYYY-MM-DD') FROM DUAL;
--올해 수능 날까지의 D-DAY 출력 앞으로 225일
SELECT CEIL(TO_DATE('2024-11-14','YYYY-MM-DD') - SYSDATE) FROM DUAL;

--윈도우 함수
SELECT RANK() OVER(ORDER BY AGE DESC) ,PNAME, AGE FROM PERSON;
SELECT DENSE_RANK() OVER(ORDER BY AGE DESC) ,PNAME, AGE FROM PERSON;
SELECT ROW_NUMBER() OVER(ORDER BY AGE), PNAME, AGE FROM PERSON;
-- 줄번호 키워드
SELECT ROWNUM, PNAME, AGE FROM PERSON ORDER BY AGE;
SELECT ROWNUM , P.* FROM
(SELECT PNAME, AGE FROM PERSON ORDER BY AGE) P;
-- 현재 행을 기준으로 다음 위치에 해당하는 값을 읽어오는 함수
SELECT LEAD(PNAME) OVER(ORDER BY PNAME), PNAME, AGE FROM PERSON;
SELECT LEAD(PNAME,2,'다음 데이터 없음') OVER(ORDER BY PNAME), PNAME, AGE FROM PERSON;
-- 현재 행을 기준으로 이전 위치에 해당하는 값을 읽어오는 함수
SELECT LAG(PNAME) OVER(ORDER BY PNAME), PNAME, AGE FROM PERSON;
SELECT LAG(PNAME,2,'다음 데이터 없음') OVER(ORDER BY PNAME), PNAME, AGE FROM PERSON;

--NULL 처리하는 함수
--첫번째 값이 NULL일때 두번째 값을 리턴, NULL이 아니면 그냥 현재값을 리턴
SELECT NVL(NULL,'널값'), NVL('100','널값') FROM DUAL;
--첫번쨰 값이 NULL일떄, 3번째값을 리턴, NULL이 아니면 두번째 값을 리턴
SELECT NVL2(NULL,'널이 아닌 값','널 값'), NVL2('a','널이 아닌 값','널 값')
FROM DUAL;
-- 첫번째 값을 가지고 매칭 되는 값의 오른쪽에 있는 데이터를 리턴
-- 매칭 되는 값이 없으면 마지막 값을 리턴
SELECT DECODE(1,1,'A',2,'B','C') FROM DUAL; 
SELECT DECODE(2,1,'A',2,'B','C') FROM DUAL; 
SELECT DECODE(4,1,'A',2,'B',3,'C',4,'D','F') FROM DUAL; 

--학생 테이블에서 학생정보 조회시 
--학번의 경우 앞에 4자리만 표현하고 나머지 4자리는 마스킹 처리 해서 조회

--평점을 기준으로 학생들 성적 순위를 출력, 성적순은 내림차순으로 처리
--평점 출력시 3.20 형식으로 출력이 되게끔 처리

--사원 테이블에서 데이터 조회시 연봉 순위를 조회, 입사일은 입사년도만 출력
--연봉을 출력시 천단위 기호가 붙게끔 처리



