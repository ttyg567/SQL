Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
REM    UTLSAMPL.SQL
Rem  FUNCTION
Rem  NOTES    
Rem  MODIFIED
Rem	gdudey	   06/28/95 -  Modified for desktop seed database
Rem	glumpkin   10/21/92 -  Renamed from SQLBLD.SQL
Rem	blinden   07/27/92 -  Added primary and foreign keys to EMP and DEPT
Rem	rlim	   04/29/91 -	      change char to varchar2
Rem	mmoore	   04/08/91 -	      use unlimited tablespace priv
Rem	pritto	   04/04/91 -	      change SYSDATE to 13-JUL-87
REM MENDELS 12/07/90 - BUG 30123;
REM ADD TO_DATE CALLS SO LANGUAGE INDEPENDENT

Rem
Rem $Header: utlsampl.sql 7020100.1 94/09/23 22:14:24 cli Generic<base> $ sqlbld.sql
Rem
SET TERMOUT OFF
SET ECHO OFF

Rem CONGDON    Invoked in RDBMS at build time.	 29-DEC-1988
Rem OATES:     Created: 16-Feb-83

/*
 * SCOTT 계정 생성 및 암호 TIGER 지정
 */

GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO test;
--SCOTT IDENTIFIED BY TIGER;

ALTER USER SCOTT DEFAULT TABLESPACE USERS;

ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;

ALTER USER test ACCOUNT UNLOCK;

--GRANT unlimited tablespace TO test;
--CONNECT SCOTT/TIGER


DROP TABLE DEPT;

CREATE TABLE DEPT (
	DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
	DNAME VARCHAR2(14),
	LOC VARCHAR2(13)
);

SELECT * 
FROM DEPT;

/*
 * 데이터 입력
 */

INSERT INTO DEPT VALUES (
	10,
	'ACCOUNTING',
	'NEW YORK'
);

INSERT INTO DEPT VALUES (
	20,
	'RESEARCH',
	'DALLAS'
);

INSERT INTO DEPT VALUES (
	30,
	'SALES',
	'CHICAGO'
);

INSERT INTO DEPT VALUES (
	40,
	'OPERATIONS',
	'BOSTON'
);

DROP TABLE EMP;

SELECT * FROM EMP;

CREATE TABLE EMP (
	EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7, 2),
	COMM NUMBER(7, 2),
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT
);

INSERT INTO EMP VALUES (
	7369,
	'SMITH',
	'CLERK',
	7902,
	TO_DATE('17-12-1980', 'dd-mm-yyyy'),
	800,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7499,
	'ALLEN',
	'SALESMAN',
	7698,
	TO_DATE('20-2-1981', 'dd-mm-yyyy'),
	1600,
	300,
	30
);

INSERT INTO EMP VALUES (
	7521,
	'WARD',
	'SALESMAN',
	7698,
	TO_DATE('22-2-1981', 'dd-mm-yyyy'),
	1250,
	500,
	30
);

INSERT INTO EMP VALUES (
	7566,
	'JONES',
	'MANAGER',
	7839,
	TO_DATE('2-4-1981', 'dd-mm-yyyy'),
	2975,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7654,
	'MARTIN',
	'SALESMAN',
	7698,
	TO_DATE('28-9-1981', 'dd-mm-yyyy'),
	1250,
	1400,
	30
);

INSERT INTO EMP VALUES (
	7698,
	'BLAKE',
	'MANAGER',
	7839,
	TO_DATE('1-5-1981', 'dd-mm-yyyy'),
	2850,
	NULL,
	30
);

INSERT INTO EMP VALUES (
	7782,
	'CLARK',
	'MANAGER',
	7839,
	TO_DATE('9-6-1981', 'dd-mm-yyyy'),
	2450,
	NULL,
	10
);

INSERT INTO EMP VALUES (
	7788,
	'SCOTT',
	'ANALYST',
	7566,
	TO_DATE('13-7-1987', 'dd-mm-yyyy')-85,
	3000,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7839,
	'KING',
	'PRESIDENT',
	NULL,
	TO_DATE('17-11-1981', 'dd-mm-yyyy'),
	5000,
	NULL,
	10
);

INSERT INTO EMP VALUES (
	7844,
	'TURNER',
	'SALESMAN',
	7698,
	TO_DATE('8-9-1981', 'dd-mm-yyyy'),
	1500,
	0,
	30
);

INSERT INTO EMP VALUES (
	7876,
	'ADAMS',
	'CLERK',
	7788,
	TO_DATE('13-7-1987', 'dd-mm-yyyy')-51,
	1100,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7900,
	'JAMES',
	'CLERK',
	7698,
	TO_DATE('3-12-1981', 'dd-mm-yyyy'),
	950,
	NULL,
	30
);

INSERT INTO EMP VALUES (
	7902,
	'FORD',
	'ANALYST',
	7566,
	TO_DATE('3-12-1981', 'dd-mm-yyyy'),
	3000,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7934,
	'MILLER',
	'CLERK',
	7782,
	TO_DATE('23-1-1982', 'dd-mm-yyyy'),
	1300,
	NULL,
	10
);




DROP TABLE BONUS;

CREATE TABLE BONUS (
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	SAL NUMBER,
	COMM NUMBER
);



DROP TABLE SALGRADE;

CREATE TABLE SALGRADE (
	GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER
);

INSERT INTO SALGRADE VALUES (
	1,
	700,
	1200
);

INSERT INTO SALGRADE VALUES (
	2,
	1201,
	1400
);

INSERT INTO SALGRADE VALUES (
	3,
	1401,
	2000
);

INSERT INTO SALGRADE VALUES (
	4,
	2001,
	3000
);

INSERT INTO SALGRADE VALUES (
	5,
	3001,
	9999
);

SELECT * FROM SALGRADE;

COMMIT;


/* 
 * 오라클 함수
 */

-- data type: 문자열, 숫자, 날짜, 시퀀스(숫자)
SELECT *
FROM v$sqlfn_metadata
;

/* 
 * 문자열 함수
 * UPPER() 대문자 변환
 * LOWER() 소문자 변환
 * LENGTH() 문자열 길이
 * 
 */

SELECT ename
	, upper(ename) AS to_upper_name
	, lower(ename) AS to_lower_name
 FROM EMP
;

SELECT *
 FROM EMP 
 WHERE upper(ename) = upper('ScoTT')
 ;

/*
 * TRIM: 공란 제거
 */
SELECT TRIM('___ ORACLE _ _ _      ')
 FROM dual
 ;


/*
 * CONCAT: 문자열 연결(더하기)
 */
SELECT empno
	, ename
	, concat(empno, ename)
	, concat(empno, ' ')
FROM emp
WHERE ename = upper('smith')
;

/*
 * REPLACE 문자열 교체
 */
SELECT '010-1234-5678' AS mobile_phone
	, replace('010-1234-5678','-','') AS replace_num
 FROM dual;

/*
 * LPAD, RPAD 문자열을 채우기하는 함수
 */
SELECT lpad('ORA_1234_XE', 20) AS lpad_20
	, rpad('ORA_1234_XE', 20) AS r_pad_20
 FROM dual
;

SELECT rpad('971225-', 14, '*') AS rpad_jmno
	,rpad('010-1234-', 13, '*') AS rpad_phone
 FROM dual
;

SELECT *
 FROM EMP E
 WHERE E.EMPNO >= :input_no;   -- 입력 받은 값 비교



/* 
 * NUMBER 숫자를 다루는 함수들
 * 
 * 정수(INTEGER), 부동소수(FLOAT) - 소수점이 있는 숫자
 * 부동소수의 경우, 소수점 이하 정밀도(precision) 차이가 발생
 * pi - 3.142457....39339 (15자리 이하
 * 
 */
 SELECT round(3.1428) AS roundpi
 	, round(123.456789) AS round1
 	, trunc(123.4567) AS trunc1
 	, trunc(-123.4567) AS trunc2
  FROM dual
  ;
 
  SELECT round(3.1428, 3) AS round11
 	, round(123.456789, 3) AS round21
 	, trunc(123.4567, 2) AS trunc11
 	, trunc(-123.4567, 2) AS trunc21
  FROM dual
  ;
 
SELECT ceil(3.14) AS ceil0  -- CEIL(부동소수)
	, floor(3.15) AS floor0
	, mod(15, 6) AS mod0
	, mod(11, 1) AS mod1
 FROM dual
;

-- power(숫자, 자승) -제곱승
SELECT power(3, 2), power(-3, 3)
 FROM dual
;

-- remainder(n1, n2)   n1을 n2로 나눈 나머지 값을 반환, n2=0이면 에러 발생
SELECT remainder(15, 2) AS r1
	, remainder(-11, 4) AS r2
 FROM dual
;

/*
 * DATE 날짜를 다루는 함수들
 * 
 * 날짜를 표현하는 일련번호 숫자가 존재
 * 
 */
SELECT sysdate AS now
	, sysdate - 1 AS yesterd
	, sysdate + 10 AS ten_days_from_now
 FROM dual
 ;

-- :month : 입력 변수를 받아 월 수 계산
SELECT add_months(sysdate, :month)
 FROM dual
;

-- month _between(날짜 1, 날짜 2)
SELECT ename
	, hiredate
	, MONTHS_BETWEEN(hiredate, sysdate)
 FROM emp
;

SELECT ename
	, hiredate
	, MONTHS_BETWEEN(sysdate, hiredate) / 12 AS year1
 FROM emp
;

SELECT SYSDATE AS now
	, NEXT_DAY(sysdate, '월요일') AS n_date
	, LAST_DAY(sysdate) AS l_date
 FROM dual
;

-- EXTRACT(날짜, 데이터 형식)로 숫자 값 반환(TO_CHAR는 문자열 반환)
SELECT ENAME
	, EXTRACT(YEAR FROM hiredate) AS y
	, EXTRACT(MONTH FROM hiredate) AS m
	, EXTRACT(DAY FROM hiredate) AS d
 FROM emp
;


SELECT SYSDATE, ROUND(SYSDATE, 'CC') AS format_cc
	, ROUND(SYSDATE, 'Q') AS format_q
	, ROUND(SYSDATE, 'DDD') AS format_ddd
 FROM dual
;


/*
 * 형 변환 (Cast, up-cast, down-cast)
 * 
 * down-cast : 큰 수를 담는 데이터형에서 작은 수를 담는 데이터 형으로 명시적 변형
 * 예시: 1234.3456 -> 234.3(데이터가 짤릴 수 있음)
 * 
 */

SELECT to_char(sysdate, 'YYYY/MM/DD HH24')
 FROM dual
; -- 시간까지(24시간) 표시

SELECT to_char(sysdate, 'DD HH24:MI:SS')
 FROM dual
; -- 시분초까지 표시

SELECT to_char(sysdate, 'MON', 'NLS_DATE_LANGUAGE = KOREAN') AS mon_kor
 FROM dual -- '3월' 이렇게 나옴 / NLS: 국가설정을 통한 국가별 문자셋으로 날짜 추출
;

SELECT to_char(sysdate, 'MON', 'NLS_DATE_LANGUAGE = JAPANESE') AS mon_jpn
 FROM dual 
;

SELECT SYSDATE 
	, to_char(sysdate, 'HH24:MI:SS') AS tm
 FROM dual
;

SELECT to_number('10,000', '999,999,999') AS tnum
 FROM dual
; -- 해당 자릿수까지만 출력

SELECT to_date('2023/03/20', 'YYYY/MM/DD') as td
 FROM dual
;

SELECT to_date('49/12/10', 'YY/MM/DD') AS yy_year_49
	,to_date('49/12/10', 'RR/MM/DD') AS rr_year_49
	,to_date('50/12/10', 'YY/MM/DD') AS yy_year_50
	,to_date('50/12/10', 'RR/MM/DD') AS rr_year_50
 FROM dual
; -- RR은 00~49는 2000년 부터 2049년까지, 50~99는 1950년부터 1999년까지
-- YY는 00 69는 2000년부터 2069년까지, 70~99는 1970년부터 1999년까지

/*
 * NULL
 * NULL 값: 알 수 없는 값, 계산이 불가능한 값
 * NULL 값 비교는 IS NULL <> IN NOT NULL
 * 
 * NVL(입력값, NULL인 경우 대체할 값)
 * NVL2(입력값, NULL이 아닌 경우, NULL인 경우)
 * !! 매우 중요, NVL 함수는 실무에서 많이 사용함
 * 
 */

SELECT empno
	, sal * 12 + nvl(comm, 0) AS sal12
	, job
	, to_char(hiredate, 'YYYY-MM-DD') AS ymd_hire
 FROM EMP e 
 ORDER BY sal12 DESC;

/* 
 * DECODE 함수는 값을 true, false로 단순 처리하는 경우
 * DECODE (입력 컬럼값,
 * 			'비교값1', 처리1,
 * 			'비교값2', 처리2,
 * 			..., 처리 ...) as 별칭
 * 
 * CASE 함수 경우, DECODE와 달리 비교 조건을 지칭하는 경우
 * CASE 컬럼값
 * 		WHEN '값1' THEN 처리1
 * 		WHEN '값2' THEN 처리2
 * 		...
 * 		ELSE 기타 모든 케이스
 * 		END AS 별칭
 * 
 */




SET TERMOUT ON

SET ECHO ON