WITH id_range AS 
(
    SELECT 
        MIN(id) AS min_id,
        MAX(id) AS max_id
    FROM sequence_table
),

continuous_range AS 
(
    SELECT 
        generate_series(min_id, max_id) AS id
    FROM id_range
),

gaps AS 
(
    SELECT 
        cont.id,
        -- subtracting the row number from id gives us a unique group for each gap
        cont.id - ROW_NUMBER() OVER (ORDER BY cont.id) AS gap_group
    FROM continuous_range AS cont
    LEFT JOIN sequence_table AS seq 
        ON cont.id = seq.id
    WHERE seq.id IS NULL
)

SELECT
    MIN(id) AS gap_start,
    MAX(id) AS gap_end,
    STRING_AGG(id::text, ',') AS missing_ids
FROM gaps
GROUP BY gap_group
ORDER BY gap_group
