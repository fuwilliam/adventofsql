--https://datalemur.com/questions/median-search-freq

WITH searches AS
(
  SELECT
    searches,
    num_users
  FROM search_frequency
),

searches_expanded AS
(
  SELECT 
    searches 
  FROM searches
  INNER JOIN GENERATE_SERIES(1, (SELECT MAX(num_users) FROM searches)) AS gs(num)
    ON gs.num <= searches.num_users
)

SELECT
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY searches)::decimal, 1) AS median
FROM searches_expanded