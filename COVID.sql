Select *
From PortfolioProject_1..CovidDeaths
Order by 3, 4

--Select Data that we are going to be using

Select location, date, population, total_cases, new_cases, total_deaths
From PortfolioProject_1..CovidDeaths
Where continent is not null
Order by 1, 2

-- Looking at the total cases vs total deaths

Select location, date, population, total_cases, total_deaths,
(CONVERT(float, total_deaths)/CONVERT(float, total_cases))*100 as deathPercentage
From PortfolioProject_1..CovidDeaths
Order by 1, 2

-- Shows the likelihood of dying if you contract covid in your country

Select location, date, population, total_cases, total_deaths,
(CONVERT(float, total_deaths)/CONVERT(float, total_cases))*100 as deathPercentage
From PortfolioProject_1..CovidDeaths
Where location Like '%nam'
Order by 1, 2

-- Looking at the total cases vs population

Select location, date, population, total_cases, (CONVERT(float, total_cases)/population)*100 as InfectionRate
From PortfolioProject_1..CovidDeaths
Where continent is not null
--where location like '%nam'
Order by 1, 2

-- Looking at the countries with the Highest Infection rate
Select location, population, MAX(CONVERT(int,total_cases)) as HighestInfectionCount, MAX(CONVERT(float, total_cases)/population)*100 as InfectionRate
From PortfolioProject_1..CovidDeaths
Where continent is not null
Group by location, population
Order by InfectionRate desc

-- Showing Countries with Highest Death Count per Population

Select location, MAX(CONVERT(int,total_deaths)) as HighestDeathCount
From PortfolioProject_1..CovidDeaths
Where continent is not null
Group by location
Order by HighestDeathCount desc

--showing the continent with the Highest death count per population

Select continent, MAX(CONVERT(int,total_deaths)) as HighestDeathCount
From PortfolioProject_1..CovidDeaths
Where continent is not null
Group by continent
Order by HighestDeathCount desc

--Showing the death count of Asia

Select location, MAX(CONVERT(int,total_deaths)) as HighestDeathCount
From PortfolioProject_1..CovidDeaths
Where continent is not null and
continent = 'Asia'
Group by location
Order by HighestDeathCount desc


--CONVERT VALUE OF new_deaths = null where new_Deaths = 0

UPDATE PortfolioProject_1..CovidDeaths
SET new_deaths = null
WHERE new_deaths = 0

--GLOBAL NUMBER
Select date, SUM(CONVERT(int,new_cases)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as float))/SUM(CONVERT(float,new_cases))*100 as DeathPercentage
From PortfolioProject_1..CovidDeaths
Where continent is not null
Group by date
Order by 1, 2

With PpvsVc (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(CONVERT(bigint, v.new_vaccinations)) OVER (Partition by d.location Order by d.date) 
as RollingPeopleVaccinated
From PortfolioProject_1..CovidDeaths d
Join PortfolioProject_1..CovidVaccinations v
on d.location = v.location 
and d.date = v.date
where d.continent is not null
--and d.location LIKE 'Vietnam'
)

Select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
From PpvsVc

USE PortfolioProject_1
GO
Create View PercentPopulationVaccinated1 as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(CONVERT(bigint, v.new_vaccinations)) OVER (Partition by d.location Order by d.date) 
as RollingPeopleVaccinated
From PortfolioProject_1..CovidDeaths d
Join PortfolioProject_1..CovidVaccinations v
on d.location = v.location 
and d.date = v.date
where d.continent is not null
--and d.location LIKE 'Vietnam'

Drop View if exists dbo.PercentPopulationVaccinated1

Select *
From PercentPopulationVaccinated1

