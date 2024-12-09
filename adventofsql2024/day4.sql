WITH toy_tag_comparison AS
(
    SELECT
        toy_id,
        toy_name,

        ARRAY(
            SELECT UNNEST(previous_tags) 
            INTERSECT 
            SELECT UNNEST(new_tags)
        ) AS unchanged_tags,

        ARRAY(
            SELECT UNNEST(previous_tags) 
            EXCEPT 
            SELECT UNNEST(new_tags)
        ) AS removed_tags,

        ARRAY(
            SELECT UNNEST(new_tags) 
            EXCEPT 
            SELECT UNNEST(previous_tags)
        ) AS added_tags 
    FROM public.toy_production
),

toy_tag_change_count AS
(
    SELECT
        toy_id,
        toy_name,
        CARDINALITY(added_tags) AS added_tag_count,
        CARDINALITY(unchanged_tags) AS unchanged_tag_count,
        CARDINALITY(removed_tags) AS removed_tag_count
    FROM toy_tag_comparison
)

SELECT * FROM toy_tag_change_count
ORDER BY 3 DESC