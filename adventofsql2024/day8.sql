
WITH RECURSIVE staff_hierarchy AS
(
    SELECT 
        staff_id,
        manager_id,
        1 AS hierarchy_count
    FROM staff
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        s.staff_id,
        s.manager_id,
        hierarchy_count + 1 AS hierarchy_count
    FROM staff AS s
    INNER JOIN staff_hierarchy AS h ON s.manager_id = h.staff_id
)

SELECT 
    MAX(hierarchy_count) AS number_of_levels
FROM staff_hierarchy