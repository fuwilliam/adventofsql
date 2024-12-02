--https://datalemur.com/questions/sql-department-company-salary-comparison

WITH march_salaries AS
(
  SELECT
    salary.employee_id,
    employee.department_id,
    salary.amount,
    AVG(amount) OVER () AS company_average_salary,
    DATE_TRUNC('month', salary.payment_date) AS payment_month
  FROM salary
  LEFT JOIN employee ON salary.employee_id = employee.employee_id
  WHERE DATE_TRUNC('month', salary.payment_date) = '2024-03-01'
),

march_department_avg AS
(
  SELECT
    department_id,
    payment_month,
    company_average_salary,
    AVG(amount) AS department_average_salary
  FROM march_salaries
  GROUP BY 1, 2, 3
)

SELECT 
  department_id,
  TO_CHAR(payment_month, 'MM-YYYY') AS payment_date,
  CASE WHEN department_average_salary > company_average_salary
       THEN 'higher'
       WHEN department_average_salary = company_average_salary
       THEN 'same'
       WHEN department_average_salary < company_average_salary
       THEN 'lower'
  END AS comparison
FROM march_department_avg