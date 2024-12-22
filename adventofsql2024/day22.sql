WITH elf_skills AS
(
    SELECT
        id,
        elf_name,
        UNNEST(STRING_TO_ARRAY(skills, ',')) AS skill
    FROM elves
)

SELECT
    COUNT(DISTINCT id) AS elf_count_with_sql
FROM elf_skills
WHERE skill = 'SQL'
