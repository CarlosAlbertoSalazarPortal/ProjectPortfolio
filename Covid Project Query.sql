Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4




Select Location,date, total_cases , new_cases, total_deaths , population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total cases vs Total Deaths

Select Location,date, total_cases , new_cases, total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--Looking at the Total cases vs Populations

Select Location,date,Population, total_cases ,(total_cases/population)*100 as PercentOfPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--Looking with Countries with Highest Infection Rate compared to population

Select Location,population, MAX(total_cases) as HighestInfectionCount , Max((total_cases/population))*100 as PercentOfPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, population
order by PercentOfPopulationInfected desc


--Showing Countries with Highest Death count Population


Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc



--Showing Continent with Highest Death count Population

--Query with only continents

Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where location NOT IN ('High income','Upper middle income','lower middle income','low income','international','world')
And continent is null
Group by location
order by TotalDeathCount desc



--Global Numbers

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where location NOT IN ('High income','Upper middle income','lower middle income','low income','international','world')
And continent is null
order by 1,2


--Looking at Total Populations vs Vaccinations

With PopulationvsVaccination (continent, location, date , population , new_vaccinations, RollingpeopleVaccinated)
as
(
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations , 
SUM(CAst(vac.new_vaccinations as bigint)) OVER (Partition by dea. location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea. location = vac.location
and dea.date = vac.date
Where dea. location NOT IN ('High income','Upper middle income','lower middle income','low income','international','world')
and dea.continent is not null
--order by 2,3
)
Select *, (RollingpeopleVaccinated/Population)*100
From PopulationvsVaccination



--CTE


With PopulationvsVaccination (continent, location, date , population , RollingpeopleVaccinated
as




--Temporary Table

Drop Table if exists #PercentPopulationVaccinated

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

Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations , 
SUM(CAst(vac.new_vaccinations as bigint)) OVER (Partition by dea. location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea. location = vac.location
and dea.date = vac.date
Where dea. location NOT IN ('High income','Upper middle income','lower middle income','low income','international','world')
and dea.continent is not null






--Creating View to Store data



Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea. location NOT IN ('High income','Upper middle income','lower middle income','low income','international','world')
and dea.continent is not null

