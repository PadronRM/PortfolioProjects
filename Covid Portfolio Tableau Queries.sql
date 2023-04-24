/*
Queries used for Tableau Project
https://public.tableau.com/app/profile/justin.nelson1894/viz/PortfolioCovidDashboard_16823188965790/Dashboard1?publish=yes
*/



-- 1. 
--This query is designed to find the total of total worldwide covid cases, total deaths from covid, and the percent of the world's populatin that died due to covid.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null --This dataset includes continent specific data. We only want country based data. We filter out continent data with a not null function.
order by total_cases, total_deaths


-- 1. (cont) The data set includes a "world" value. This provides the same output as the query above. Personal preference of which to use. 
--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From covidDeaths
--where location = 'World'
--order by 1,2


-- 2. 
-- This query is used to find the total amount of deaths due to Covid grouped by Continent. 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.
-- This query is used to find which locations had the highest amount of Covid infections and the percent of their population that was infected.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.
-- This query is similar to the one above. However, we are tracking which country had the highest infection count for a given date.

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc









