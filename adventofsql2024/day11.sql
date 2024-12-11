WITH harvests AS
(
    SELECT
        field_name,
        harvest_year,
        CASE season
            WHEN 'Spring' THEN 1
            WHEN 'Summer' THEN 2
            WHEN 'Fall' THEN 3
            WHEN 'Winter' THEN 4
        END AS harvest_quarter,
        trees_harvested
    FROM treeharvests
),

harvest_dates AS
(
    SELECT
        field_name,
        TO_DATE(harvest_year || '-' || ((harvest_quarter -1 ) * 3 + 1) || '-01', 'YYYY-MM-DD') AS harvest_year_month,
        trees_harvested
    FROM harvests
),

harvest_moving_avg AS 
(
    SELECT
        field_name,
        harvest_year_month,
        trees_harvested,
        AVG(trees_harvested) OVER (
            PARTITION BY field_name
            ORDER BY harvest_year_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )::numeric(12,2) AS three_season_moving_avg
    FROM harvest_dates
)

SELECT * FROM harvest_moving_avg
ORDER BY 4 DESC
