WITH song_plays AS
(
    SELECT
        user_plays.play_id,
        user_plays.song_id,
        songs.song_title,
        songs.song_duration,
        user_plays.duration AS play_duration,
        CASE 
            WHEN user_plays.duration >= songs.song_duration THEN 1 ELSE 0
        END AS song_played,
        CASE 
            WHEN user_plays.duration < songs.song_duration THEN 1 ELSE 0
        END AS song_skipped
    FROM user_plays
        LEFT JOIN songs USING(song_id)
    WHERE songs.song_duration IS NOT NULL
        AND user_plays.duration IS NOT NULL
)

SELECT
    song_id,
    song_title,
    SUM(song_played) AS total_plays,
    SUM(song_skipped) AS total_skips
FROM song_plays
GROUP BY 1, 2
ORDER BY 3 DESC, 4 ASC
