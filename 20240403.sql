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





