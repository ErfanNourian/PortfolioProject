/*
Testing my sql and git skills
*/

-- Create database then import tables

Create Database PortfolioProject


-- Looking at CovidDeaths table

Select *
From PortfolioProject..CovidDeaths

Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4


-- Selecting my desire data

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


-- Most deaths by country

Select location, SUM(CAST(total_deaths As numeric)) As TotalDeaths
From PortfolioProject..CovidDeaths
Where continent is not Null
Group By location
Order By 2 DESC


-- Most deaths by continent

Select continent, SUM(CAST(total_deaths As numeric)) As TotalDeaths
From PortfolioProject..CovidDeaths
Where continent is not Null
Group By continent
Order By 2 DESC


-- Most cases by country

Select location, SUM(new_cases) As TotalCases
From PortfolioProject..CovidDeaths
Where continent is not Null
Group By location
Order By 2 DESC


-- Most cases by continent

Select continent, SUM(new_cases) As TotalCases
From PortfolioProject..CovidDeaths
Where continent is not Null
Group By continent
Order By 2 DESC


-- showing daily DeathPercentage in canada

Select date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%canada%'
and continent is not null
order by 1,2


-- showing the highest DeathPercentage in countries

WITH CTE_MaxDeathPer as 
(
SELECT [location],MAX(total_deaths) as T_deaths, MAX(total_cases) as T_cases
FROM PortfolioProject..CovidDeaths
WHERE [continent] is not null 
GROUP BY [location]
)

SELECT CTE_MaxDeathPer.[location], CTE_MaxDeathPer.T_deaths/CTE_MaxDeathPer.T_cases*100
FROM CTE_MaxDeathPer
GROUP BY [location],CTE_MaxDeathPer.T_deaths,CTE_MaxDeathPer.T_cases
ORDER BY 2 DESC


-- Highest rate of infection compare to population

Select location, population, Max(total_cases) as MaxTotalCases, MAX((total_cases/population))*100 as InfectedPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
group by location, population
order by InfectedPercentage desc


-- Highest rate of death compare to countries population

Select location, population, Max(total_deaths/population)*100 as DeathPerPopulation
From PortfolioProject..CovidDeaths
Where continent is not null
group by location, population
order by DeathPerPopulation desc


-- Highest rate of death compare to continents population

Select location, population, Max(total_deaths/population)*100 as DeathPerPopulation
From PortfolioProject..CovidDeaths
Where continent is null
and [location] not LIKE '%world%'
and [location] not LIKE '%international%'
and [location] not LIKE '%european union%'
group by location, population
order by DeathPerPopulation desc


-- Global Number

Select Sum(new_cases) as SumNewCases, Sum(Cast(new_deaths as int)) as SumNewDeaths, Sum(Cast(new_deaths as int))/Sum(new_cases)*100 as GlobalNumber
From PortfolioProject..CovidDeaths
Where continent is not null
order by GlobalNumber desc


-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.location, population ,Sum(Cast(vac.new_vaccinations as int)) as SumNewVac, Sum(Cast(vac.new_vaccinations as int))/population*100 as PercentageOfVaccination
From PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
group by dea.location, population
order by SumNewVac desc


-- deaths in each day in the world
Select SUM(CAST(new_deaths as int)) As SumOfDeaths, date
From PortfolioProject..CovidDeaths
where continent is not null
Group By date
Order By SumOfDeaths desc

