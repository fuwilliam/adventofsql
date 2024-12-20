WITH url_list AS
(
    SELECT
        request_id,
        url,
        UNNEST(STRING_TO_ARRAY(SPLIT_PART(url, '?', 2), '&')) AS parameter
    FROM web_requests
    WHERE url LIKE '%utm_source=advent-of-sql%'
),

url_parameters AS
(
    SELECT 
        request_id,
        url,
        parameter,
        SPLIT_PART(parameter, '=', 1) AS parameter_key,
        SPLIT_PART(parameter, '=', 2) AS parameter_value
    FROM url_list
)

SELECT 
    request_id,
    url,
    COUNT(DISTINCT parameter_key) AS parameter_count
FROM url_parameters
GROUP BY 1, 2
ORDER BY 3 DESC, 2 ASC
