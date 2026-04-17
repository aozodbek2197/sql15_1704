-- 1-mashq
SELECT DISTINCT s1.id, s1.visit_date, s1.people
FROM stadium s1
JOIN stadium s2 ON s1.id = s2.id - 1
JOIN stadium s3 ON s1.id = s3.id - 2
WHERE s1.people >= 100 AND s2.people >= 100 AND s3.people >= 100
ORDER BY s1.id;
-- 2-mashq
WITH daily AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(*) AS submissions
    FROM submissions
    GROUP BY submission_date, hacker_id
),
max_daily AS (
    SELECT 
        submission_date,
        hacker_id,
        submissions,
        RANK() OVER (PARTITION BY submission_date ORDER BY submissions DESC, hacker_id) AS rnk
    FROM daily
),
unique_hackers AS (
    SELECT 
        submission_date,
        COUNT(DISTINCT hacker_id) AS unique_count
    FROM submissions
    GROUP BY submission_date
)
SELECT 
    d.submission_date,
    u.unique_count,
    m.hacker_id,
    h.name
FROM (SELECT DISTINCT submission_date FROM submissions) d
JOIN unique_hackers u ON d.submission_date = u.submission_date
JOIN max_daily m ON d.submission_date = m.submission_date AND m.rnk = 1
JOIN hackers h ON m.hacker_id = h.hacker_id
ORDER BY d.submission_date;
