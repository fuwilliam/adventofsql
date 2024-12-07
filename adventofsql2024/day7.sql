WITH 
elf_experience AS
(
    SELECT
        elf_id,
        primary_skill,
        years_experience,
        RANK() OVER (PARTITION BY primary_skill ORDER BY years_experience DESC, elf_id ASC) AS skill_rank_most,
        RANK() OVER (PARTITION BY primary_skill ORDER BY years_experience ASC, elf_id ASC) AS skill_rank_least
    FROM workshop_elves   
),

elf_pairs AS
(
    SELECT
        most.elf_id AS elf_id_1,
        least.elf_id AS elf_id_2,
        most.primary_skill AS shared_skill,
        most.years_experience,
        least.years_experience
    FROM elf_experience most
    INNER JOIN elf_experience least
        ON most.primary_skill = least.primary_skill
    WHERE most.skill_rank_most = 1
        AND least.skill_rank_least = 1
)

SELECT 
    elf_id_1,
    elf_id_2,
    shared_skill
FROM elf_pairs
ORDER BY shared_skill