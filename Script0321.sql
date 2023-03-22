/*
 * 레코드 그룹별 집계: GROUP BY
 * 
 * 집계 조건: HAVING
 * 
 * */


SELECT SUM(sal)
 FROM EMP;

SELECT SUM(E.sal)
	, AVG(E.sal)
 FROM EMP E
;

SELECT DISTINCT deptno   -- DISTINCT 키워드 (unique)
 FROM emp
;

SELECT DISTINCT E.deptno
	, E.sal -- DISTINCT는 SAL에도 적용된다
 FROM EMP E;
-- 두개의 값이 UNIQUE 한 값으로 구분해서 나온다(튜플)

 SELECT SUM(DISTINCT e.saL) AS sum_of_distinct
 	, SUM(ALL e.sal) AS sum_of_all
 	, SUM(e.sal) AS normal_sum 
 FROM emp e;

SELECT MAX(sal)
 FROM EMP e 
 	WHERE deptno = 30
;

SELECT MIN(sal)
 FROM EMP e 
 	WHERE deptno = 30
;

SELECT MAX(sal)
	, MIN(SAL)
	, ROUND(MAX(sal)/MIN(sal), 1)
 FROM EMP e 
 	WHERE deptno = 20
;




/* 
 *  COUNT 집계 함수
 */

SELECT count(empno)
	, count(comm)
 FROM EMP e
;


SELECT COUNT(*)
 FROM EMP e 
 WHERE deptno = 30;

SELECT COUNT(DISTINCT sal)
	, COUNT(ALL sal)
	, COUNT(sal)
 FROM EMP e 
 ;

SELECT COUNT(ename)
 FROM EMP e 
 WHERE comm IS NOT NULL
 ;

SELECT COUNT(ename)
 FROM EMP e 
 WHERE NVL(comm, 0) > 0
 ;


SELECT AVG(sal)
	, '10' AS deptno 
	FROM emp 
	WHERE deptno = 10
UNION ALL 
SELECT AVG(sal)
	, '20' AS deptno 
	FROM emp 
	WHERE deptno = 20
UNION ALL 
SELECT AVG(sal)
	, '30' AS deptno 
	FROM emp 
	WHERE deptno = 30
;

-- 위의 경우 GROUP BY로 집계
SELECT deptno, job
	, AVG(sal)
	, MIN(sal)
	, MAX(sal)
 FROM EMP e 
 GROUP BY deptno, job
 ORDER BY deptno, job
 ;

SELECT deptno, job
	, AVG(sal + NVL(comm, 0)) AS avg_pay
	, MIN(sal + NVL(comm, 0)) AS min_pay
	, MAX(sal + NVL(comm, 0)) AS max_pay
 FROM EMP e 
 GROUP BY deptno, job
 ORDER BY deptno, job
 ;


/*
 * 테이블 정규화로 분할된 테이블 컬럼을 다시 합치는 작업
 * 
 * join
 * 
 */

SELECT *
	FROM emp, dept  -- 잘못된 JOIN 사용 : cartesian product
	ORDER BY empno
;                

SELECT *
 	FROM emp E, dept D -- 잘못된 JOIN 사용
 	WHERE E.ename = 'MILLER'
 	ORDER BY E.empno
;

/*
 * INNER JOIN 교집합 컬럼 연결
 */
SELECT *
 FROM emp, dept
 WHERE emp.deptno = dept.deptno
 ORDER BY empno
;

-- JOIN ~ ON 으로 등가 조인(inner join)
SELECT *
 FROM emp E JOIN dept D 		
			ON (E.deptno = D.deptno)
 ORDER BY empno;

SELECT e.empno
	, e.hiredate
	, d.dname
	, e.job
	, e.sal
 FROM emp e JOIN dept d
	ON e.deptno = d.deptno  -- ON 키워드 뒤에 값 비교
;

SELECT e.empno
	, e.hiredate
	, d.dname
	, e.job
	, e.sal
 FROM emp e JOIN dept d
		USING (deptno)  -- USING 키워드 하나로 동일 칼럼
;


/*
 * 자바, C/C++ 등 프로그램에서 SQL 쿼리문을 사용하는 경우
 * 쿼리문을 문자열로 사용 가능 
 */

var_deptno ; -- 사용자로부터 입력 받은 부서 번호

var_sql = "SELECT e.empno
	, e.hiredate
	, d.dname
	, e.job
	, e.sal
 FROM emp e JOIN dept d
		USING (deptno)
"


SELECT e.empno
	, TO_CHAR(e.hiredate, 'YYYY/MM/DD') AS hire_ymd
	, e.ename
	, d.deptno
	, d.dname
	, d.loc
 FROM emp e, dept d
 WHERE e.deptno = d.deptno
 ORDER BY d.deptno, e.empno
;


SELECT e.empno
	, TO_CHAR(e.hiredate, 'YYYY/MM/DD') AS hire_ymd
	, e.ename
	, d.deptno
	, d.dname
	, d.loc
	, e.sal
 FROM emp e, dept d
 WHERE e.deptno = d.deptno AND e.sal < 2000
 ORDER BY d.deptno, e.empno
;


SELECT d.dname AS dname
	, ROUND(AVG(e.sal), 0) AS avg_sal
	, SUM(e.sal) AS sum_sal
	, MAX(e.sal) AS max_sal
	, MIN(e.sal) AS min_sal
 FROM emp e
 	, dept d
 WHERE e.deptno = d.deptno AND e.sal < 2000
 GROUP BY d.dname
;

SELECT e.ename
	, e.sal
	, e.job
 FROM emp e, salgrade s
 WHERE e.sal BETWEEN s.losal AND s.hisal
 ;

/*
 *  JOIN 함수로 SALGRADE  부여 후 grade로 그룹별 직원 수
 */
SELECT s.grade
	, count(e.ename) AS emp_cnt  -- 임직원 수 집계
 FROM emp e, salgrade s
 WHERE e.sal BETWEEN s.losal AND s.hisal
 GROUP BY s.grade  -- grade 기준으로 그룹
 ORDER BY emp_cnt DESC -- 임직원 수가 많은 수 부터 정렬
 ;



/*
 * Self-JOIN 자기 자신의 릴레이션을 이용해서 테이블 컬럼을 조작
 */

SELECT e1.empno AS EMP_NO
	, e1.ename AS EMP_NAME
	, e2.mgr AS MGR_NO
	, e2.ename AS MGR_NAME
 FROM emp e1, emp e2  -- SELF-JOIN 목적으로 테이블 사용
 WHERE e1.empno = e2.mgr

 
SELECT e1.empno
	, e1.ename
	, e1.mgr
	, e2.empno AS mgr_empno
	, e2.ename AS mgr_ename
 FROM emp e1, emp e2
 WHERE e1.mgr = e2.empno(+)
 ORDER BY e1.empno
;

/*
 * LEFT JOIN 왼쪽 테이블 값을 모두 가져오고 
 * JOIN을 하는 테이블에서 해당 되는 값 일부만 가져오기
 */

SELECT e1.empno
	, e1.ename
	, e1.mgr
	, e2.empno AS mgr_empno
	, e2.ename AS mgr_ename
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno(+)
ORDER BY e1.empno
;

-- left join 표준 SQL을 활용하여 매니저와 담당 직원 정보를 출력
SELECT  e1.empno
	, e1.ename
	, e1.mgr
	, e2.empno AS mgr_no
	, e2.ename AS mgr_name
 FROM emp e1 LEFT OUTER JOIN emp e2
 			ON e1.mgr = e2.empno
;

-- right join (oracle)
SELECT e1.empno
	, e1.ename
	, e1.mgr
	, e2.empno
	, e2.ename
 FROM emp e1, emp e2
 WHERE e1.mgr(+) = e2.empno 
 ORDER BY e1.empno;

-- right join (표준 SQL)
SELECT e1.empno
	, e1.ename
	, e1.mgr
	, e2.empno AS mgr_empno
	, e2.ename AS mgr_ename
 FROM emp e1 RIGHT OUTER JOIN emp e2
 		ON (e1.mgr = e2.empno)
 ORDER BY e1.empno, mgr_empno
;

/*
 * 양측 조인 FULL-OUTER-JOIN
 */

SELECT e1.empno
	, e1.ename
	, e1.mgr
	, e2.empno AS mgr_empno
	, e2.ename AS mgr_ename
 FROM emp e1 FULL OUTER JOIN emp e2
 		ON (e1.mgr = e2.empno)
  ORDER BY e1.empno
 ;

SELECT d.deptno
	, d.dname
	, e.empno
	, e.ename
	, e.mgr
	, e.sal
	, e.deptno
	, s.losal
	, s.hisal
	, s.grade
	, e2.empno AS mgr_empno
	, e2.ename AS mgr_ename
 FROM emp e, dept d, salgrade s, emp e2
 WHERE e.deptno(+) = d.deptno
 AND e.sal BETWEEN s.losal(+) AND s.hisal(+)
 AND e.mgr = e2.empno(+)
 ORDER BY d.deptno, e.empno
;

SELECT d.deptno
	, d.dname
	, e.empno
	, e.ename
	, e.mgr
	, e.sal
	, e.deptno
	, s.losal
	, s.hisal
	, s.grade
	, e2.empno AS mgr_empno
	, e2.ename AS mgr_ename
FROM emp e RIGHT JOIN dept d ON (e.deptno = d.deptno)
LEFT OUTER JOIN SALGRADE s ON (e.sal >= s.losal AND e.sal <= s.hisal)
LEFT OUTER JOIN emp e2 ON (e.mgr = e2.empno)
ORDER BY d.deptno, e.empno
;

/*
 * EMP, DEPT, SALGRADE, selg-join EMP
 * 2씩 연관 테이블의 일부를 오라클 SQL로 값을 출력
 */
SELECT d.deptno
	, d.dname
	, e1.empno
	, e1.ename
	, e1.mgr
	, e1.sal
	, e1.deptno
	, s.losal
	, s.hisal
	, s.grade
	, e2.empno AS mgr_empno
	, e2.ename AS mgr_ename
 FROM emp e1
	, dept d
	, salgrade s
	, emp e2
WHERE e1.deptno(+) = d.deptno
	AND e1.sal BETWEEN s.losal (+) AND s.hisal (+)
	AND e1.mgr = e2.empno
;


SELECT e1.empno
	, e1.ename
	, e1.mgr
	, e1.sal
	, s.losal
	, s.hisal
	, s.grade
 FROM emp e1, salgrade s
 WHERE e1.sal BETWEEN s.losal AND s.hisal
;

SELECT e1.empno
	, e1.ename
	, e1.mgr
	, e1.sal
	, e1.deptno
	, e2.empno AS mgr_empno
	, e2.ename AS mgr_ename
 FROM emp e1
	, emp e2
WHERE e1.mgr = e2.empno(+)
;

/*
 * 표준 SQL 출력
 * 
 * EMP e1, DEPT d, SALGRADE s, EMP e2
 * 
 */

SELECT  d.deptno
	, d.dname
	, e1.empno
	, e1.ename
	, e1.mgr
	, e1.sal
	, e1.deptno
	, s.losal
	, s.hisal
	, s.grade
	, e2.empno AS mgr_empno
	, e2.ename AS mgr_ename
 FROM emp e1 RIGHT JOIN dept d
 		ON e1.deptno = d.deptno
 	LEFT OUTER JOIN salgrade s
 	 ON (e1.sal >= s.losal AND e1.sal <= s.hisal)
	LEFT OUTER JOIN emp e2
	 ON (e1.mgr = e2.empno)
;


/*
 * 서브쿼리(sub-query)
 * : 쿼리 안에 쿼리를 넣음
 */
SELECT sal
	FROM emp e
	WHERE e.ename = 'SMITH';


SELECT e.empno
	, e.ename
	, e.job
	, e.sal
	, d.deptno
	, d.dname
	, d.loc	
 FROM emp e, dept d
 WHERE e.deptno = 20
 	AND e.sal > (SELECT AVG(sal) FROM EMP)
 ;

/* 
 * 다중행 서브 쿼리 - 커리 안에 쿼리 문장 사용
 * select 쿼리의 결과는 2개 이상의 값으로 된 테이블
 */

-- 부서별 최고 급여에 해당하는 직원을 조회하여 출력
SELECT deptno, ename, sal
 FROM emp
 WHERE SAL IN (SELECT MAX(sal) 
 					FROM EMP 
 					GROUP BY deptno)
;

SELECT deptno, MAX(sal)
 FROM emp
 GROUP BY deptno
 ORDER BY deptno
;

SELECT *
 FROM emp
 WHERE sal = ANY (SELECT SAL
 						FROM EMP e
 						WHERE DEPTNO = 30)
 ORDER BY sal, empno
;
 
SELECT MIN(sal), MAX(sal)
 FROM EMP e 
 WHERE sal = ANY (SELECT SAL
 						FROM EMP e
 						WHERE DEPTNO = 30)
;

SELECT *
FROM EMP e 
WHERE sal < ANY (SELECT SAL
 						FROM EMP e
 						WHERE DEPTNO = 30)
;


/*
 * 다중열 서브 쿼리
 * 
 * 서브 쿼리 결과가 두 개 이상의 컬럼으로 구성된 테이블 값
 */

SELECT *
 FROM emp
 WHERE (deptno, sal) IN (SELECT deptno, MAX(sal)
 						  FROM EMP e
 						  GROUP BY deptno)
; 


/*
 * FROM 절에 사용되는 서브 쿼리
 */

SELECT A.empno
	, A.sal
	, B.dname
 FROM (SELECT * FROM emp WHERE deptno = 30) A
 	, (SELECT * FROM dept) B
 WHERE A.deptno = B.deptno
 ;

/* 
 * WITH 절 : 편리한 가상 테이블로 활용
 */

WITH E AS (SELECT * FROM emp WHERE deptno = 20)
	, D AS (SELECT * FROM dept)
	, S AS (SELECT * FROM salgrade)
SELECT  E.ename
	, D.dname
	, E.sal
	, D.loc
	, S.grade
 FROM E, D, S
 WHERE E.deptno = D.deptno
 	AND E.sal BETWEEN S.losal AND S.hisal
 ;


/* 
 * CREATE TABLE
 */

CREATE TABLE dept_temp
 AS SELECT * FROM dept;  --기존 dept 테이블을 복사하여 새로운 테이블 만들기

SELECT *
 FROM dept_temp;

-- COMMIT;
































