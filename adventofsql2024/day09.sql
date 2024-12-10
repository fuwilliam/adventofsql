WITH reindeer_sessions AS
(
    SELECT
        r.reindeer_id,
        r.reindeer_name,
        s.exercise_name,
        AVG(s.speed_record)::decimal(12,2) AS avg_exercise_speed
    FROM reindeers AS r
    INNER JOIN training_sessions AS s
        USING(reindeer_id)
    WHERE r.reindeer_name NOT IN ('Rudolf', 'Rudolph')
    GROUP BY 1, 2, 3
)

SELECT 
    reindeer_name,
    avg_exercise_speed
FROM reindeer_sessions
ORDER BY 2 DESC
LIMIT 3
