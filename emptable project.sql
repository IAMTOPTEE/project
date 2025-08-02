use  datagurus;

select *
from emptable;

SELECT 
	department
FROM (
	  SELECT
		department,
        COUNT(*) AS total_employees,
        SUM(
		CASE
		WHEN hire_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
                THEN 1 ELSE 0
                END) AS recent_hires
		FROM emptable
        GROUP BY department
	   ) AS dept_summary
WHERE (recent_hires / total_employees) * 100 > 50
;