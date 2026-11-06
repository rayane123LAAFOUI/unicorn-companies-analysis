-- 1. Identify the top 3 industries between 2019 and 2021

WITH top_industries AS (
    SELECT
        i.industry,
        COUNT(DISTINCT i.company_id) AS total_unicorns
    FROM industries AS i
    INNER JOIN dates AS d
        ON i.company_id = d.company_id
    WHERE EXTRACT(YEAR FROM d.date_joined)
          IN (2019, 2020, 2021)
    GROUP BY i.industry
    ORDER BY total_unicorns DESC
    LIMIT 3
),

-- 2. Calculate yearly statistics for each industry

yearly_rankings AS (
    SELECT
        i.industry,
        EXTRACT(YEAR FROM d.date_joined)::INT AS year,
        COUNT(DISTINCT i.company_id) AS num_unicorns,
        AVG(f.valuation) AS average_valuation
    FROM industries AS i
    INNER JOIN dates AS d
        ON i.company_id = d.company_id
    INNER JOIN funding AS f
        ON i.company_id = f.company_id
    WHERE EXTRACT(YEAR FROM d.date_joined)
          IN (2019, 2020, 2021)
    GROUP BY
        i.industry,
        EXTRACT(YEAR FROM d.date_joined)
)

-- 3. Final results

SELECT
    yr.industry,
    yr.year,
    yr.num_unicorns,
    ROUND(
        yr.average_valuation / 1000000000.0,
        2
    ) AS average_valuation_billions
FROM yearly_rankings AS yr
INNER JOIN top_industries AS ti
    ON yr.industry = ti.industry
ORDER BY
    yr.year DESC,
    yr.num_unicorns DESC;
