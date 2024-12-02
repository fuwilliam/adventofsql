--https://datalemur.com/questions/user-retention


WITH monthly_actions AS
(
  SELECT
    DATE_TRUNC('month', event_date) AS event_month,
    user_id,
    COUNT(event_id) AS interaction_count
  FROM user_actions
  WHERE event_type IN ('sign-in', 'like', 'comment')
  GROUP BY 1, 2
  HAVING COUNT(event_id) > 0
  ORDER BY 1, 2
),

previous_month_activity AS
(
  SELECT
    event_month,
    user_id,
    interaction_count,
    LAG(interaction_count) OVER 
      (PARTITION BY user_id ORDER BY event_month) AS last_month_interaction_count
  FROM monthly_actions
),

july_active_users AS 
(
  SELECT
    DATE_PART('month', event_month) AS month,
    COUNT(user_id) AS monthly_active_users
  FROM previous_month_activity
  WHERE event_month = '2022-07-01'
  AND interaction_count > 0
  AND last_month_interaction_count > 0
  GROUP BY 1
)

SELECT * FROM july_active_users;