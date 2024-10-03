/*
Script Name: Covid 19 Data Exploration 
Date Created: 09 September 2024
Last Modified: 03 October 2024
Description: Data Exploration using SQL guided by Alex the Analyst.
				This script explores a dataset, performing data analysis 
				operations such as filtering, grouping, and ordering to identify insights. 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, 
				Creating Views, Converting Data Types
Parameters:
	Start Date: 01 January 2020
	End Date: 30 April 2021
Relevant links:
	a. Reference: 
		Data Analyst Portfolio Project | SQL Data Exploration | Project 1/4: https://www.youtube.com/watch?v=qfyynHBFOsM&list=PLUaB-1hjhk8H48Pj32z4GZgGWyylqv85f
	b. Data: 
		CovidDeaths: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/CovidDeaths.xlsx
		CovidVaccinations: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/CovidVaccinations.xlsx

*/


Select *
From PortfolioProject..CovidDeaths
where continent is not NULL
order by 3,4  /*refers to ordering the results based on the third and fourth columns in the SELECT clause*/

Select *
From PortfolioProject..CovidVaccinations
where continent is not NULL
order by 3,4


-- Select Data that we are going to e used
Select Location, date, total_cases, 
		new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not NULL
order by 1,2


-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in you country
Select Location, date, total_cases, total_deaths,
		(total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
where location like '%states%'-- interested in the United States
order by 1,2


-- Total Cases vs Population
-- Shows the percentage of population got Covid
Select Location, date, population, total_cases, 
		(total_cases/ population)*100 as PercentPopulationInfected 
from PortfolioProject..CovidDeaths
-- where location like '%states%'
where continent is not NULL
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population
Select Location, population, Max(total_cases) as HighestInfectionCount, 
		Max((total_cases/ population))*100 as PercentPopulationInfected 
from PortfolioProject..CovidDeaths
where continent is not NULL
group by Location, population
order by PercentPopulationInfected desc


-- Showing countries with highest death count per population
Select Location, Max(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not NULL
group by Location
order by TotalDeathCount desc

-- By continent
Select continent, Max(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not NULL
group by continent
order by TotalDeathCount desc


--Select location, Max(total_deaths) as TotalDeathCount
--from PortfolioProject..CovidDeaths
--where continent is NULL
--group by location
--order by TotalDeathCount desc

-- Showing continents with highest death count per population
Select continent, Max(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not NULL
group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select --date, 
		SUM(new_cases) as total_cases, 
		SUM(new_deaths) as total_deaths, 
		SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
-- Group By date -- per day
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
		, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.date) as RollingPeopleVaccinated 
		--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date
				, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


