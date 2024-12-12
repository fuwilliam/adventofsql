WITH gift_requests_ranking AS
(
    SELECT 
        gift_id,
        gift_name, 
        COUNT(1) AS request_count,
        PERCENT_RANK() OVER (ORDER BY COUNT(1))::numeric(12,2) AS percentile_rank
    FROM gift_requests
    INNER JOIN gifts USING(gift_id)
    GROUP BY 1, 2
    ORDER BY 4 desc
),

highest_percentiles AS
(
    SELECT
        gift_name,
        percentile_rank,
        DENSE_RANK() OVER (ORDER BY percentile_rank DESC) AS percentile_grouped_rank
    FROM gift_requests_ranking
)

SELECT
    gift_name,
    percentile_rank,
    percentile_grouped_rank
FROM highest_percentiles
WHERE percentile_grouped_rank = 2
ORDER BY 1
