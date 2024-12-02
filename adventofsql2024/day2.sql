
WITH letters_unioned AS
(
    SELECT
        id,
        'a' AS source_letter,
        value AS ascii_code,
        chr(value) AS ascii_character
    FROM letters_a

    UNION ALL

    SELECT
        id,
        'b' AS source_letter,
        value AS ascii_code,
        chr(value) AS ascii_character
    FROM letters_b  
),

cleaned_letters AS
(
    SELECT
        id,
        source_letter,
        ascii_code,
        ascii_character
    FROM letters_unioned
    WHERE
        --regex like matching instead of fiddling with code ranges
        ascii_character ~ '[A-Za-z0-9\s!,.]' 
    ORDER BY id
),

final_phrase AS
(
    SELECT
        STRING_AGG(ascii_character, '') AS decoded_message
    FROM cleaned_letters
)

SELECT * FROM final_phrase


