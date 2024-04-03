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







