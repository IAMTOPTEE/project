use datagurus;

select *
from `hr data`;

SELECT gender, COUNT(*) AS total
FROM `hr data`
GROUP BY gender;

-- remote employees by department
SELECT department, COUNT(*) AS remote_employees
FROM `hr data`
WHERE location = 'Remote'
GROUP BY department;

-- remote by hq distri
SELECT location, COUNT(*) AS total_employees
FROM `hr data`
GROUP BY location;

-- race distribution
SELECT race, COUNT(*) AS total
FROM `hr data`
GROUP BY race;

-- number of terminated employees
SELECT COUNT(*) AS terminated_employees
FROM `hr data`
WHERE termdate IS NOT NULL;


-- longest serving employees
SELECT first_name, last_name, hire_date
FROM `hr data`
WHERE hire_date = (
  SELECT MIN(hire_date) FROM `hr data`
);

-- terminated employees by race
SELECT race, COUNT(*) AS terminated_count
FROM `hr data`
WHERE termdate IS NOT NULL
GROUP BY race;

-- age distribution
SELECT 
  FLOOR(DATEDIFF(CURRENT_DATE, STR_TO_DATE(birthdate, '%m-%d-%y')) / 365.25) AS age,
  COUNT(*) AS total
FROM `hr data`
GROUP BY age
ORDER BY age;

-- hire count over time
SELECT 
  YEAR(STR_TO_DATE(hire_date, '%m-%d-%y')) AS hire_year,
  COUNT(*) AS hires
FROM `hr data`
GROUP BY hire_year
ORDER BY hire_year;

-- tenure distribution by department
SELECT 
  department,
  ROUND(AVG(DATEDIFF(COALESCE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'), CURRENT_DATE), STR_TO_DATE(hire_date, '%m-%d-%y')) / 365.25), 2) AS avg_tenure_years,
  ROUND(MIN(DATEDIFF(COALESCE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'), CURRENT_DATE), STR_TO_DATE(hire_date, '%m-%d-%y')) / 365.25), 2) AS min_tenure_years,
  ROUND(MAX(DATEDIFF(COALESCE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'), CURRENT_DATE), STR_TO_DATE(hire_date, '%m-%d-%y')) / 365.25), 2) AS max_tenure_years
FROM `hr data`
GROUP BY department
ORDER BY avg_tenure_years DESC;

-- average length of employment
SELECT 
  ROUND(AVG(DATEDIFF(COALESCE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'), CURRENT_DATE), STR_TO_DATE(hire_date, '%m-%d-%y')) / 365.25), 2) AS avg_tenure_years
FROM `hr data`;


-- dept with highest turn over rate
SELECT
	department,
	SUM(
		CASE
		WHEN termdate IS NOT NULL AND termdate <> ''
            THEN 1 ELSE 0 END) 
            * 100 / COUNT(*) AS turnover_rate
FROM `hr data`
GROUP BY department
ORDER BY turnover_rate DESC
LIMIT 1
;
