--https://datalemur.com/questions/total-utilization-time

WITH server_sessions AS
(
  SELECT
    server_id,
    session_status,
    status_time,
    LAG(status_time) OVER (PARTITION BY server_id ORDER BY status_time) AS last_status_time
  FROM server_utilization
),

server_uptime AS 
(
  SELECT 
    server_id,
    status_time,
    last_status_time,
    EXTRACT(EPOCH FROM (status_time - last_status_time)) AS session_uptime
  FROM server_sessions
  WHERE session_status = 'stop'
)

SELECT
  FLOOR(SUM(session_uptime) / (60*60*24)) AS total_uptime_days
FROM server_uptime