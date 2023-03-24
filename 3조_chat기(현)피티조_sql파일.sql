
DROP TABLE "employee";
DROP TABLE "vac_used";
DROP TABLE "branch";
DROP TABLE "vacation";
DROP TABLE "job";

CREATE TABLE employee (
	emp_id			VARCHAR2(10)		NOT NULL,
	branch_cd		CHAR(4)				NOT NULL,
	vac_id			VARCHAR2(10)		NOT NULL,
	vac_used_id		VARCHAR2(10)		NOT NULL,
	job_id			VARCHAR2(10)		NOT NULL,
	emp_name		VARCHAR2(10)		NULL,
	contact			VARCHAR2(15)		NULL,
	hire_date		DATE				NULL,
	salary			NUMBER(10,0)		NULL
);

DROP TABLE vac_used;

CREATE TABLE vac_used (
	vac_used_id			VARCHAR2(11)		NOT NULL,
	year_vac_used		NUMBER(2,0)			NULL,
	dev_vac_used		NUMBER(2,0)			NULL,
	health_vac_used		NUMBER(2,0)			NULL,
	reward_vac_used		NUMBER(2,0)			NULL
);

DROP TABLE branch;

CREATE TABLE branch (
	branch_cd		CHAR(4)				NOT NULL,
	head_branch		CHAR(4)				NULL,
	loc				VARCHAR2(50)		NULL
);

DROP TABLE vacation;

CREATE TABLE vacation (
	vac_id			VARCHAR2(11)		NOT NULL,
	total_vac		NUMBER(3,0)			NULL,
	year_vac		NUMBER(2,0)			NULL,
	dev_vac			NUMBER(2,0)			NULL,
	health_vac		NUMBER(1,0)			NULL,
	reward_vac		NUMBER(2,0)			NULL
);

DROP TABLE job;

CREATE TABLE job(
	job_id		VARCHAR2(10)		NOT NULL,
	job_duty	VARCHAR2(50)		NULL,
	job_admin	VARCHAR2(50)		NULL,
	is_main		VARCHAR2(10)		NULL,
	is_chief	VARCHAR2(10)		NULL
);

ALTER TABLE employee ADD CONSTRAINT PK_EMPLOYEE PRIMARY KEY (
	emp_id,
	branch_cd,
	vac_id,
	vac_used_id,
	job_id
);

ALTER TABLE vac_used ADD CONSTRAINT PK_VAC_USED PRIMARY KEY (
	vac_used_id
);

ALTER TABLE branch ADD CONSTRAINT PK_BRANCH PRIMARY KEY (
	branch_cd
);

ALTER TABLE vacation ADD CONSTRAINT PK_VACATION PRIMARY KEY (
	vac_id
);

ALTER TABLE job ADD CONSTRAINT PK_JOB PRIMARY KEY (
	job_id
);

ALTER TABLE employee ADD CONSTRAINT FK_branch_TO_employee_1 FOREIGN KEY (
	branch_cd
)
REFERENCES branch (
	branch_cd
);

ALTER TABLE employee ADD CONSTRAINT FK_vacation_TO_employee_1 FOREIGN KEY (
	vac_id
)
REFERENCES vacation (
	vac_id
);

ALTER TABLE employee ADD CONSTRAINT FK_vac_used_TO_employee_1 FOREIGN KEY (
	vac_used_id
)
REFERENCES vac_used (
	vac_used_id
);

ALTER TABLE employee ADD CONSTRAINT FK_job_TO_employee_1 FOREIGN KEY (
	job_id
)
REFERENCES job (
	job_id
);


SELECT * FROM job;
SELECT * FROM employee;


CREATE INDEX idx_emp_id ON employee(emp_id); --PK라서 인덱스 생략.

UPDATE BRANCH 			--데이터 입력시 head_brach 오류입력
 SET HEAD_BRANCH = 8525 --WHERE생략 : 전부 변경이라서
;


/*
 * 1. 직원 : 직원별 연차 사용률
 * 2. 영업점장 : 지점별 연차 사용률 현황 및 직원별 연차 사용률
 * 3. 본부장 : 영업점별 연차 사용률 현황
 * 
 */


--직원별 휴가 사용률 조회 화면

SELECT e.EMP_ID AS "사번"
	  ,e.EMP_NAME AS "직원명"
	  ,TRUNC(year_vac_used / year_vac * 100)  AS "연차 사용률"
	  ,TRUNC(dev_vac_used / dev_vac * 100) AS "자기계발휴가 사용률"
	  ,CASE --신입의 경우 건강검진휴가가 없음. 0으로 나눌 경우
	  	WHEN health_vac = 0 THEN 1
	  	ELSE TRUNC(health_vac_used / health_vac * 100)
	   END AS "건강검진휴가 사용률"
	  ,CASE 
	  	WHEN reward_vac = 0 THEN 1
	  	ELSE TRUNC(reward_vac_used / reward_vac * 100)
	  END AS "보상휴가 사용률"
	FROM employee e
	   , vacation v
	   , vac_used u
	WHERE e.vac_id = v.vac_id
	AND e.vac_used_id = u.vac_used_id
	AND emp_id = 2345001 --원하는 직원번호 입력하여 휴가 사용률 조회
;
	
--직원별 잔여 휴가 조회 화면

SELECT e.EMP_ID AS "사번"
	  ,e.EMP_NAME AS "직원명"
	  ,(v.YEAR_VAC - u.YEAR_VAC_USED)  AS "잔여 연차"
	  ,(v.DEV_VAC - u.DEV_VAC_USED)  AS "잔여 자기계발휴가"
	  ,(v.HEALTH_VAC - u.HEALTH_VAC_USED) AS "잔여 건강검진휴가"
	  ,(v.REWARD_VAC - u.REWARD_VAC_USED) AS "잔여 보상휴가"
	FROM employee e
	   , vacation v
	   , vac_used u
	WHERE e.vac_id = v.vac_id
	AND e.vac_used_id = u.vac_used_id
	AND emp_id = 2345001 --원하는 직원번호 입력하여 휴가 사용률 조회
;


--영업점 직원별 휴가 사용률 조회 화면

SELECT e.EMP_ID AS "사번"
	  ,e.emp_name AS "직원명"
	  --,e.BRANCH_CD AS "부점명"
	  ,TRUNC(u.year_vac_used / v.year_vac * 100) AS "연차 사용률"
	  ,TRUNC(u.dev_vac_used / v.dev_vac * 100) AS "자기계발휴가 사용률"
	  ,CASE 
	  	WHEN v.health_vac = 0 THEN 1
	  	ELSE TRUNC(u.health_vac_used / v.health_vac * 100)
	   END AS "건강검진휴가 사용률"
	  ,CASE 
	  	WHEN v.reward_vac = 0 THEN 1
	  	ELSE TRUNC(u.reward_vac_used / v.reward_vac * 100)
	   END AS "보상휴가 사용률"
	FROM employee e
	   , vacation v
	   , vac_used u
	   , branch b
	WHERE e.vac_id = v.vac_id
	AND e.vac_used_id = u.vac_used_id
	AND e.branch_cd = b.branch_cd
	AND e.branch_cd = 0280 --원하는 부점번호 입력하여 휴가 사용률 조회
	ORDER BY emp_id --사번으로 정렬
;	
	
--영업점별 휴가 사용률 및 KPI 충족여부

SELECT e.branch_cd AS "부점코드"
	  ,TRUNC(SUM(u.year_vac_used) / SUM(v.year_vac) * 100) AS "연차 사용률"
	  ,CASE --휴가 사용률을 넘었을 경우 O, 아닌 경우 X 출력
	  	WHEN TRUNC(SUM(u.year_vac_used) / SUM(v.year_vac) * 100) >= 90 THEN 'O'
	  	ELSE 'X'
	   END AS "연차 KPI"
	  ,TRUNC(SUM(u.dev_vac_used) / SUM(v.dev_vac) * 100) AS "자기계발휴가 사용률"
	  ,CASE 
	  	WHEN TRUNC(SUM(u.dev_vac_used) / SUM(v.dev_vac) * 100) >= 60 THEN 'O'
	  	ELSE 'X'
	   END AS "자기계발휴가 KPI"  
	  ,TRUNC(SUM(u.health_vac_used) / SUM(v.health_vac) * 100) AS "건강검진휴가 사용률"
	  ,CASE 
	  	WHEN TRUNC(SUM(u.health_vac_used) / SUM(v.health_vac) * 100) >= 60 THEN 'O'
	  	ELSE 'X'
	   END AS "건강검진휴가 KPI "  
	  ,TRUNC(SUM(u.reward_vac_used) / SUM(v.reward_vac) * 100) AS "보상휴가 사용률"
	  ,CASE 
	  	WHEN TRUNC(SUM(u.reward_vac_used) / SUM(v.reward_vac) * 100) >= 100 THEN 'O'
	  	ELSE 'X'
	   END AS "보상휴가 KPI"
	  FROM employee e
	   , vacation v
	   , vac_used u
	   , branch b
	WHERE e.vac_id = v.vac_id
	AND e.vac_used_id = u.vac_used_id
	AND e.branch_cd = b.branch_cd	
	AND e.branch_cd = 8525
	GROUP BY e.branch_cd 
;


--본부 조회 영업점별 휴가 사용률

SELECT E.branch_cd AS "부점코드"
	  ,TRUNC(SUM(year_vac_used) / SUM(year_vac) * 100) AS "연차 사용률"
	  ,TRUNC(SUM(dev_vac_used) / SUM(dev_vac) * 100) AS "자기계발 사용률"
	  ,TRUNC(SUM(health_vac_used) / SUM(health_vac) * 100) AS "건강검진휴가 사용률"
	  ,TRUNC(SUM(reward_vac_used) / SUM(reward_vac) * 100) AS "보상휴가 사용률"
	FROM employee e
	   , vacation v
	   , vac_used u
	   , branch b	   
	WHERE e.vac_id = v.vac_id
	AND e.vac_used_id = u.vac_used_id
	AND e.branch_cd = b.branch_cd		
	AND head_branch = 8525 --원하는 본부를 선택하여 입력
	GROUP BY E.branch_cd
	ORDER BY E.branch_cd
;	
	
	
--본부 조회 영업점별 KPI 충족여부

SELECT e.branch_cd AS "부점코드"
	  ,CASE 
	  	WHEN TRUNC(SUM(year_vac_used) / SUM(year_vac) * 100) >= 90 THEN 'O'
	  	ELSE 'X'
	    END AS "연차 KPI"
	  ,CASE 
	  	WHEN TRUNC(SUM(dev_vac_used) / SUM(dev_vac) * 100) >= 60 THEN 'O'
	  	ELSE 'X'
	   END AS "자기계발휴가 KPI"	  
	  ,CASE 
	  	WHEN TRUNC(SUM(health_vac_used) / SUM(health_vac) * 100) >= 60 THEN 'O'
	  	ELSE 'X'
	   END AS "건강검진휴가 KPI"  
	  ,CASE 
	  	WHEN TRUNC(SUM(reward_vac_used) / SUM(reward_vac) * 100) >= 100 THEN 'O'
	  	ELSE 'X'
	   END AS "보상휴가 KPI"
	  FROM employee e
	   , vacation v
	   , vac_used u
	   , branch b	   	   
	WHERE e.vac_id = v.vac_id
	AND e.vac_used_id = u.vac_used_id
	AND e.branch_cd = b.branch_cd	
	AND B.head_branch = 8525 --원하는 본부를 선택하여 입력
	GROUP BY E.branch_cd 
	ORDER BY E.branch_cd
;	


--SELECT e.EMP_ID 
--	  ,v.REWARD_VAC 
--	  ,u.REWARD_VAC_USED 
--	  ,v.DEV_VAC 
--	  ,u.DEV_VAC_USED
--	  ,v.YEAR_VAC 
--	  ,u.YEAR_VAC_USED 
--	  ,v.HEALTH_VAC 
--	  ,u.HEALTH_VAC_USED 
--FROM EMPLOYEE e
--	,BRANCH b 
--	,VACATION v 
--	,VAC_USED u
--WHERE e.BRANCH_CD =b.BRANCH_CD 
--AND e.VAC_ID =v.VAC_ID 
--AND e.VAC_USED_ID = u.VAC_USED_ID 
--AND e.BRANCH_CD =0280
--;
