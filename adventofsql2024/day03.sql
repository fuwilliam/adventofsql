
WITH menu_guest_count AS
(
    SELECT
        id AS event_id,
        menu_data,
        (xpath('/polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()', menu_data))[1]::text AS attendance_count_pc,
        (xpath('/christmas_feast/organizational_details/attendance_record/total_guests/text()', menu_data))[1]::text AS attendance_count_cf,
        (xpath('/northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', menu_data))[1]::text AS attendance_count_nd
    FROM public.christmas_menus
),

filtered_guest_count AS
(
    SELECT
        event_id,
        COALESCE(attendance_count_pc, attendance_count_cf, attendance_count_nd)::int AS attendance_count,
        menu_data
    FROM menu_guest_count
    WHERE COALESCE(attendance_count_pc, attendance_count_cf, attendance_count_nd)::int > 78
),

menu_dish_arrays AS
(
    SELECT
        event_id,
        xpath('/polar_celebration/event_administration/culinary_records/culinary_records/item_performance/food_item_id/text()', menu_data) AS dish_array_pc,
        xpath('/christmas_feast/organizational_details/menu_registry/course_details/dish_entry/food_item_id/text()', menu_data) AS dish_array_cf,
        xpath('/northpole_database/annual_celebration/event_metadata/menu_items/food_category/food_category/dish/food_item_id/text()', menu_data) AS dish_array_nd
    FROM filtered_guest_count
),

menu_all_dishes AS
(
    SELECT
        event_id,
        unnest(dish_array_pc || dish_array_cf || dish_array_nd)::text AS dish_id
    FROM menu_dish_arrays
)

SELECT
    dish_id,
    COUNT(1) AS dish_count
FROM menu_all_dishes
GROUP BY 1
ORDER BY 2 DESC
