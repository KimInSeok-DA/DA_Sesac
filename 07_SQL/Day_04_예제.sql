----고급 쿼리 ----
--MTCARS 테이블 만들기 이후 진행
SELECT count(*) FROM MTCARS;

----순위 함수
SELECT MPG AS "연비",
       COUNT(*) AS "연비별 수량",
       RANK() OVER(ORDER BY COUNT(*) DESC) AS "순위" -- 원래 같이 출력못함
FROM MTCARS
GROUP BY MPG;

---- 집계함수

SELECT NAME AS "차량 종류",
       CYL  AS "실린더",
       COUNT(*) OVER(PARTITION BY CYL) AS "해당 실린더의 수량"
FROM MTCARS
WHERE CYL <= 6;

SELECT CYL      AS "실린더",
       COUNT(*) AS "수량"
FROM MTCARS
GROUP BY CYL;

SELECT NAME,
       CYL,
       MPG,
       MAX(MPG) OVER(PARTITION BY CYL) AS "실린더별 최대 연비값"
FROM MTCARS
WHERE CYL <= 6;

--- 행 순서 함수


SELECT NAME,
       CYL,
       MPG,
       FIRST_VALUE(MPG) OVER(PARTITION BY CYL) AS "실린더별 나오는 값 중 첫번째 연비"
FROM MTCARS
WHERE CYL <= 6;

SELECT NAME,
       CYL,
       MPG,
       LAG(MPG, 2) OVER(ORDER BY MPG) AS "LAG(_, 2) 칸 앞 값"
FROM MTCARS
WHERE CYL <= 6;

SELECT NAME,
       CYL,
       MPG,
       LAG(MPG, 2) OVER(PARTITION BY CYL ORDER BY MPG) AS "LAG(_, 2) 칸 앞 값"
FROM MTCARS
WHERE CYL <= 6;

SELECT NAME,
       CYL,
       MPG,
       LEAD(MPG, 2) OVER(ORDER BY MPG) AS "LEAD(_, 2) 칸 뒤 값"
FROM MTCARS
WHERE CYL <= 6;

---- 비율 함수

SELECT NAME,
       CYL,
       MPG,
       CUME_DIST() OVER(ORDER BY MPG) AS C_DIST,
       PERCENT_RANK() OVER(ORDER BY MPG) AS P_RANK,
       NTILE(5) OVER(ORDER BY MPG) AS N_TILE,
       RATIO_TO_REPORT(MPG) OVER(PARTITION BY CYL) AS R_REPORT
FROM MTCARS
WHERE CYL <= 6;


--------오후

---피벗 

SELECT *
FROM (SELECT E.JOB, D.DNAME
      FROM EMP E, DEPT D
      WHERE E.DEPTNO = D.DEPTNO);

SELECT *
FROM (SELECT E.JOB, D.DNAME
      FROM EMP E, DEPT D
      WHERE E.DEPTNO = D.DEPTNO)
PIVOT (COUNT(*) FOR DNAME IN ('ACCOUNTING' AS ACCOUNTING
                            , 'RESEARCH' AS RESEARCH
                            , 'SALES' AS SALES));


--CREATE TABLE 평균기온
--(
--    계절      VARCHAR2(10),
--    Y2018   NUMBER,
--    Y2019   NUMBER,
--    Y2020   NUMBER,
--    Y2021   NUMBER,
--    Y2022   NUMBER
--);

--INSERT INTO 평균기온 VALUES('봄', 12.9, 12.5, 12, 12.8, 13.2);
--INSERT INTO 평균기온 VALUES('여름', 25.3, 23.9, 24, 24.2, 24.5);
--INSERT INTO 평균기온 VALUES('가을', 13.5, 15.2, 14, 14.9, 14.8);
--INSERT INTO 평균기온 VALUES('겨울', 1, 2.8, 1, 0.3, 0.2);

---UNPIVOT

SELECT * FROM 평균기온;

SELECT 계절, 연도, 기온
FROM (SELECT * FROM 평균기온)
UNPIVOT (기온 FOR 연도 IN (Y2018 AS '2018년'
                       , Y2019 AS '2019년'
                       , Y2020 AS '2020년'
                       , Y2021 AS '2021년'
                       , Y2022 AS '2022년'));
                              
---정규표현식 함수

--CREATE TABLE TBL2 (
--    TEXT VARCHAR(100)
--);

--INSERT INTO TBL2 VALUES('1234567');
--INSERT INTO TBL2 VALUES('ABCDEFG');
--INSERT INTO TBL2 VALUES('ABCD123');
--INSERT INTO TBL2 VALUES('abc123!');
--INSERT INTO TBL2 VALUES('A!@#$%^9');

SELECT COUNT(*)
FROM TBL2
WHERE REGEXP_LIKE(TEXT, '^[A-Z].*[0-9]$');



