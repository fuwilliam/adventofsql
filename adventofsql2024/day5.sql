WITH toy_production_daily AS
(
    SELECT
        production_date,
        toys_produced,
        LAG(toys_produced) OVER(ORDER BY production_date) AS previous_day_production
    FROM public.toy_production
),

toy_production_comparison AS
(
    SELECT
        production_date,
        toys_produced,
        previous_day_production,
        toys_produced - previous_day_production AS production_change,
        ROUND(100*((toys_produced::numeric / previous_day_production) - 1), 2) AS production_change_percentage
    FROM toy_production_daily
)

SELECT 
* 
FROM toy_production_comparison
WHERE production_change_percentage IS NOT NULL
ORDER BY production_change_percentage DESC