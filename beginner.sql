SELECT *
FROM employee_demographics
LIMIT 5;

SELECT first_name,
last_name,
birth_date,
age,
(age + 10) * 10
FROM employee_demographics;
# PEMDAS -- order of operations

SELECT DISTINCT first_name, gender
FROM employee_demographics;

-- WHERE Clause

SELECT *
FROM employee_salary
WHERE first_name = 'Leslie';

SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM employee_demographics
WHERE gender = 'Female';


#We can also return rows that do have not "Scranton"
SELECT *
FROM employee_demographics
WHERE gender != 'Female';


#We can use WHERE clause with date value also
SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01';

-- Here '1990-01-01' is the default data formate in MySQL.
-- There are other date formats as well that we will talk about in a later lesson.

# LIKE STATEMENT

-- two special characters a % and a _

-- % means anything
SELECT * 
FROM employee_demographics
WHERE first_name LIKE 'a%';

-- _ means a specific value
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a__';

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a___%';

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a___';

-- GROUP BY

SELECT  gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

-- ORDER BY

SELECT *
FROM employee_demographics
ORDER BY gender ASC, age DESC; -- age, gender işe yaramazdı çünkü age gen. unique

SELECT *
FROM employee_demographics
ORDER BY 5, 4; -- NOT RECOMMENDED!


-- Having vs. Where

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

-- using both

SELECT occupation, AVG(salary) 
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000; -- for aggregated function columns

-- Limit & Aliasing

SELECT * 
FROM employee_demographics
ORDER BY age DESC
LIMIT 2,1; -- go to the second result row then go one row down and give it as output

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;
