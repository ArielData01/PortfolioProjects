# Análisis de la pandemia del COVID-19

Este proyecto es un análisis de la pandemia del COVID-19 utilizando datos de las bases de datos abiertas de **Our World in Data**.

Código de SQL
El archivo SQL incluido en este repositorio contiene las consultas utilizadas para el análisis de los datos. Se han utilizado diferentes consultas para analizar los casos de COVID-19 y las tasas de vacunación a nivel global, y se presentan algunos ejemplos de las consultas utilizadas en este proyecto.

Consultas utilizadas
Se han utilizado diferentes consultas para analizar los datos, algunas de las cuales incluyen:

* **SELECT * FROM PortfolioProject..CovidDeaths WHERE continent IS NOT NULL ORDER BY 3,4;**:Consulta para seleccionar los datos de la tabla CovidDeaths y ordenarlos por continente y fecha.

* **SELECT location,date,total_cases,new_cases,total_deaths,population FROM PortfolioProject..CovidDeaths WHERE continent IS NOT NULL ORDER BY 1,2;**: Consulta para seleccionar los datos de la tabla CovidDeaths y ordenarlos por ubicación y fecha.

* **SELECT location, date, total_cases, total_deaths, (CASE WHEN TRY_CONVERT(float,total_cases) = 0 THEN 0 ELSE (total_deaths/TRY_CONVERT(float,total_cases)) END)*100 AS DeathPercentage FROM PortfolioProject..CovidDeaths WHERE location LIKE '%Argentina%' AND continent IS NOT NULL ORDER BY 1,2;**: Consulta para analizar la probabilidad de morir por COVID-19 en Argentina.

* **SELECT location, date,population, total_cases, CASE WHEN TRY_CONVERT(float,total_cases) = 0 THEN 0 ELSE (total_cases/TRY_CONVERT(float,population))*100 END AS Population_Percentage FROM PortfolioProject..CovidDeaths ORDER BY 1,2;**: Consulta para analizar el porcentaje de la población que ha contraído COVID-19 en todo el mundo.

* **SELECT location,population, MAX(total_cases) AS HighestInfectionCount, MAX(CASE WHEN TRY_CONVERT(float,total_cases) = 0 THEN 0 ELSE (total_cases/TRY_CONVERT(float,population))*100 END) AS PercentagePopulationInfected FROM PortfolioProject..CovidDeaths GROUP BY location, population ORDER BY PercentagePopulationInfected desc;**: Consulta para analizar los países con la tasa de infección más alta en comparación con la población.

* **Creación de Tabla Temporal #PercentPopulationVaccinated**: Con el fin de optimizar las consultas en calculos complejos.

* **Creación de Tabla Vista PercentPopulationVaccinated**: Con el proposito de simplificar el acceso a datos complejos y para presentarlos de una manera más estructurada y de fácil compresión.

# Resultados
Los resultados obtenidos de las diferentes consultas nos permiten analizar diferentes aspectos de la pandemia del COVID-19 a nivel global, como la probabilidad de morir por COVID-19 en diferentes países, el porcentaje de la población mundial que ha contraído COVID-19, y los países con la tasa de infección más alta en comparación con la población.

# Limitaciones
Es importante tener en cuenta que los datos utilizados en este proyecto son de acceso público y no están actualizados en tiempo real. Además, algunos datos pueden estar incompletos o ser imprecisos debido a la falta de reportes oficiales de algunos países.

# Autor
Este proyecto fue realizado por **Ariel Bogado** como parte de un portafolio de proyectos.
