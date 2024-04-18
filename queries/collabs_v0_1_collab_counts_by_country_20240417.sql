WITH
unn AS (
  SELECT *
  FROM `academic-observatory.observatory.doi20240310`, UNNEST(affiliations.countries) as countries
  WHERE crossref.published_year < 2024 AND crossref.published_year > 2009
),
crossed AS (
SELECT  a.crossref.published_year, a.doi, a.openalex.sustainable_development_goals, a.country_code as country_a, b.country_code as country_b
FROM unn as a
JOIN unn as b
on a.doi = b.doi
ORDER by a.doi ASC
)
SELECT
  published_year,
  sdg.display_name,
  country_a,
  country_b,
  COUNT(DISTINCT(doi)) as cnt
FROM crossed, UNNEST(sustainable_development_goals) as sdg
GROUP BY published_year, sdg.display_name, country_a, country_b
ORDER BY published_year DESC, country_a ASC, country_b ASC