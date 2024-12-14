WITH cleaning_receipts AS
(
    SELECT
        record_id,
        record_date,
        jsonb_array_elements(cleaning_receipts)->>'drop_off' AS drop_off_date,
        jsonb_array_elements(cleaning_receipts)->>'color' AS item_color,
        jsonb_array_elements(cleaning_receipts)->>'garment' AS garment_type
    FROM santarecords
)

SELECT 
    *
FROM cleaning_receipts
WHERE item_color = 'green'
    AND garment_type = 'suit'
ORDER BY 3 DESC
