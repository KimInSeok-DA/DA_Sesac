-- 오전
-- 예제 실행

SELECT * FROM ACCOUNT;

SELECT A.account_ID 계좌번호, D.A2 영업점소재지
FROM Account A, District D;

SELECT t.account_id  AS 계좌번호
     , T.trans_id    AS 거래번호
     , A.district_id AS "계좌개설 장소코드"
     , T.TYPE        AS 거래유형
FROM account A, Trans T
WHERE A.account_id = t.account_id;

--- 고객번호, 고객 생일번호, 계좌유형, 계좌번호, 주소지구역 ID를 출력
SELECT C.CLIENT_ID       고객번호
     , C.BIRTH_NUMBER    고객생일
     , D.TYPE            계좌유형  
     , A.ACCOUNT_ID      계좌번호
     , E.A2              주소지구역
FROM   DISP D, ACCOUNT A, CLIENT C, DISTRICT E
WHERE  D.ACCOUNT_ID = A.ACCOUNT_ID
AND    D.CLIENT_ID = C.CLIENT_ID
AND    C.DISTRICT_ID = E.DISTRICT_ID;

---INNER JOIN
SELECT C.CLIENT_ID, C.BIRTH_NUMBER, D.TYPE DISP_TYPE, A.ACCOUNT_ID, E.A2 DISTRICT_NAME
FROM   DISP D, ACCOUNT A, CLIENT C, DISTRICT E ---
WHERE  D.ACCOUNT_ID = A.ACCOUNT_ID 
AND    D.CLIENT_ID = C.CLIENT_ID
AND    C.DISTRICT_ID = E.DISTRICT_ID;---

SELECT C.CLIENT_ID, C.BIRTH_NUMBER, D.TYPE DISP_TYPE, A.ACCOUNT_ID, E.A2 DISTRICT_NAME
FROM   DISP D ---
INNER JOIN ACCOUNT A  ON D.ACCOUNT_ID = A.ACCOUNT_ID
INNER JOIN CLIENT C   ON D.CLIENT_ID = C.CLIENT_ID
INNER JOIN DISTRICT E ON C.DISTRICT_ID = E.DISTRICT_ID; ---


--- 오후 ---

-- 직접 실습  --

-- 표준 조인 진도 후
-- 조인으로 아무거나 해보기
--- account 테이블과 district 테이블 조인

SELECT E.A2 영업점소재지, A.Account_ID 계좌번호
FROM Account A LEFT OUTER JOIN District E
ON A.District_id = E. District_id
WHERE E.A2 = 'Tabor';

SELECT E.A2 영업점소재지, A.Account_ID 계좌번호 
FROM Account A RIGHT OUTER JOIN District E
ON A.District_id = E. District_id
WHERE E.A2 = 'Tabor';

SELECT E.A2 영업점소재지, A.Account_ID 계좌번호 
FROM Account A FULL OUTER JOIN District E
ON A.District_id = E. District_id


--서브쿼리 진도 후 직접 실습 ---

-- LOAN 테이블과 ACCOUNT 테이블을 조인한 후, DISTRICT 테이블과 조인하여
-- 각 지역(REGION)별, 

-- 1단계 실습 --
-- LOAN, ACCOUNT, DISTRICT 테이블과 조인하여
-- DISTRICT_ID, 
-- DISTRICT_NAME(DISTRICT의 A2칼럼 AS 지정), 
-- REIGION_NAME(DISTRICT의 A3칼럼 AS 지정), 
-- AMOUNT 칼럼 출력

-- 내 풀이-- 
SELECT 
    d.district_id AS DISTRICT_ID
  , d.A2 AS DISTRICT_NAME
  , d.A3 AS REGION_NAME
  , l.AMOUNT
FROM LOAN l
LEFT OUTER JOIN ACCOUNT a ON l.account_id = a.account_id
LEFT OUTER JOIN DISTRICT d ON a.district_id = d.district_id
ORDER BY 
    l.AMOUNT ASC;

-- 강사님 풀이 --
SELECT D.DISTRICT_ID
     , D.A2
     , D.A3
     , l.AMOUNT
FROM LOAN l Inner JOIN ACCOUNT a ON l.account_id = a.account_id
            Inner JOIN DISTRICT d ON a.DISTRICT_ID = d.DISTRICT_ID

-- 2단계 --
-- 1단계 쿼리 결과를 서브쿼리로 작성하여 From 절에 넣고,
-- 각 지역별(REGION_NAME), 대출금(AMOUNT) 총액, 평균, 최댓값, 최소값을 계산하여 출력

            
-- 내 풀이 --
            
SELECT 
    sub.REGION_NAME
  , SUM(sub.AMOUNT) AS "SUM_AMOUNT"    -- 지역별 대출금 총액
  , AVG(sub.AMOUNT) AS AVG_AMOUNT      -- 지역별 대출금 평균
  , MAX(sub.AMOUNT) AS MAX_AMOUNT      -- 지역별 대출금 최댓값
  , MIN(sub.AMOUNT) AS MIN_AMOUNT      -- 지역별 대출금 최솟값
FROM (
    -- [1단계 쿼리] 서브쿼리(인라인 뷰)로 들어간 부분
    SELECT 
        d.district_id AS DISTRICT_ID
      , d.A2 AS DISTRICT_NAME
      , d.A3 AS REGION_NAME
      , l.AMOUNT AS AMOUNT
    FROM LOAN l
    LEFT OUTER JOIN ACCOUNT a ON l.account_id = a.account_id
    LEFT OUTER JOIN DISTRICT d ON a.district_id = d.district_id
) sub                                 -- 서브쿼리 AS 지정
GROUP BY 
    sub.REGION_NAME                   -- 지역명 기준 그룹화
ORDER BY 
    SUM_AMOUNT ASC;         
    
-- 강사님 풀이
 
SELECT 
    B.REGION_NAME AS "지역명"
  , SUM(B.AMOUNT) AS "지역별 대출금 총액"    -- 지역별 대출금 총액
  , AVG(B.AMOUNT) AS "지역별 대출금 평균"    -- 지역별 대출금 평균
  , MAX(B.AMOUNT) AS "지역별 최고 대출금"    -- 지역별 대출금 최댓값
  , MIN(B.AMOUNT) AS "지역별 최저 대출금"    -- 지역별 대출금 최솟값
FROM (
    SELECT D.DISTRICT_ID
         , D.A2 AS DISTRICT_NAME
         , D.A3 AS REGION_NAME
         , l.AMOUNT
FROM LOAN l Inner JOIN ACCOUNT a ON l.account_id = a.account_id
            Inner JOIN DISTRICT d ON a.DISTRICT_ID = d.DISTRICT_ID) B
GROUP BY 
    B.REGION_NAME    
