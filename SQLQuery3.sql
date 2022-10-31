SELECT *
FROM PortfolioProject1..CovidDeaths
ORDER BY 3,4

SELECT *
FROM PortfolioProject1..CovidVaccinations
ORDER BY 3,4

--Select Data we are going to be using

SELECT location,date,total_cases,new_cases,total_deaths, population
FROM PortfolioProject1..CovidDeaths
ORDER BY 1,2


--Looking at total cases vs total deaths(Mortality Rate)
--Shows likelihood of dying if you contract covid by country
SELECT location,date,total_cases,total_deaths, ROUND((total_deaths/total_cases)*100,2) AS 'Mortality Rate(%)'
FROM PortfolioProject1..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

--looking at total cases vs population
--shows what population contracted covid
SELECT location,date,total_cases,population, ROUND((total_cases/population)*100,2) AS PercentPopulationInfected
FROM PortfolioProject1..CovidDeaths
--WHERE location like '%states%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) as 'Highest Count',ROUND(MAX((total_cases/population)*100),2) AS PercentPopulationInfected
FROM PortfolioProject1..CovidDeaths
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--Show countries with highest death count
SELECT location, MAX(CAST(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject1..CovidDeaths
GROUP BY location
ORDER BY HighestDeathCount DESC

--Show countries with highest death count per population

SELECT location, ROUND(MAX((total_deaths/population*100)),2) AS PercentPopulationDeath
FROM PortfolioProject1..CovidDeaths
GROUP BY location
ORDER BY PercentPopulationDeath DESC

--Breaking things down by continent
--Continents with highest death count 
SELECT continent, MAX(CAST(Total_deaths as int)) as  TotalDeathCount
FROM PortfolioProject1..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


--Global numbers

--Global Death Percentage by date
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject1..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--
--Global Death Percentage
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject1..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Joining CovidDeaths and CovidVaccinations via inner join on location
SELECT *
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

--



--USE CTE

WITH PopvsVac (continent, location, date, population, New_Vaccinations, RollingCountofVaccinations)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingCountofVaccinations
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)

SELECT *, (RollingCountofVaccinations/population) AS PercentageofVaccinated
from PopvsVac

--Create Temp Table
 
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
CREATE VIEW	PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingCountofVaccinations
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL


SELECT *
FROM PercentPopulationVaccinated