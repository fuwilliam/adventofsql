WITH children_gifts AS
(
    SELECT
        children.child_id,
        children.name AS child_name,
        gifts.gift_id,
        gifts.name AS toy_name,
        gifts.price
    FROM children
    INNER JOIN gifts USING(child_id)
),

average_gift_price AS
(
    SELECT
        AVG(price) AS avg_price
    FROM gifts
)

SELECT 
    child_id,
    child_name,
    toy_name,
    price
FROM children_gifts
WHERE price > (SELECT MAX(avg_price) FROM average_gift_price)
ORDER BY price