WITH workshop_timezones AS
(
    SELECT
        workshop_id,
        (('2024-01-01'::DATE + business_start_time::TIME) AT TIME ZONE timezone AT TIME ZONE 'UTC')::TIME AS utc_start_time,
        (('2024-01-01'::DATE + business_end_time::TIME) AT TIME ZONE timezone AT TIME ZONE 'UTC')::TIME AS utc_end_time
    FROM workshops
),

meeting_times AS
(
    SELECT
        MAX(utc_start_time) AS utc_earliest_start_time,
        MIN(utc_end_time) - INTERVAL '1 hour' AS utc_latest_start_time
    FROM workshop_timezones
),

time_slots AS 
(
    SELECT 
        time_slot::TIME AS slot
    FROM GENERATE_SERIES(
        '2024-01-01 00:00:00'::TIMESTAMP,
        '2024-01-01 23:30:00'::TIMESTAMP,
        '30 minutes'::INTERVAL
    ) AS time_slot
)
--there is no timeslot that meets the criteria
SELECT 
    slot,
    utc_earliest_start_time,
    utc_latest_start_time
FROM time_slots
CROSS JOIN meeting_times
WHERE slot >= utc_earliest_start_time
AND slot <= utc_latest_start_time
