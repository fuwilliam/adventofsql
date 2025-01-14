WITH advertiser_payments AS (
    SELECT
        advertiser.status,
        COALESCE(advertiser.user_id, daily_pay.user_id) AS user_id,
        COALESCE(daily_pay.paid, 0) AS paid_amount
    FROM advertiser
    FULL JOIN daily_pay ON advertiser.user_id = daily_pay.user_id
),

advertiser_new_status AS (
    SELECT
        user_id,
        paid_amount,
        status AS old_status,
        CASE
            WHEN paid_amount = 0
                THEN 'CHURN'
            WHEN paid_amount > 0 AND status IN ('NEW', 'EXISTING', 'RESURRECT')
                THEN 'EXISTING'
            WHEN paid_amount > 0 AND status = 'CHURN'
                THEN 'RESURRECT'
            WHEN paid_amount > 0 AND status IS NULL
                THEN 'NEW'
        END AS new_status
    FROM advertiser_payments
)

SELECT
    user_id,
    new_status
FROM advertiser_new_status
ORDER BY 1;
