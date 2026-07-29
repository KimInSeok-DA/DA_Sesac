
-- 정규표현식 실습
-- Account 테이블의 CREATE_DATE 칼럼으로부터 아래를 출력

--930503 을 05-03-93

SELECT * FROM account;

SELECT CREATE_DATE AS "변경 전 날짜"
     , TO_CHAR(TO_DATE(CREATE_DATE, 'YYMMDD'), 'DD-MM-YY') AS "변경 후 날짜"
FROM ACCOUNT;

SELECT CREATE_DATE AS "변경 전 날짜"
     , REGEXP_REPLACE(
       TO_CHAR(CREATE_DATE)                -- 대상 
     , '^([0-9]{2})([0-9]{2})([0-9]{2})$'  -- 패턴 조회 
     , '\2-\3-\1'                          -- 변경 방식
       ) AS "변경 후 날짜"

       
       
-- 종합 실습

-- <실습 1> Birth_Number
-- CLIENT테이블의 BIRTH_NUMBER로부터 생년월일과 성별을 추출하여 출력한다

WITH CLIENT_PARSED AS (
    -- 1단계(CTE): BIRTH_NUMBER에서 년(YY), 월(MM), 일(DD)을 문자로 자르고, 월은 숫자로 변환.
    SELECT client_id AS 고객번호
         , SUBSTR(TO_CHAR(birth_number), 1, 2)            AS YY
         , TO_NUMBER(SUBSTR(TO_CHAR(birth_number), 3, 2)) AS B_N
         , SUBSTR(TO_CHAR(birth_number), 5, 2)            AS DD
    FROM CLIENT
)
-- 2단계 (메인 쿼리): 50 초과 여부로 성별을 판단하고, 진짜 월(MM)을 복원하여 최종 출력.
SELECT  고객번호
      , YY || LPAD(TO_CHAR(CASE            -- 생년월일: YY + (조정한 월 2자리) + DD
                           WHEN B_N > 50 THEN B_N - 50 
                           ELSE B_N 
                       END), 2, '0')
           || DD AS 생년월일
       , CASE WHEN B_N > 50 THEN '여'       -- 성별: 월이 50보다 크면 '여', 아니면 '남'
              ELSE '남' 
    END AS 성별
FROM CLIENT_PARSED;

-- <실습 2> 지역별 대출금액
-- 각 지역(Region)별
-- 대출금액의 합,평균,최대값,최소값을 구한다.
-- [출력형식]
-- 지역명 대출금합 대출금평균 대출금최고금액 대출금최저금액

SELECT d.A3 AS 지역명
     , SUM(l.AMOUNT) AS 대출금합
     , AVG(l.AMOUNT) AS 대출금평균
     , MAX(l.AMOUNT) AS 대출금최고금액
     , MIN(l.AMOUNT) AS 대출금최저금액
FROM LOAN l
  JOIN ACCOUNT a  ON l.account_id = a.account_id
  JOIN DISTRICT d ON a.district_id = d.district_id
GROUP BY d.A3
ORDER BY 대출금합 DESC;

-- <실습 3> 고객별 거래금액
-- 고객(Client)별,월별(1~12월)
-- 거래금액합계와 최고거래금액을 출력한다. 
-- [출력형식]
-- 고객번호 거래월 거래금액합계 최고거래금액


SELECT c.client_id   AS 고객번호
     , SUBSTR(TO_CHAR(t.TRANS_DATE), 3, 2) AS 거래월  --  YYMMDD 형식에서 3번째 자리부터 2글자(월) 추출
     , SUM(t.amount) AS 거래금액합계
     , MAX(t.amount) AS 최고거래금액
FROM CLIENT c
  JOIN DISP d    ON c.client_id = d.client_id
  JOIN ACCOUNT a ON d.account_id = a.account_id
  JOIN TRANS t   ON a.account_id = t.account_id
GROUP BY c.client_id 
       , SUBSTR(TO_CHAR(t.TRANS_DATE), 3, 2)    
ORDER BY 고객번호, 거래월;


-- <실습 4> 연령대별 카드 발급 형황
-- 30대 이하, 40대이상으로 나누어 
-- 연령대별 신용카드 발급 개수를 출력한다. 
-- [출력형식]
-- 연령대 카드발급개수
-- ** 현재 기준으로 할경우 전부 40대 이상이라 1999년으로 진행


WITH CLIENT_AGE AS (
    -- 1단계: BIRTH_NUMBER에서 태어난 연도(YY)를 추출하여 나이와 연령대를 미리 계산.
    SELECT client_id
         , CASE 
            -- 2000년 기준 나이 계산: 99 - 태어난 연도(YY) +1
              WHEN 99 - TO_NUMBER(SUBSTR(TO_CHAR(birth_number), 1, 2))+1 < 40 THEN '30대 이하'
              ELSE '40대 이상'
           END AS 연령대
    FROM CLIENT
)
-- 2단계: 위에서 만든 연령대 가상 테이블(CTE)과 DISP, CARD 테이블을 조인하여 카운트합니다.
SELECT ca.연령대
     , COUNT(c.card_id) AS 카드발급개수
FROM CLIENT_AGE ca
  JOIN DISP d ON ca.client_id = d.client_id
  JOIN CARD c ON d.disp_id = c.disp_id
GROUP BY ca.연령대
ORDER BY ca.연령대;

-- <실습 5> 대출 고객 현황
-- 1) 대출을 받은 고객의 평균거래금액,거래빈도,잔액,대출상환상태를 출력하고
-- 2) 대출 상환 상태에 따라 평균잔액과 평균거래빈도를 출력한다.
-- [출력형식]
-- 1)
-- 고객번호 평균거래금액 거래빈도 잔액 대출상환상태
-- 2)
-- 대출상환상태 평균잔액 평균거래빈도

-- 1) 대출을 받은 고객의 평균거래금액, 거래빈도, 잔액, 대출상환상태 출력
SELECT c.client_id       AS 고객번호
     , AVG(t.amount)     AS 평균거래금액
     , COUNT(t.trans_id) AS 거래빈도
     , AVG(t.balance)    AS 잔액  
     , l.status          AS 대출상환상태
FROM CLIENT c
  JOIN DISP d  ON c.client_id = d.client_id
  JOIN LOAN l  ON d.account_id = l.account_id
  JOIN TRANS t ON d.account_id = t.account_id
GROUP BY c.client_id, l.status
HAVING COUNT(t.trans_id) > 0; -- 힌트 적용: 실제 거래 내역이 존재하는 고객만 확실히 필터링

-- 2) 대출 상환 상태에 따른 평균잔액과 평균거래빈도 출력
SELECT sub.대출상환상태
     , AVG(sub.잔액)    AS 평균잔액
     , AVG(sub.거래빈도) AS 평균거래빈도
FROM (-- [서브쿼리 시작] 1단계의 쿼리 활용
      SELECT c.client_id       AS 고객번호
           , AVG(t.amount)     AS 평균거래금액
           , COUNT(t.trans_id) AS 거래빈도
           , AVG(t.balance)    AS 잔액
           , l.status          AS 대출상환상태
      FROM CLIENT c
        JOIN DISP d  ON c.client_id = d.client_id
        JOIN LOAN l  ON d.account_id = l.account_id
        JOIN TRANS t ON d.account_id = t.account_id
      GROUP BY c.client_id, l.status
      HAVING COUNT(t.trans_id) > 0
      -- [서브쿼리 끝]
      ) sub                                
GROUP BY sub.대출상환상태
ORDER BY sub.대출상환상태;

-- <실습 6> 자동이체 유형별 비중

-- 자동이체(Orders)의 유형별 총 금액과 전체 자동이체 금액 대비 비중(%)를 계산하여 출력한다.
-- (비중은 소수점 2자리까지 반올림하여 출력)
-- [출력형식]
-- 자동이체유형 금액합계 비중

SELECT k_symbol       AS 자동이체유형
     , SUM(amount)    AS 금액합계
       -- 비중(%) 계산: (유형별 합계 / 전체 합계) * 100 후 반올림
     , ROUND(SUM(TO_NUMBER(amount))
          / (SELECT SUM(TO_NUMBER(amount)) FROM ORDERS) 
             * 100, 2)AS 비중
FROM ORDERS
-- ** k_symbol NULL을 제외하고 싶다면 아래 주석을 해제.
-- WHERE k_symbol IS NOT NULL
GROUP BY k_symbol
ORDER BY 비중 DESC;


-- <실습 7> 연체 위험 고객 추출
-- 1993년 7월 기준 대출잔액이 남아 있는 계좌 중, 
-- 최근3달 동안의 평균 거래잔액이 그 이전 3달 동안의 평균 거래잔액보다 
-- 50%이상 금감한 계좌를 추출하여 출력한다. 
-- 1) 구분연월은 9301~9312로 1993년 거래가 있는 계좌만 필터링
-- 2) 구분월 칼럼을 대상으로 1993년 7월인 경우만 필터링해서 출력
-- [출력형식]
-- 계좌번호 구분연월 대출잔액 3개월평균잔액 연체위험여부

WITH MONTHLY_BAL AS (-- 1. 계좌별/월별 평균잔액 및 대출잔액 산출
                     SELECT t.account_id
                          , SUBSTR(TO_CHAR(t.trans_date), 1, 4) AS 구분연월
                          , SUBSTR(TO_CHAR(t.trans_date), 3, 2) AS 구분월
                          , AVG(t.balance) AS monthly_avg_bal
                          , MAX(l.amount) AS loan_balance
                     FROM TRANS t
                       JOIN LOAN l ON t.account_id = l.account_id
                       -- 1993년 거래가 있는 계좌만 1차 필터링
                     WHERE SUBSTR(TO_CHAR(t.trans_date), 1, 4) BETWEEN '9301' AND '9312'
                     GROUP BY t.account_id 
                            , SUBSTR(TO_CHAR(t.trans_date), 1, 4)
                            , SUBSTR(TO_CHAR(t.trans_date), 3, 2))
, ROLLING_3M AS (-- 2. 최근 3개월 평균잔액 산출
                 SELECT account_id
                      , 구분연월
                      , 구분월
                      , loan_balance
                      , AVG(monthly_avg_bal) OVER(PARTITION BY account_id 
                                                  ORDER BY 구분연월 
                                                  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS recent_3m_avg
                 FROM MONTHLY_BAL)
, LAG_COMPARE AS (-- 3. 이전 3개월 평균잔액
                  SELECT account_id
                       , 구분연월
                       , 구분월
                       , loan_balance
                       , recent_3m_avg
                       , LAG(recent_3m_avg, 3) OVER(PARTITION BY account_id 
                                                    ORDER BY 구분연월         ) AS prev_3m_avg
                  FROM ROLLING_3M)
SELECT account_id   AS 계좌번호
     , 구분연월
     , loan_balance AS 대출잔액
     , ROUND(recent_3m_avg, 2) AS "3개월평균잔액"
     , CASE 
            WHEN recent_3m_avg <= prev_3m_avg * 0.5 THEN 'Y' 
            ELSE 'N' 
       END AS 연체위험여부
FROM LAG_COMPARE          -- 1)번 정답은 2)번 주석처리 하면 됨
WHERE loan_balance > 0    -- 대출잔액이 남아있는 계좌
  AND recent_3m_avg <= prev_3m_avg * 0.5;
--AND 구분월 = '07';        -- 2)번 필터링 
