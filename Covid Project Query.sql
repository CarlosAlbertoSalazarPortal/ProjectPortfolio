Select *
From PortfolioProject..CovidDeaths
Where Continent Is Not null
Order by 3,4




Select Location,Date, Total_Cases , New_Cases, Total_Deaths , Population
From PortfolioProject..CovidDeaths
Order By 1,2

--Looking at Total cases vs Total Deaths

Select Location,Date, Total_Cases , New_Cases, Total_Deaths , (Total_Deaths/Total_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Location Like '%states%'
Order by 1,2

--Looking at the Total cases vs Populations

Select Location,Date,Population, Total_Cases ,(Total_Cases/population)*100 as PercentOfPopulationInfected
From PortfolioProject..CovidDeaths
Where location Like '%states%'
Order by 1,2

--Looking with Countries with Highest Infection Rate Compared to Population

Select Location,Population, MAX(total_cases) as HighestInfectionCount , Max((total_cases/population))*100 as PercentOfPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
Order by PercentOfPopulationInfected Desc


--Showing Countries with Highest Death count Population


Select location, Max(cast(Total_deaths As int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
Where Continent Is Not Null
Group by Location
Order by TotalDeathCount Desc



--Showing Continent With Highest Death Count Population

--Query With Only Continents

Select Location, Max(Cast(Total_deaths As int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
Where Location NOT IN ('High income','Upper middle income','lower middle income','low income','international','world')
And Continent Is Null
Group by Location
Order by TotalDeathCount Desc



--Global Numbers

Select Sum(New_cases) As Total_cases, Sum(Cast(New_deaths As Int)) As Total_deaths, Sum(Cast(New_deaths As Int))/Sum(New_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where Location Not In ('High income','Upper middle income','lower middle income','low income','international','world')
And Continent Is Null
Order by 1,2


--Looking at Total Populations vs Vaccinations

With PopulationvsVaccination (Continent, Location, Date , Population , New_vaccinations, RollingpeopleVaccinated)
As
(
Select dea.Continent, dea.Location,dea.Date, dea.Population, vac.New_vaccinations , 
SUM(Cast(vac.New_vaccinations As bigint)) OVER (Partition by dea. Location Order by dea.Location, dea.Date) As RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea. Location = vac.Location
And dea.Date = vac.Date
Where Dea. Location NOT IN ('High income','Upper middle income','lower middle income','low income','international','world')
and Dea.Continent Is Not Null
--Order by 2,3
)
Select *, (RollingpeopleVaccinated/Population)*100
From PopulationvsVaccination



--CTE


With PopulationvsVaccination (Continent, Location, Date , Population , RollingpeopleVaccinated
as




--Temporary Table

Drop Table If Exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population Numeric,
New_vaccinations Numeric,
RollingPeopleVaccinated Numeric
)

Insert Into #PercentPopulationVaccinated

Select dea.Continent, dea.Location,dea.Date, dea.Population, vac.New_vaccinations , 
SUM(Cast(vac.New_vaccinations As bigint)) OVER (Partition by dea. Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea. Location = vac.Location
And dea.Date = vac.Date
Where dea. Location NOT IN ('High income','Upper middle income','lower middle income','low income','international','world')
and Dea.Continent Is Not Null






--Creating View to Store data



Create View PercentPopulationVaccinated As
Select dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations
, SUM(CONVERT(Int,vac.New_vaccinations)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.Location = vac.Location
	And dea.Date = vac.Date
Where dea. Location NOT IN ('High income','Upper middle income','lower middle income','low income','international','world')
And dea.Continent is Not Null

