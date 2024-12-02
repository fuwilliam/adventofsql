--https://datalemur.com/questions/prime-warehouse-storage

WITH batch_size AS
(
  SELECT
    item_type,
    SUM(square_footage) AS batch_sq_ft,
    COUNT(item_id) AS batch_item_count
  FROM inventory
  GROUP BY 1
),

max_prime_allocation AS
( --we need to reserve room for at least 1 batch of not_prime items
  SELECT 
    (500000 - batch_sq_ft) AS max_prime_sq_ft 
  FROM batch_size 
  WHERE item_type = 'not_prime'
),

prime_allocation AS
(
  SELECT
    item_type,
    FLOOR((SELECT MAX(max_prime_sq_ft) FROM max_prime_allocation) / batch_sq_ft) * batch_item_count AS item_count,
    FLOOR((SELECT MAX(max_prime_sq_ft) FROM max_prime_allocation) / batch_sq_ft) * batch_sq_ft AS actual_sq_ft
  FROM batch_size
  WHERE item_type = 'prime_eligible'
),

non_prime_allocation AS
(
  SELECT
    item_type,
    FLOOR((SELECT 500000 - MAX(actual_sq_ft) FROM prime_allocation) / batch_sq_ft) * batch_item_count AS item_count,
    FLOOR((SELECT 500000 - MAX(actual_sq_ft) FROM prime_allocation) / batch_sq_ft) * batch_sq_ft AS actual_sq_ft
  FROM batch_size
  WHERE item_type = 'not_prime'
)

SELECT item_type, item_count FROM prime_allocation
UNION ALL
SELECT item_type, item_count FROM non_prime_allocation

-- 900 * 555.2 = 499680
-- 320 leftover for non-prime batches
-- 2 * 128.50 = 2 batches