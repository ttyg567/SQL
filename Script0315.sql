SELECT ENAME AS "EMP_NAME", SAL*3 AS "SAL3M", COMM AS COMMISION FROM EMP;


SELECT 100+5	
	,10-3
	,30*2
	,10/3;

SELECT 100+5
	,10-3
	, 30*2
	,10/3
	FROM dual;
	
SELECT dbms_random.value() * 100 
FROM dual;

SELECT ENAME
	FROM EMP 
	AS employee;
	
SELECT ENAME AS "employee name" FROM EMP employee;


SELECT *
FROM EMP 
ORDER BY SAL;



SELECT *
FROM EMP 
ORDER BY SAL;

SELECT *
FROM EMP 
ORDER BY SAL DESC;

SELECT *
FROM EMP 
ORDER BY deptno ASC, sal DESC;


SELECT * FROM nls_database_parameters;

SELECT * FROM nls_database_parameters WHERE PARAMETER = 'nls_characterset';



