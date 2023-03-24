SELECT *
FROM v$database
;

SELECT *
 FROM v$session
;

SELECT *
 FROM v$parameter
;

/* 
 * 트랜잭션: 최소 업무(최소 sql 실행) 단위
 */


CREATE TABLE dept_tcl
 AS SELECT * FROM dept;

SELECT *
 FROM dept_tcl;


INSERT INTO dept_tcl
 VALUEs(50, 'DATABASE', 'SEOUL')
;

UPDATE dept_tcl
 SET loc = 'BUSAN'
 WHERE deptno = 40
;

DELETE FROM dept_tcl
 WHERE dname = 'RESEARCH'
;

SELECT *
 FROM dept_tcl
;

ROLLBACK; -- CREATE 실행했을 때로 돌아감


INSERT INTO dept_tcl 
 values(50, 'NETWORK', 'SEOUL')
;

UPDATE dept_tcl 
 SET loc = 'BUSAN' 
 WHERE deptno = 20
;

DELETE FROM dept_tcl 
 WHERE deptno= 40
;

SELECT *
FROM dept_tcl;

COMMIT;

SELECT * 
 FROM dept_tcl;

DELETE 
 FROM dept_tcl
 WHERE deptno = 50;

SELECT *
 FROM dept_tcl;

COMMIT;


/*
 * LOCK 테스트
 * 
 * 동일한 계정으로  
 * DBEAVER 세션과 SQLPLUS 세션을 열어 데이터를 수정하는 동시 작업을 수행
 */
-- sql*plus 에서는 update 내용이 안보임
-- 동시에 일어나면서 다른 직원이 처리하는 것에 방해될 수 있음,,
UPDATE DEPT_TCL 
 SET loc = 'DAEGU'
 WHERE deptno = 30
;

SELECT *
 FROM dept_tcl;

COMMIT; -- COMMIT 해야 SQL*plus 에서도 조회 가능


/* 
 * Tuning 기초
 * DB 처리 속도(우선)와 안정성 재고 목적의 경우가 대부분
 */

-- 튜닝 전 후 비교1
SELECT *
 FROM emp
 WHERE substr(empno, 1, 2) = 75   -- 암묵적 형변환이 2번이나 일어남, 
  AND LENGTH (empno) = 4
  ;
 
 SELECT *
  FROM emp
  WHERE empno > 7499 AND empno < 7600
;

-- 비교2

SELECT * 
 FROM emp
 WHERE ename || ' ' || job = 'WARD SALESMAN'
;

SELECT *
 FROM emp
 WHERE ename = 'WARD'
 	AND job ='SALESMAN'
;

-- 비교 3

SELECT DISTINCT e.empno, e.ename, m.deptno
 FROM EMP e 
 JOIN dept m ON (e.deptno = m.deptno)
;

SELECT e.empno, e.ename, m.deptno  --DISTINCT 제거(중복 제거 및 정렬 비용 발생)
 FROM EMP e 
 JOIN dept m ON (e.deptno = m.deptno)
;


-- 비교 4
SELECT *
 FROM emp
 WHERE deptno = 10
 UNION 
SELECT *
 FROM emp
 WHERE deptno = 20
;

SELECT *
 FROM emp
 WHERE deptno = 10
 UNION ALL 	-- UNION 은 불필요하게 중복제거비용 발생, 불필요하게 암묵적 형변환이 일어남  
SELECT *
 FROM emp
 WHERE deptno = 20
;

-- 비교 5
SELECT ename, empno, sum(sal)
 FROM emp
 GROUP BY ename, empno 
;

SELECT empno, ename, sum(sal)   -- 인덱스로 지정된 컬럼을 앞에 써줘야 조회되는 속도가 좀 더 빨라짐(근소한 차이이나..)
 FROM EMP 
 GROUP BY empno, ename
;

-- 비교 6
SELECT empno, ename
 FROM EMP 
 WHERE to_char(hiredate, 'YYYYMMDD') LIKE '1981%'  -- 동일한 데이터 타입 - String
 	AND empno > 7700
 ;

SELECT empno, ename
 FROM EMP 
 WHERE EXTRACT (YEAR FROM hiredate) = 1981   -- 동일한 데이터타입 -integer
 	AND empno > 7700
 ;



-- index 확인 및 추가
SELECT job, sum(sal)
 FROM EMP 
 GROUP BY job -- 집계 함수 필요
;


SELECT *
 FROM user_indexes
 WHERE table_name LIKE 'EMP'
;

Drop INDEX idx_emp_job;

SELECT job, sum(sal) AS sum_of_sal
 FROM emp
 GROUP BY job
 GROUP BY sum_of_sal DESC
 ;




-- group by

SELECT deptno, floor(avg(sal)) AS avg_sal
 FROM emp
 GROUP BY DEPTNO ;

SELECT deptno
	, job
	, floor( avg(sal)) AS avg_sal
	, max(sal) AS max_sal
	, min(sal) AS min_sal
 FROM emp
 GROUP BY
 job, DEPTNO HAVING max(sal) >=2000
 ORDER BY job, deptno;


SELECT deptno
	, listAGG(ename, ',')
	 	WITHIN group(ORDER BY sal DESC) AS ename_listag
 FROM emp
 GROUP BY DEPTNO 
 ;


SELECT deptno, job, max(sal)
 FROM emp
 GROUP BY deptno, job
 ORDER BY deptno, job
;

SELECT *
 FROM (SELECT deptno, job, sal FROM emp)
 pivot(max(sal) FOR deptno IN (10, 20, 30))
 ORDER BY job
 ;

SELECT deptno
 	, max(decode (job, 'CLERK', sal)) AS "clerk"
	, max(decode (job, 'SALESMAN', sal)) AS "sales"
	, max(decode (job, 'PRESIDENT', sal)) AS "presi"
	, max(decode (job, 'MANAGER', sal)) AS "mgr"
	, max(decode (job, 'ANALYST', sal)) AS "ana"
 FROM emp
 GROUP BY deptno
 ORDER BY deptno
;



SELECT *
 FROM (SELECT deptno,
			, max(decode (job, 'CLERK', sal)) AS "CLERK"
			, max(decode (job, 'SALESMAN', sal)) AS "SALES"
			, max(decode (job, 'PRESIDENT', sal)) AS "PRESI"
			, max(decode (job, 'MANAGER', sal)) AS "MGR"
			, max(decode (job, 'ANALYST', sal)) AS "ANA"
		 FROM emp
		 GROUP BY deptno
		 ORDER BY deptno)
unpivot(sal FOR job IN (CLERK, SALES, PRESI, MGR, ANA))
ORDER BY deptno, job
;


SELECT deptno
	, job
	, count(*)
	, max(sal)
	, sum(sal)
	, avg(sal)
 FROM emp
 GROUP BY rollup(deptno, job);

-- cube
SELECT deptno
		, job
		, count(*)
		, max(sal)
		, sum(sal)
		, avg(sal)
	FROM emp
	GROUP BY cube(deptno, job)
	ORDER BY deptno, job;


 
















