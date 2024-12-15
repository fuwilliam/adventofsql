WITH sleigh_coordinate AS
(
    SELECT
        timestamp,
        coordinate
    FROM sleigh_locations
    ORDER BY timestamp DESC
    LIMIT 1
),

sleigh_location AS
(
    SELECT
        place_name
    FROM areas, sleigh_coordinate
    WHERE ST_INTERSECTS(polygon, coordinate)
)

SELECT
    place_name
FROM sleigh_location
