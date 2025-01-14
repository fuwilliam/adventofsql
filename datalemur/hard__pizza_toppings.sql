--https://datalemur.com/questions/pizzas-topping-cost

WITH cartesian_product AS (
    SELECT
        t1.topping_name AS topping_1,
        t2.topping_name AS topping_2,
        t3.topping_name AS topping_3,
        t1.ingredient_cost
        + t2.ingredient_cost
        + t3.ingredient_cost AS total_cost
    -- HASHTEXT(t1.topping_name)::bigint AS hash1,
    -- HASHTEXT(t2.topping_name)::bigint AS hash2, 
    -- HASHTEXT(t3.topping_name)::bigint AS hash3
    FROM pizza_toppings AS t1
    INNER JOIN pizza_toppings AS t2 ON t1.topping_name < t2.topping_name
    INNER JOIN pizza_toppings AS t3 ON t2.topping_name < t3.topping_name
-- the join conditions handle the alphabetical sorting for us!
)

SELECT
    total_cost,
    CONCAT(topping_1, ',', topping_2, ',', topping_3) AS pizza
FROM cartesian_product
ORDER BY 2 DESC, 1 ASC
--120 combinations
