WITH quarterly_sales AS
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS sale_year,
        EXTRACT(QUARTER FROM sale_date) AS sale_quarter,
        SUM(amount) AS total_sales
    FROM sales
    GROUP BY 1, 2
),

qoq_sales AS
(
    SELECT
        sale_year,
        sale_quarter,
        total_sales,
        LAG(total_sales) OVER(ORDER BY sale_year, sale_quarter) AS last_quarter_total_sales
    FROM quarterly_sales
)

SELECT
    sale_year,
    sale_quarter,
    (total_sales / last_quarter_total_sales)::decimal(12,4) - 1 AS growth_rate
FROM qoq_sales
WHERE last_quarter_total_sales IS NOT NULL
ORDER BY 3 DESC
