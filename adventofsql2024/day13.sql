WITH emails_expanded AS
(
    SELECT
        id,
        name,
        unnest(email_addresses) AS email
    FROM contact_list
),

domains AS
(
    SELECT
        SPLIT_PART(email, '@', 2) AS email_domain,
        COUNT(1) AS domain_count
    FROM emails_expanded
    GROUP BY 1
    ORDER BY 2 DESC
)

SELECT * FROM domains
