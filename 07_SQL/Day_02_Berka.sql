-- 2일차 오후 실습

SELECT * FROM  client;

-- 1. 성별 추출 (3~4번째 자리가 50 이상이면 여성)

SELECT 
      birth_number AS 원본_데이터
    , CASE 
          WHEN SUBSTR(birth_number, 3, 2) > '50' THEN '여성'
          ELSE '남성' 
      END AS 성별
FROM client;

-- 2. 실제 생년월일 추출 (여성이면 5000 빼기)
SELECT 
      birth_number AS 원본_데이터
    , CASE 
          WHEN SUBSTR(birth_number, 3, 2) > '50' THEN TO_CHAR(birth_number - 5000) 
          ELSE birth_number 
      END AS 생년월일
FROM client;

--  통합본 

SELECT 
      birth_number AS 원본_데이터
    , CASE 
          WHEN SUBSTR(birth_number, 3, 2) > '50' THEN '여성'
          ELSE '남성' 
      END AS 성별
    , CASE 
          WHEN SUBSTR(birth_number, 3, 2) > '50' THEN TO_CHAR(birth_number - 5000) 
          ELSE birth_number 
      END AS 생년월일
FROM client;

------Group by 실습

SELECT K_SYMBOL, SUM(AMOUNT)"계좌 총액"
FROM ORDERS
GROUP BY K_SYMBOL;

SELECT K_SYMBOL, Count(*), SUM(AMOUNT)"계좌 총액", AVG(Amount) "평균"
FROM ORDERS
GROUP BY K_SYMBOL;

SELECT COUNT(*) "전체건수"
     , COUNT(ACCOUNT) "계좌 수"
     , COUNT(DISTINCT ACCOUNT) "가입자 수"
     , MAX(AMOUNT) "최대 거래금액"
     , MIN(AMOUNT) "최소 거래금액"
     , AVG(AMOUNT) "평균 거래금액" 
FROM Trans;
