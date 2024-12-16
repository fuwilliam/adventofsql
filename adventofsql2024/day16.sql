WITH sleigh_coordinate AS
(
    SELECT
        timestamp AS arrival_time,
        LEAD(timestamp) OVER (ORDER BY timestamp) AS departure_time,
        coordinate
    FROM sleigh_locations
),

sleigh_location AS
(
    SELECT
        place_name,
        arrival_time,
        departure_time,
        EXTRACT(EPOCH FROM departure_time - arrival_time)/3600 AS hours_spent
    FROM areas, sleigh_coordinate
    WHERE ST_INTERSECTS(polygon, coordinate)
)

SELECT
    place_name,
    SUM(hours_spent) AS total_hours_spent
FROM sleigh_location
GROUP BY 1
ORDER BY 2 DESC
