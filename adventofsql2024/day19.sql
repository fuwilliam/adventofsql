WITH employee_performance_score AS
(
    SELECT
        employee_id,
        salary,
        year_end_performance_scores,
        year_end_performance_scores[array_length(year_end_performance_scores, 1)] AS last_performance_score
    FROM employees
),

bonus_eligibility AS
(
    SELECT
        employee_id,
        salary,
        CASE WHEN last_performance_score > (AVG(last_performance_score) OVER())
            THEN TRUE
            ELSE FALSE
        END AS bonus_eligible
    FROM employee_performance_score
),

total_salary AS 
(
    SELECT
        employee_id,
        salary,
        CASE WHEN bonus_eligible
            THEN salary * 0.15
            ELSE 0
        END AS bonus_pay
    FROM bonus_eligibility
)

SELECT 
    SUM(salary) AS total_salary,
    SUM(bonus_pay) AS total_bonus,
    (SUM(salary) + SUM(bonus_pay))::decimal(12,2) AS total_pay
FROM total_salary
