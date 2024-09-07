SELECT * 
FROM employee_demographics;

SELECT *
FROM employee_salary;

-- Inner Join
SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
-- Outer Joins
SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
-- Self Join 

SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id;

-- Joining Multiple Tables Together

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id    
INNER JOIN parks_departments pd
	ON sal.dept_id = pd.department_id;


SELECT *
FROM parks_departments; -- this is usually called a reference table

-- Unions

SELECT first_name, last_name -- this is like join but row-based, so keep the data same
FROM employee_demographics
UNION -- the same as UNION DISTINCT by default, so no duplicates
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name 
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;
    
SELECT first_name, last_name, 'Old Man' AS Label -- this shows a new column called Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION 
SELECT first_name, last_name, 'Highly Paid Employee' AS Label 
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;


-- String Functions

SELECT LENGTH('skyfall');

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT TRIM('        sky   '); -- LTRIM  RTRIM 

SELECT first_name, LEFT(first_name, 4) -- fetches the 4 characters of first_name from left
FROM employee_demographics;

SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name, 3, 2),
birth_date,
SUBSTRING(birth_date, 6, 2) AS birth_month -- starting from 3rd char. get 2 characters, 3rd is included
FROM employee_demographics;


SELECT first_name, REPLACE(first_name, 'a', 'z') -- replaces all 'a's with 'z' CASE sensitive!
FROM employee_demographics;


SELECT LOCATE('x', 'Alexander'); -- output: 4

SELECT first_name, LOCATE('An', first_name) -- might be useful in CTEs
FROM employee_demographics;


SELECT first_name, last_name, 
CONCAT(first_name, ' ', last_name) AS full_name -- really helpful
FROM employee_demographics;


-- CASE Statements

SELECT first_name, 
last_name,
age,
CASE 
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN  31 AND 50 THEN 'Old'
    WHEN age >= 50 THEN "'On Death's Door'"
END AS Age_Bracket
FROM employee_demographics;


-- pay increase and bonus
-- < 50000 --> 5%
-- > 50000 --> 7%
-- Finance --> 10% bonus

SELECT first_name, 
last_name, 
salary,
CASE
	WHEN salary < 50000 THEN salary * 105/100
	WHEN salary > 50000 THEN salary * 107/100
	ELSE salary
END AS new_salary,
CASE 
	WHEN dept_id = 6 THEN salary * 1.1 
END AS Bonus
FROM employee_salary;

SELECT * 
FROM parks_departments;

SELECT ed.first_name, ed.last_name, pd.department_name, es.salary,
	CASE 
		WHEN es.salary < 50000 THEN ROUND(es.salary * 1.05)
		WHEN es.salary > 50000 THEN ROUND(es.salary * 1.07)
        ELSE es.salary
	END as new_salary,
	CASE 
		WHEN pd.department_name like 'finance' THEN ROUND(es.salary * .1)
		ELSE 0
	END as bonus
FROM employee_demographics ed 
	INNER JOIN employee_salary es on ed.employee_id = es.employee_id 
	INNER JOIN parks_departments pd on es.dept_id = pd.department_id
ORDER BY new_salary DESC;


-- Subqueries

SELECT *  -- subquery in a where statement
FROM employee_demographics
WHERE employee_id IN 
			(SELECT employee_id 
				FROM employee_salary
                WHERE dept_id = 1);
                
SELECT first_name, salary, 
(SELECT AVG(salary)
FROM employee_salary) -- subquery in a select statement
FROM employee_salary;
                
                
SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;                
	
SELECT * 
FROM 
(SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age) -- subquery in a from statement
FROM employee_demographics
GROUP BY gender) AS agg_table;
                
SELECT AVG(max_age) 
FROM 
(SELECT gender, 
AVG(age) AS avg_age, 
MAX(age) AS max_age, 
MIN(age) as min_age, 
COUNT(age)               -- subquery in a from statement
FROM employee_demographics
GROUP BY gender) AS agg_table;


-- Window Functions OVER(PARTITION BY ... ORDER BY ...), ROW_NUMBER(), RANK(), DENSE_RANK()

SELECT dem.first_name, dem.last_name, gender, AVG(salary) OVER(PARTITION BY gender) 
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;    
-- !!! see the difference between these two

SELECT dem.first_name, dem.last_name,gender, AVG(salary) AS avg_salary 
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY dem.first_name, dem.last_name,gender;


SELECT dem.first_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS rolling_total
FROM employee_demographics AS dem      
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;


SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num, -- if salary is the same, rank_num is also the same
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_num -- see the diff
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;







