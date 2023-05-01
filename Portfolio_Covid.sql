USE PortfolioProject;


SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4;


--SELECT *
--FROM PortfolioProject..CovidVaccinations
--order by 3,4;


--Seleccionamos los datos que vamos a utilizar
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2;

-- Analizando el total de casos frente vs total de muertes
-- Muestra la probabilidad de morir si contrae covid en su país
SELECT location, date, total_cases, total_deaths, 
       (CASE WHEN TRY_CONVERT(float,total_cases) = 0 THEN 0 ELSE (total_deaths/TRY_CONVERT(float,total_cases)) END)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%Argentina%'
and continent is not null
ORDER BY 1,2;


--El total de casos vs a la población
--Muestra qué porcentaje de la población contrajo covid en todo el planeta
SELECT location, date,population,  total_cases, 
       CASE WHEN TRY_CONVERT(float,total_cases) = 0 THEN 0 ELSE (total_cases/TRY_CONVERT(float,population))*100 END AS Population_Percentage
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%Argentina%'
ORDER BY 1,2;


--Observando los países con la tasa de infección más alta en comparación con la población
SELECT location,population,  MAX(total_cases) AS HighestInfectionCount, 
       MAX(CASE WHEN TRY_CONVERT(float,total_cases) = 0 THEN 0 ELSE (total_cases/TRY_CONVERT(float,population))*100 END) AS PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--where location LIKE '%China%'
GROUP BY location, population
ORDER BY PercentagePopulationInfected desc;


--Mostrando países con mayor recuento por población por país
SELECT location,MAX(cast(Total_deaths as float)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc;


--Mostrando los continentes con el mayor recuento de muertes por continente 
SELECT continent,MAX(cast(Total_deaths as float)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;


--Numeros Globales
SELECT SUM(TRY_CONVERT(float,new_cases)) as total_cases, 
       SUM(TRY_CONVERT(float,new_deaths)) as total_deaths,
       SUM(TRY_CONVERT(float,new_deaths))/SUM(TRY_CONVERT(float,new_cases))*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


--Observamos el Total Población vs los vacunados
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(TRY_CONVERT (FLOAT,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,
dea.date) as RollngPeopleVaccinated 
--(RollngPeopleVaccinated/population)*100 
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3;


--Uso CTE (Common Table Expression)
With PopvsVac (continetn,location, date, population,new_vaccinations, RollngPeopleVaccinated)
as 
(
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(TRY_CONVERT (FLOAT,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,
dea.date) as RollngPeopleVaccinated 
--(RollngPeopleVaccinated/population)*100 
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollngPeopleVaccinated/population)*100
FROM PopvsVac


--Tabla Temporal
Drop Table if exists #PercentPopulationVaccinated 
Create Table  #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollngPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(TRY_CONVERT (FLOAT,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,
dea.date) as RollngPeopleVaccinated 
--(RollngPeopleVaccinated/population)*100 
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *,(RollngPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--Crear vista para almacenar datos para visualizaciones posteriores
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(TRY_CONVERT (FLOAT,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,
dea.date) as RollngPeopleVaccinated 
--(RollngPeopleVaccinated/population)*100 
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated;