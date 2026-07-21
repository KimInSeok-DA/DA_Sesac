SELECT ename  
FROM emp;

SELECT ename ||'의 급여는 $'||sal||'입니다.'
FROM emp;

SELECT  ename 이름, sal AS 연봉, (sal/12*3) AS 보너스
FROM emp;

SELECT ENAME
	 , empno
	 , CASE
	 	WHEN mod(empno, 2) = 0 THEN '짝수'
	 	ELSE '홀수'
	 END AS id_type
FROM emp;

SELECT ename ||' is a '|| job AS emp_info
FROM emp;

SELECT CONCAT(CONCAT(ename, ' is a '), job) AS emp_info
FROM emp;

SELECT chr(100)
FROM dual;

SELECT TRIM(BOTH '$' FROM '$안녕하세요')
FROM dual;

SELECT LENGTH('안녕하세요') AS ste_len
FROM dual;

SELECT substr('leem world',1,4) AS substr
FROM dual;

SELECT mod(23,5) AS MOD
FROM dual;

-- 숫자형 : ceil, floor, round, trunc

SELECT TRUNC(3.46154, 1) AS ceil
FROM dual;


-- 날짜형 함수 --


SELECT ename
, hiredate
, extract(YEAR FROM hiredate) 입사년
, extract(MONTH FROM hiredate) 입사월
, extract(DAY FROM hiredate) 입사일
FROM emp;

SELECT ename
, hiredate
, to_char(hiredate,'yyyy') AS 입사년
, to_char(hiredate, 'mm') AS 입사월
, to_char(hiredate, 'dd') AS 입사일
FROM emp;

SELECT EXTRACT(YEAR FROM sysdate) AS CURRENT_year
FROM dual;

SELECT EXTRACT(month FROM sysdate) AS CURRENT_year
FROM dual;
