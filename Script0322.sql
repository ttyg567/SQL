
/*
 * CREATE
 */

CREATE TABLE dept_temp
	AS (SELECT * FROM dept) ;

SELECT * FROM DEPT_TEMP;

/* 
 * INSERT INTO 데이블명 (컬럼명1, 컬럼명2, ...)
 *  VALUES (데이터1, 데이터2, ...)
 */
INSERT INTO dept_temp (deptno, dname, loc)
 VALUES (50, 'DATABASE', 'SEOUL')
;

INSERT INTO dept_temp (deptno, dname, loc)
 VALUES(50, 'WEB', NULL)
;

INSERT INTO dept_temp (deptno, dname, loc)
 VALUES(60, 'MOBILE', '')
;

INSERT INTO dept_temp (deptno, dname, loc)
 VALUES(70, 'WEB', null)
 ;


INSERT INTO dept_temp (deptno, dname, loc)
 VALUES(90, 'WEB', NULL)
;

-- 오류 발생, 세개를 입력한다고 했는데 두개만 입력되면 오류
--INSERT INTO dept_temp (deptno, dname, loc)
-- VALUES(90, 'incheon')
--;


/*
 *  컬럼값만 복사해서 새로운 테이블을 생성
 * 
 * WHERE 조건절에 1<>1
 *
 */

CREATE TABLE emp_temp AS
 	SELECT * FROM emp
 			WHERE 1<>1
 ;

SELECT * FROM emp_temp;

INSERT INTO emp_temp(empno, ename, job, mgr, hiredate, sal, comm, deptno) 
 VALUES (3333, '홍길동', 'king', NULL, TO_DATE('2001/01/01', 'YYYY/MM/DD'), 600, 500, 10)
;

INSERT INTO emp_temp(empno, ename, job, mgr, hiredate, sal, comm, deptno) 
 VALUES (2121, ' 이순신', 'manager', 9999, TO_DATE('07/01/2002', 'MM/DD/yyyy'), 600, 500, 10)
;

INSERT INTO emp_temp(empno, ename, job, mgr, hiredate, sal, comm, deptno) 
 VALUES (3111, '심청이', 'manager', 9999, SYSDATE, 300, 200, 10)
;



INSERT INTO emp_temp(empno, ename, job, mgr, hiredate, sal, comm, deptno) 
 SELECT e.empno
 	,e.ename
 	,e.job
 	,e.mgr
 	,e.hiredate
 	,e.sal
 	,e.comm
 	,e.deptno
 FROM emp e, SALGRADE s 
 WHERE e.sal BETWEEN s.LOSAL 
 				AND s.HISAL 
 				AND s.GRADE = 1
 			;


/* 
 * UPDATE 문
 * : 필터된 데이터에 대해서 레코드 값을 수정
 */

 CREATE TABLE dept_temp2
  	AS (SELECT * FROM dept)
  ;
 
 
 DROP TABLE dept_temp2;
 
 SELECT *
  FROM dept_temp2 -- 테스트 개발을 위한 임시 테이블 확인
 ;

-- UPDATE ... 
--    SET ...
UPDATE dept_temp2
 SET loc = 'SEOUL'
;

ROLLBACK;

UPDATE dept_temp2
 SET dname = 'DATABASE'
 	, loc = 'SEOUL'
 WHERE deptno = 40
;

SELECT * FROM dept_temp2;

UPDATE dept_temp2
 SET (dname, loc) = (SELECT dname, LOC
 							FROM DEPT 
 							WHERE deptno = 40)   --dept 테이블에서 가져온 값으로 변경
 WHERE deptno = 40  
;

COMMIT;

/*
 * DELETE 구문으로 테이블에서 값을 제거
 * 대부분의 경우(또는 반드시,,) WHERE절과 함께 사용
 * 보통의 경우, DELETE보다는 UPDATE 구문으로 상태 값을 변경
 */

CREATE TABLE emp_temp2
		AS (SELECT * FROM emp)
;

COMMIT;

SELECT *
 FROM emp_temp2;

DELETE FROM emp_temp2
 WHERE job = 'MANAGER'
;

DELETE FROM EMP_TEMP2 
 WHERE empno IN (SELECT empno
 					FROM emp_temp2 e, salgrade s
 					WHERE e.sal BETWEEN s.losal AND s.hisal
 						AND s.grade = 3
 						AND deptno = 30)
 ;
 
SELECT e.empno
	FROM emp_temp2 e, salgrade s
	WHERE e.sal BETWEEN s.losal AND s.hisal
 						AND s.grade = 3
 						AND deptno = 30
 ;
 


/*
 * CREATE : 기존에 없는 테이블 구조를 생성
 * 데이터는 없고, 테이블의 컬럼과 데이터타입, 제약 조건 등의 구조를 생성
 */
CREATE TABLE emp_new(
	empno		NUMBER(4),
	ename		varchar2(10),
	job			varchar2(9),
	mgr 		number(4),
	hiredate	DATE,
	sal 		number(7,2),
	comm 		number(7,2),
	deptno 		number(2)
);
	
SELECT *
 FROM EMP 
;

-- 테이블에 새로운 컬럼을 추가
ALTER TABLE emp_new
 ADD HP varchar2(20)
;

-- 기존 컬럼명을 변경
ALTER TABLE emp_new
 RENAME COLUMN HP TO TEL_NO
;

ALTER TABLE emp_new
 MODIFY empno number(5)
;

ALTER TABLE emp_new 
 DROP COLUMN tel_no
;

/*
 * SEQUENCE 생성: 일련번호 사용
 * 일련번호를 생성하여 테이블 관리를 편리하게 하고자 함
 */

-- 특정 규칙에 따라 생성되는 연속 숫자를 생성하는 객체
CREATE SEQUENCE seq_deptseq -- sequence명
		INCREMENT BY 1 -- 증가값(기본 1)
		START WITH 1 -- 시작값(기본 1)
		MAXVALUE 99 -- 최대값(nomaxvalue)
		MINVALUE 1 -- 최소값(nominvalue)
		NOCYCLE NOCACHE; -- nocycle 최대값에서 중단 / nocache 값 미리 생성(기본 20)

SELECT * FROM dept_temp2;

INSERT INTO dept_temp2 (deptno, dname, loc)
 VALUES (seq_deptseq.nextval, 'DATABASE', 'SEOUL')
;

INSERT INTO dept_temp2 (deptno, dname, loc)
 VALUES (seq_deptseq.nextval, 'WEB', 'BUSAN')
;

INSERT INTO dept_temp2 (deptno, dname, loc)
 VALUES (seq_deptseq.nextval, 'MOBILE', 'SUNGSU')
;


-- NOT NULL (NULL값을 허용하지 않는 컬럼)을 지정
CREATE TABLE login(
			 login_id 		VARCHAR(20) NOT NULL
			,login_pwd 		VARCHAR(20) NOT NULL
			,tel 			VARCHAR2(20)
);


--  오류: login pwd 에는 null 입력 불가
INSERT INTO login (login_id, login_pwd, tel)
 VALUES ('TEST_ID_01', NULL, '010-1234-5678')
 ;
 

INSERT INTO login (login_id, login_pwd)
 VALUES ('TEST_ID_01', '1234')
 ;

SELECT * FROM login;

-- tel 값이 null 인 경우가 존재하여 제약 조건 설정 불가
ALTER TABLE login 
 MODIFY(tel NOT null);

-- tel 값을 먼저 바꿔줌
UPDATE login
 SET tel = '010-1234-5678'
 WHERE login_id = 'TEST_ID_01'
;

ALTER TABLE login 
 MODIFY(tel NOT null);

SELECT * FROM login;

COMMIT;

/*
 * 오라클 DBMS가 사용자를 위해 만들어 놓은 제약조건 설정값 테이블
 */
SELECT owner
	, CONSTRAINT_NAME
	, CONSTRAINT_TYPE
	, table_name
 FROM USER_CONSTRAINTS;

 WHERE table_name = 'LOGIN'
;


ALTER TABLE login
 MODIFY (tel CONSTRAINT tel_nn NOT NULL)
;


/*
 * UNIQUE 키워드 사용
 */
 CREATE TABLE log_unique
(
    log_id      varchar2(20) UNIQUE
    ,log_pwd    varchar2(20) NOT NULL
    ,tel        varchar2(20)
 );

SELECT OWNER
,CONSTRAINT_NAME
,CONSTRAINT_TYPE
,TABLE_NAME
 FROM USER_CONSTRAINTS
 WHERE TABLE_NAME = 'LOG_UNIQUE';


-- 전화번호에 unique 제약 조건 부여
ALTER TABLE log_unique
 MODIFY (tel unique)
;

SELECT * FROM log_unique;
 

/*
 * PK (주키, Primary Key) 
 * NOT NULL + UNIQUE + INDEX
 * 
 */

CREATE TABLE log_pk
(
	  log_id 		VARCHAR2(20) PRIMARY Key
	, log_pwd		VARCHAR2(20) NOT NULL 
	, tel  			VARCHAR2(20)
);

INSERT INTO log_pk(log_id, log_pwd, tel)
 VALUES ('pk01', 'pw01', '010-1234-5678')
;
-- 만약 id를 pk01로 해서 추가하면 안들어감
INSERT INTO log_pk(log_id, log_pwd, tel)
 VALUES ('pk01', 'pw221', '010-1566-4678')
;

-- null 값 안됨
INSERT INTO log_pk(log_id, log_pwd, tel)
 VALUES (NULL, 'pw02', '010-3333-5678')
;


/*
 * 존재하지 않는 부서번호를 emp_temp 테이블에 입력 시도
 */
INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
 VALUES(9999, 'FK_TEST_USER', 'CLERK', '7788', TO_DATE('2017/04/30', 'yyyy/mm/dd'), 1200, NULL, 50)
;

SELECT * 
FROM emp_temp2;


/*
 * INDEX 빠른 검색을 위한 색인
 * 
 * 장점: 순식간에 원하는 값을 찾아준다
 * 단점: 입력과 출력이 잦은 경우, 인덱스가 설정된 테이블의 속도가 저하된다
 * 
 */

-- 특정 직군에 해당하는 직원을 빠르게 찾기 위한 색인 지정
CREATE INDEX idx_emp_job
 ON emp(job)
 ;

SELECT *
 FROM user_indexes 
 WHERE table_name IN ('EMP', 'dept')
;

/* 
 * view
 */
CREATE VIEW vw_emp10
 AS (SELECT EMPNO, ENAME, JOB, DEPTNO 
  FROM EMP WHERE DEPTNO = 10);
 


SELECT rownum, E.*
	FROM emp e
	ORDER BY sal DESC;

-- 인라인-뷰 (SQL 문에서 일회성으로 사용하는 뷰)
SELECT rownum, e.*
 FROM (SELECT *
 		FROM emp e
 		ORDER BY sal desc) e; -- 인라인 뷰에 E 별칭
 		
 		
 -- WITH 절을 사용하는 인라인뷰
 WITH e AS (SELECT * FROM emp ORDER BY sal desc)
  SELECT rownum, e.*
  FROM e
 ;

SELECT rownum, e.*
 FROM (SELECT *
  			FROM emp e
  			ORDER BY sal desc) e
WHERE rownum <= 5
;

/*
 * 오라클 DBMS 에서 관리하는 관리 테이블 리스트 출력
 */
SELECT *
FROM dict
WHERE table_name like 'USER_%'
;  

SELECT *
 FROM DBA_TABLES;

SELECT *
 FROM DBA_USERS 
 WHERE username = 'SCOTT'
 ;



















