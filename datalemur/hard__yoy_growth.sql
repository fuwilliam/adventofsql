--https://datalemur.com/questions/yoy-growth-rate

WITH yearly_transactions AS
(
  SELECT
    DATE_TRUNC('year', transaction_date) AS transaction_year,
    product_id,
    SUM(spend) AS product_spend
  FROM user_transactions
  GROUP BY 1, 2
  ORDER BY 1, 2
),

last_year_transactions AS
(
  SELECT
    transaction_year,
    product_id,
    product_spend AS curr_year_spend,
    LAG(product_spend) 
      OVER (PARTITION BY product_id ORDER BY transaction_year) AS last_year_spend
  FROM yearly_transactions
),

year_over_year_transactions AS 
(
  SELECT
    DATE_PART('year', transaction_year) AS year,
    product_id,
    curr_year_spend,
    last_year_spend,
    CAST(100*((curr_year_spend/last_year_spend) - 1) AS decimal(10,2)) AS yoy_rate
  FROM last_year_transactions
  ORDER BY 2, 1
)

SELECT * FROM year_over_year_transactions