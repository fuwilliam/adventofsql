WITH daily_drinks AS
(
    SELECT
        date,
        drink_name,
        SUM(quantity) AS quantity
    FROM drinks
    GROUP BY 1, 2
)

SELECT
    date,
    COUNT(1) AS match_count
FROM daily_drinks
WHERE (drink_name = 'Hot Cocoa' AND quantity = 38)
    OR (drink_name = 'Peppermint Schnapps' AND quantity = 298)
    OR (drink_name = 'Eggnog' AND quantity = 198)
GROUP BY 1
HAVING COUNT(1) = 3
