--Project 3
--Visualizing relationship between GDP Per capita and COVID metrics

SELECT *
FROM PortfolioProject3.dbo.covid_data

--select data to be used


SELECT continent,location,date, new_cases_per_million,new_deaths_per_million ,new_vaccinations_smoothed_per_million,gdp_per_capita
FROM PortfolioProject3.dbo.covid_data
WHERE gdp_per_capita IS NOT NULL AND  continent IS NOT NULL AND new_vaccinations_smoothed_per_million IS NOT NULL
ORDER BY 1


-------------------query for tableau, visualising new cases against gdp, by continent
SELECT continent,date, new_cases_per_million, gdp_per_capita
FROM PortfolioProject3.dbo.covid_data
WHERE continent IS NOT NULL AND date IS NOT NULL AND new_cases_per_million IS NOT NULL AND gdp_per_capita IS NOT NULL
ORDER BY 1,2

----------------------------------------query for tableau, visualising mortality rate against gdp

SELECT continent,date,(total_deaths_per_million/total_cases_per_million)*100 AS MortalityRate, gdp_per_capita
FROM PortfolioProject3.dbo.covid_data
WHERE gdp_per_capita IS NOT NULL AND  continent IS NOT NULL AND total_deaths_per_million IS NOT NULL
ORDER BY 1

-------------------query for tableau, visualising mortality rate against gdp, by continent
SELECT continent,date, gdp_per_capita, (total_deaths_per_million/total_cases_per_million)*100 AS MortalityRate
FROM PortfolioProject3.dbo.covid_data
WHERE gdp_per_capita IS NOT NULL AND  continent IS NOT NULL AND new_vaccinations_smoothed_per_million IS NOT NULL
ORDER BY 1