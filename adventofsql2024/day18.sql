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
),

hierarchy_peer_count AS
(
    SELECT 
        hierarchy_count AS hierarchy_level,
        COUNT(1) AS peer_count
    FROM staff_hierarchy
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1
)

SELECT
    MIN(staff_id)
FROM staff_hierarchy
WHERE hierarchy_count = (SELECT MAX(hierarchy_level) FROM hierarchy_peer_count)
