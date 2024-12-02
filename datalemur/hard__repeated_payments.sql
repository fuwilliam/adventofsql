--https://datalemur.com/questions/repeated-payments

WITH last_transactions AS
(
  SELECT
    transaction_id,
    merchant_id,
    credit_card_id,
    amount,
    transaction_timestamp,
    LAG(transaction_timestamp) 
      OVER (PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) 
    AS last_transaction_timestamp
  FROM transactions
),

repeated_payments AS
(
  SELECT 
    transaction_id,
    merchant_id,
    credit_card_id,
    amount,
    transaction_timestamp,
    EXTRACT(MINUTE FROM AGE(transaction_timestamp, last_transaction_timestamp)) AS minutes_since_last
  FROM last_transactions
)

SELECT
  COUNT(1) AS payment_count
FROM repeated_payments
WHERE minutes_since_last < 10