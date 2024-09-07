-- CTEs --> common table expressions - used to refer to subqueries


WITH CTE_Example (Gender, AVG_Sal, MAX_Sal, MIN_Sal, COUNT_Sal) AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal) 
FROM CTE_Example;

-- Look how these two give the same output, but CTE one is much more readable and prettier.

SELECT AVG(avg_sal)
FROM
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
example_subquery;

SELECT AVG(avg_sal) -- gives an error because CTEs are not saved permanent tables, so not seen
FROM CTE_Example;

WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics 
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *  
FROM CTE_Example
JOIN CTE_Example2 -- by default this is INNER JOIN
	ON CTE_Example.employee_id = CTE_Example2.employee_id;


-- Temporary Tables

CREATE TEMPORARY TABLE temp_table -- manually generates the temp table 
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

SELECT * 
FROM temp_table;

INSERT INTO temp_table
VALUES('Alex', 'Freberg', 'Lord of the Rings: The Two Towers');


SELECT *
FROM employee_salary;


CREATE TEMPORARY TABLE salary_over_50k -- generates temp table from an already existing table
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k; -- this will work only in the same session


-- Stored Procedures

SELECT *
FROM employee_salary
WHERE salary >= 50000;


CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salaries2();


DELIMITER $$
CREATE PROCEDURE large_salaries4(p_employee_id INT)
BEGIN
	SELECT salary
	FROM employee_salary
    WHERE employee_id = p_employee_id;
END $$
DELIMITER ;

CALL large_salaries4(1);


-- Triggers and Events

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;


DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
	FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);

-- EVENTS - scheduled automater

SELECT *
FROM employee_demographics;


DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO 
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';







