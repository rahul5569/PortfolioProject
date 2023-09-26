USE  [Portfolio Project]

-- Test if we are getting the data
Select * 
From CovidDeaths
Order By 3 

Select * 
From CovidVaccinations
Order By 3 

-- From here we start

-- Step 1 : We get the required data

Select Location,date,total_cases,new_cases,total_deaths,population 
From CovidDeaths
Order By 1,2 

-- Step 2 : Get the death rate 
Select Location,date,total_cases,total_deaths,((CONVERT(decimal(15,3),total_cases))/(CONVERT(decimal(15,3),total_deaths)))*100 as DeathRate 
From CovidDeaths
Order by 1,2

-- Here we can see that Afganistan didn't see any deaths until the 23rd march 2020 and hence the death rate is 0. 
-- Similarly we can see for other countries

-- For India
Select Location,date,total_deaths,total_cases,((CONVERT(decimal(15,2),total_deaths))/(CONVERT(decimal(15,2),total_cases)))*100 as DeathRate 
From CovidDeaths 
where location = 'India'
Order by 5 DESC

-- Step 3: Get Percent Infected
Select Location,date,total_cases,population,((CONVERT(decimal(15,2),total_cases))/(CONVERT(decimal(15,2),population)))*100 as PercentInfected 
From CovidDeaths 
Order by 1,2

-- For India
Select Location,date,total_cases,population,((CONVERT(decimal(15,2),total_cases))/(CONVERT(decimal(15,2),population)))*100 as PercentInfected 
From CovidDeaths
where location = 'India'
Order by 5 DESC

-- Step 4: The below query gets the max infected rate from all the countries against total popluation   
Select location,Min(date) as date,Min(total_deaths) as total_cases,Min(population) as population,
Max(((CONVERT(decimal(15,2),total_cases))/(CONVERT(decimal(15,2),population)))*100) as PopInfectionRate 
From CovidDeaths
GROUP BY location 
Order BY PopInfectionRate DESC

-- Using Partiion By and CTE
;WITH RankedData AS (
    SELECT location,date,total_cases,population,
        MAX(CONVERT(decimal(15,2), total_cases) / CONVERT(decimal(15,2), population) * 100) OVER (PARTITION BY location) AS PopInfectionRate,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY (CONVERT(decimal(15,2), total_cases) / CONVERT(decimal(15,2), population) * 100) DESC) AS RowNum
    FROM CovidDeaths
)
SELECT location,date,total_cases,population,PopInfectionRate
FROM RankedData
WHERE RowNum = 1
Order BY PopInfectionRate DESC


-- Step 5: The below query gets the max death rate from all the countries against total popluation
Select location,Min(date) as date,Min(total_deaths) as total_cases,Min(population) as population,Max(((CONVERT(decimal(15,2),total_deaths))/(CONVERT(decimal(15,2),population)))*100) as PopDeathRate 
From CovidDeaths
GROUP BY location
Order BY PopDeathRate DESC

-- Step 6: Max death count 
Select location,Max(cast(total_deaths as int)) as MaxDeaths  
From CovidDeaths
where continent is Not Null
Group By location
Order By MaxDeaths DESC

-- Step 7: Max death count by continent 
Select location,Max(cast(total_deaths as int)) as MaxDeaths  
From CovidDeaths
where continent is Null
Group By location
Order By MaxDeaths DESC

-- Step 8: Max death rate count by continent 
Select location,
Max(cast(total_deaths as int)) as MaxDeaths,
Max(((CONVERT(decimal(15,2),total_deaths))/(CONVERT(decimal(15,2),population)))*100) as MaxDeathRate  
From CovidDeaths
where continent is Null
Group By location
Order By MaxDeathRate DESC

-- Step 9: Death Rate across the world 
Select SUM(new_cases) as Total_Cases,SUM(CAST(new_deaths as int)) as Total_Deaths,SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as DeathRate    
From CovidDeaths
where continent is not null

-- Step 10 : Death rate for each year
Select YEAR(date) as Year, SUM(new_cases) as Total_Cases,SUM(CAST(new_deaths as int)) as Total_Deaths,SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as DeathRate    
From CovidDeaths
where continent is not null 
Group By YEAR(date)
Order By YEAR(date)


-- Step 11 : Get rolling vaccine count
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2

;With MaxPopVac AS(
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2
)Select location,max(population) as population, max(RollingPeopleVaccinated),Max(RollingPeopleVaccinated/population*100)
From MaxPopVac
Group By location
Order by 4 DESC


DROP View If exists PercentPopulationVaccinated
GO
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
