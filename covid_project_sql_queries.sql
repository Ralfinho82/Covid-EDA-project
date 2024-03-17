-- COVID DEATHS TABLE
-- First look at the relevant data 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths d
WHERE continent IS NOT NULL
ORDER BY 1, 2

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contracted covid in your country (death rate by case)
SELECT location, date, total_cases, total_deaths, ROUND(CAST(total_deaths AS Float) / total_cases * 100, 2) AS death_rate
FROM covid_deaths d
WHERE ROUND(CAST(total_deaths AS Float) / total_cases * 100, 2) IS NOT NULL
AND continent IS NOT NULL
ORDER BY 1, 2

-- Looking at total cases vs total deaths in Germany
-- Shows likelihood of dying by covid in Germany (death rate by case)
SELECT location, date, total_cases, total_deaths, ROUND(CAST(total_deaths AS Float) / total_cases * 100, 2) AS death_rate
FROM covid_deaths d
WHERE ROUND(CAST(total_deaths AS Float) / total_cases * 100, 2) IS NOT NULL 
AND location = 'Germany'
ORDER BY 1, 2

-- Looking at total cases vs population
-- Shows likelihood of covid contraction in Germany (contraction rate by population)
SELECT location, date, population, total_cases,  ROUND(CAST(total_cases AS Float) / population * 100, 2) AS contraction_rate
FROM covid_deaths d
WHERE ROUND(CAST(total_cases AS Float) / population * 100, 2) IS NOT NULL 
AND location = 'Germany'
ORDER BY 2

-- Looking at countries with highest contraction rate compared to population (contraction rate by population)
SELECT DISTINCT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) AS contraction_rate
FROM covid_deaths d
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 
ORDER BY 4 DESC

-- Looking at countries with highest death rate compared to population (death rate by population)
SELECT DISTINCT location, MAX (population) AS population, MAX (total_deaths) AS total_deaths,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) IS NOT NULL 
ORDER BY 4 DESC

-- Looking at countries with highest amounts of deaths (death rate by population)
SELECT DISTINCT location, MAX (population) AS population, MAX (total_deaths) AS total_deaths,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 
ORDER BY 3 DESC

-- View by continent
-- Looking at continents with highest contraction rate compared to population (contraction rate by population)
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) AS contraction_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location NOT LIKE '%income'
AND location NOT LIKE '%Union'
AND location NOT LIKE 'World'
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 
ORDER BY 4 DESC

-- Looking at continents with highest death rate compared to population (death rate by population)
SELECT location, MAX (population) AS population, MAX (total_deaths) AS total_deaths,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location NOT LIKE '%income'
AND location NOT LIKE '%Union'
AND location NOT LIKE 'World'
GROUP BY location
HAVING MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) IS NOT NULL 
ORDER BY 4 DESC


-- View by income rates
-- Looking at income rates with highest contraction rate compared to population (contraction rate by population)
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) AS contraction_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location LIKE '%income'
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 
ORDER BY 4 DESC

-- Looking at income rates with highest death rate compared to population
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location LIKE '%income'
GROUP BY location
HAVING MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) IS NOT NULL 
ORDER BY 4 DESC


-- Worldwide view 
-- Looking at contraction rate compared to worldwide population (contraction rate by population)
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) AS contraction_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location LIKE 'World'
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 
ORDER BY 4 DESC

-- Looking at death rate compared to worldwide population (death rate by population)
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location LIKE 'World'
GROUP BY location
HAVING MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) IS NOT NULL 
ORDER BY 4 DESC


-- JOINING COVID DEATHS & COVID VACCINATIONS TABLE
-- Looking at total population and vaccinations in every country
SELECT d.continent, d. location, d.date, d.population, v.new_vaccinations
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL
ORDER BY 1, 2, 3

-- Showing increasing total number of vaccinations in every country
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL
ORDER BY 1, 2, 3

-- Showing increasing total number of vaccinations in Germany
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL
AND d.location = 'Germany'
ORDER BY 1, 2, 3

-- Showing percentage of vaccinated population in every country
-- USE CTE
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, new_vaccinations_total)
AS
(
SELECT d.continent, d.location, d.date, d.population, CAST (v.new_vaccinations AS Float), SUM(CAST(v.new_vaccinations AS Float)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL
)
SELECT *, ROUND((new_vaccinations_total / population)* 100, 2) AS percentage_vaccinated
FROM pop_vs_vac

--- Showing percentage of vaccinated population in Germany
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, new_vaccinations_total)
AS
(
SELECT d.continent, d.location, d.date, d.population, CAST (v.new_vaccinations AS Float), SUM(CAST(v.new_vaccinations AS Float)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL
AND d.location = 'Germany'
)
SELECT *, ROUND((new_vaccinations_total / population)* 100, 2) AS percentage_vaccinated
FROM pop_vs_vac

-- Showing percentage of vaccinated population in every country
-- USE TEMP TABLE
DROP TABLE IF EXISTS percent_pop_vaccinated
CREATE TABLE percent_pop_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date date,
population numeric,
new_vaccinations numeric,
new_vaccinations_total numeric
)

INSERT INTO percent_pop_vaccinated
SELECT d.continent, d.location, d.date, d.population, CAST (v.new_vaccinations AS Float), SUM(CAST(v.new_vaccinations AS Float)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL

SELECT *, FORMAT(ROUND((new_vaccinations_total / population) * 100, 2), 'N2') AS percentage_vaccinated
FROM percent_pop_vaccinated


-- CREATE VIEWS to store data for visualizations in Power BI
CREATE VIEW view_percent_pop_vaccinated AS
SELECT d.continent, d.location, d.date, d.population, CAST (v.new_vaccinations AS Float) AS new_vaccinations, SUM(CAST(v.new_vaccinations AS Float)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contracted covid in your country (death rate by case)
CREATE VIEW view_death_rate_by_case AS
SELECT location, date, total_cases, total_deaths, ROUND(CAST(total_deaths AS Float) / total_cases * 100, 2) AS death_rate
FROM covid_deaths d
WHERE ROUND(CAST(total_deaths AS Float) / total_cases * 100, 2) IS NOT NULL
AND continent IS NOT NULL

-- Looking at total cases vs total deaths in Germany
-- Shows likelihood of dying by covid in Germany (death rate by case)
CREATE VIEW view_death_rate_by_case_germany AS
SELECT location, date, total_cases, total_deaths, ROUND(CAST(total_deaths AS Float) / total_cases * 100, 2) AS death_rate
FROM covid_deaths d
WHERE ROUND(CAST(total_deaths AS Float) / total_cases * 100, 2) IS NOT NULL 
AND location = 'Germany'

-- Looking at total cases vs population
-- Shows likelihood of covid contraction in Germany (contraction rate by population)
CREATE VIEW covid_contraction_germany AS
SELECT location, date, population, total_cases,  ROUND(CAST(total_cases AS Float) / population * 100, 2) AS contraction_rate
FROM covid_deaths d
WHERE ROUND(CAST(total_cases AS Float) / population * 100, 2) IS NOT NULL 
AND location = 'Germany'

-- Looking at countries with highest contraction rate compared to population (contraction rate by population)
CREATE VIEW covid_contraction_all_counries AS
SELECT DISTINCT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) AS contraction_rate
FROM covid_deaths d
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 

-- Looking at countries with highest death rate compared to population (death rate by population)
CREATE VIEW covid_deaths_all_counries AS
SELECT DISTINCT location, MAX (population) AS population, MAX (total_deaths) AS total_deaths,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) IS NOT NULL 

-- Looking at countries with highest amounts of deaths (death rate by population)
CREATE VIEW highest_amount_covid_deaths_all_counries AS
SELECT DISTINCT location, MAX (population) AS population, MAX (total_deaths) AS total_deaths,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 

-- View by continent
-- Looking at continents with highest contraction rate compared to population (contraction rate by population)
CREATE VIEW continents_highest_contraction_rate_by_population AS
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) AS contraction_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location NOT LIKE '%income'
AND location NOT LIKE '%Union'
AND location NOT LIKE 'World'
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 

-- Looking at continents with highest death rate compared to population (death rate by population)
CREATE VIEW continents_highest_death_rate_by_population AS
SELECT location, MAX (population) AS population, MAX (total_deaths) AS total_deaths,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location NOT LIKE '%income'
AND location NOT LIKE '%Union'
AND location NOT LIKE 'World'
GROUP BY location
HAVING MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) IS NOT NULL 


-- View by income rates
-- Looking at income rates with highest contraction rate compared to population (contraction rate by population)
CREATE VIEW highest_contraction_rate_by_income_rate AS
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) AS contraction_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location LIKE '%income'
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 

-- Looking at income rates with highest death rate compared to population
CREATE VIEW highest_death_rate_by_income_rate AS
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location LIKE '%income'
GROUP BY location
HAVING MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) IS NOT NULL 


-- Worldwide view 
-- Looking at contraction rate compared to worldwide population (contraction rate by population)
CREATE VIEW contraction_rate_to_worldwide_population AS
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) AS contraction_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location LIKE 'World'
GROUP BY location
HAVING MAX (ROUND(CAST(total_cases AS Float) / population * 100, 2)) IS NOT NULL 

-- Looking at death rate compared to worldwide population (death rate by population)
CREATE VIEW death_rate_to_worldwide_population AS
SELECT location, MAX (population) AS population, MAX (total_cases) AS total_cases,  MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) AS death_rate
FROM covid_deaths d
WHERE continent IS NULL
AND location LIKE 'World'
GROUP BY location
HAVING MAX (ROUND(CAST(total_deaths AS Float) / population * 100, 2)) IS NOT NULL 


-- COVID DEATHS & COVID VACCINATIONS TABLE
-- Looking at total population and vaccinations in every country
CREATE VIEW total_population_and_vaccination_every_country AS
SELECT d.continent, d. location, d.date, d.population, v.new_vaccinations
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL

-- Showing increasing total number of vaccinations in every country
CREATE VIEW increasing_number_of_vaccinations_every_country AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL

-- Showing increasing total number of vaccinations in Germany
CREATE VIEW increasing_number_of_vaccinations_germany AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL
AND d.location = 'Germany'

-- Showing percentage of vaccinated population in every country
-- USE CTE
CREATE VIEW percentage_vaccinating_population_every_country AS
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, new_vaccinations_total)
AS
(
SELECT d.continent, d.location, d.date, d.population, CAST (v.new_vaccinations AS Float), SUM(CAST(v.new_vaccinations AS Float)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL
)
SELECT *, ROUND((new_vaccinations_total / population)* 100, 2) AS percentage_vaccinated
FROM pop_vs_vac

--- Showing percentage of vaccinated population in Germany
CREATE VIEW percentage_vaccinating_population_germany AS
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, new_vaccinations_total)
AS
(
SELECT d.continent, d.location, d.date, d.population, CAST (v.new_vaccinations AS Float), SUM(CAST(v.new_vaccinations AS Float)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL
AND d.location = 'Germany'
)
SELECT *, ROUND((new_vaccinations_total / population)* 100, 2) AS percentage_vaccinated
FROM pop_vs_vac

-- Showing percentage of vaccinated population in every country
-- USE TEMP TABLE

DROP TABLE IF EXISTS percent_pop_vaccinated
CREATE TABLE percent_pop_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date date,
population numeric,
new_vaccinations numeric,
new_vaccinations_total numeric
)

INSERT INTO percent_pop_vaccinated
SELECT d.continent, d.location, d.date, d.population, CAST (v.new_vaccinations AS Float), SUM(CAST(v.new_vaccinations AS Float)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS new_vaccinations_total
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND v.new_vaccinations IS NOT NULL

SELECT *, FORMAT(ROUND((new_vaccinations_total / population) * 100, 2), 'N2') AS percentage_vaccinated
FROM percent_pop_vaccinated

