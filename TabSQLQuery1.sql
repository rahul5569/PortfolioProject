USE [Portfolio Project]

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income','Low income')
Group by location
order by TotalDeathCount desc

-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

Select date, SUM(new_cases) as Total_Cases,SUM(CAST(new_deaths as int)) as Total_Deaths,SUM(CAST(new_deaths as int))/NULLIF(SUM(new_cases),0) * 100 as DeathRate    
From CovidDeaths
where continent is not null 
Group By date
Order By date

Select date,location, SUM(new_cases) as Total_Cases,SUM(CAST(new_deaths as int)) as Total_Deaths,SUM(CAST(new_deaths as int))/NULLIF(SUM(new_cases),0) * 100 as DeathRate    
From CovidDeaths
where continent is not null 
Group By location,date
Order By location,date

Select date,continent,location, SUM(new_cases) as Total_Cases,SUM(CAST(new_deaths as int)) as Total_Deaths,SUM(CAST(new_deaths as int))/NULLIF(SUM(new_cases),0) * 100 as DeathRate    
From CovidDeaths
where continent is not null 
Group By continent,date,location
Order By continent,date,location

