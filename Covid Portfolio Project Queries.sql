--Ensuring both tables were successfully uploaded into SQL Server
 Select * 
 From CovidDeaths
 Order by 3,4

  Select * 
 From CovidVaccinations
 Order by 3,4

------

--Starting Query for Covid Deaths table
Select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
Order by location,date


-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract COVID in your country. This example using the United States
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
From CovidDeaths
Where location like '%United States%'
Order by location,date


-- Looking at Total Cases vs Population
-- Shows what percentage of population contracted COVID
Select location, date, total_cases, population, (total_cases/population) * 100 AS PercentPopulationInfected
From CovidDeaths
Order by location,date



--Inquire which countries has the highest infection rate compared to population
Select location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 AS PercentPopulationInfected 
From CovidDeaths
GROUP by location,population
Order by PercentPopulationInfected desc


--Show countries with the highest death count per their population
Select location, MAX(CAST(total_deaths as bigint)) AS HighestDeathCount --Total deaths is a nvarchar data type. We need to cast it as a int or bigint. I used bigint due to the size of the data.
From CovidDeaths
WHERE continent IS NOT NULL -- Dataset lists continents and countries as a location. We only want to view countries and not entire continents. To do this, we filter out the continent only data via a NOT NULL function
GROUP by location
Order by HighestDeathCount desc


--
-- Now Breaking things down by continent
--

--Same query as above but we are trying to find highest death count by continent
Select continent, MAX(CAST(total_deaths as bigint)) AS HighestDeathCount
From CovidDeaths
WHERE continent IS NOT NULL
GROUP by continent
Order by HighestDeathCount desc


--Showing continents with the highest infection count and the percent of population that has been infected by COVID
Select continent, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 AS PercentPopulationInfected 
From CovidDeaths
WHERE continent IS NOT NULL
GROUP by continent
Order by PercentPopulationInfected desc

--Continents with the highest death count after contracting covid
Select continent, MAX(CAST(total_deaths as bigint)) AS HighestDeathCount
From CovidDeaths
WHERE continent IS NOT NULL
GROUP by continent
Order by HighestDeathCount desc




--
-- Global Numbers
--

--Calculating Total worldwide cases, total worldwide deaths, and global death percentage. This is grouped by date and shows the respective data for each day throughout the world.
Select date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths as BIGINT)) AS TotalDeaths, SUM(CAST(new_deaths as BIGINT))/SUM(new_cases)*100 as GlobalDeathPercentage
From CovidDeaths
Where continent IS NOT NULL
Group by date
Order by 1,2







-- Joining our two tables through location and date. 
-- Use this JOIN function to analyze Total Population vs Vaccinations for given dates & locations.
Select *
From CovidDeaths as dea
JOIN CovidVaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date


--This query utilizes the join function to find the total amount of new vaccinations and keeping a rolling count of these vaccinations by location. We use the Partition function to make sure the rolling count resets after each location in the dataset.
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingTotalVaccinations
From CovidDeaths as dea
JOIN CovidVaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date
Where dea.continent IS NOT NULL
Order by dea.location, dea.date



--Use a Common table expression (CTE) so we can create a new variable and also use a calculation with the new variable. This new variable finds the percentage of rolling total of vacinations by a location's population.
With PopulationVsVac (continent, location, date, population, new_vaccinations, RollingTotalVaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingTotalVaccinations
From CovidDeaths as dea
JOIN CovidVaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date
Where dea.continent IS NOT NULL
)
Select *, (RollingTotalVaccinations/population)*100 as RollingTotalVaccinatedPerPopulation
From PopulationVsVac



--This query accomplishes the same goal as the one above. However, instead of using a CTE we use a create table function
DROP Table IF EXISTS #PercentPopulationVaccinated --Drop table function in case I ran this query prior. This will drop the previously created table if it exists to avoid any error.
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_Vaccinations numeric,
RollingTotalVaccinations numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingTotalVaccinations
From CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
Where dea.continent IS NOT NULL

Select *, (RollingTotalVaccinations/population)*100 as RollingTotalVaccinatedPerPopulation
From #PercentPopulationVaccinated




--Creating View to store data for later visualizations


Create View PercentPeopleVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingTotalVaccinations
From CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent IS NOT NULL

Select * 
From PercentPeopleVaccinated