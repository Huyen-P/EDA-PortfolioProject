Select * 
From EDAPorfolioProject..CovidDeaths
order by 3,4

--Select *
--From CovidVaccinations
--order by 3,4 

-- Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From EDAPorfolioProject..CovidDeaths
Where continent is not NULL
order by 1,2

-- Looking at Total Cases vs Total Deaths 
-- Show likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From EDAPorfolioProject..CovidDeaths
Where location like '%vietnam%'
order by 3,4


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From EDAPorfolioProject..CovidDeaths
--Where location like '%vietnam%'
Where continent is not NULL
order by 3,4

-- Looking at countries with highest infection rate compared to Population

Select location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From EDAPorfolioProject..CovidDeaths
--Where location like '%vietnam%'
Where continent is not NULL
group by location, population
order by PercentPopulationInfected desc

-- Let's break things down by continent

Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
From EDAPorfolioProject..CovidDeaths
--Where location like '%vietnam%'
Where continent is not NULL
group by continent
order by TotalDeathCount desc

-- Showing Countries with Highest Death Count per Populations

Select location, MAX(cast(total_deaths as int)) AS TotalDeathCount
From EDAPorfolioProject..CovidDeaths
--Where location like '%vietnam%'
Where continent is not NULL
group by location
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM (new_cases)*100 as DeathPercentage
From EDAPorfolioProject..CovidDeaths
--Where location like '%vietnam%'
WHERE continent is not NULL
-- group by date
order by 1,2

-- Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.location, vac.new_vaccinations, 
	   SUM (convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
	   --(RollingPeopleVaccinated/population)*100
From EDAPorfolioProject..CovidDeaths dea
Join EDAPorfolioProject..CovidVaccinations vac
	 On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- USE CTE

With PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	   , SUM( cast (vac.new_vaccinations as int)) OVER (Partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
	   --, (RollingPeopleVaccinated/population)*100
From EDAPorfolioProject..CovidDeaths dea
Join EDAPorfolioProject..CovidVaccinations vac
	 On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
-- Order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	   , SUM( cast (vac.new_vaccinations as int)) OVER (Partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
	   --, (RollingPeopleVaccinated/population)*100
From EDAPorfolioProject..CovidDeaths dea
Join EDAPorfolioProject..CovidVaccinations vac
	 On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
-- Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	   , SUM( cast (vac.new_vaccinations as int)) OVER (Partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
	   --, (RollingPeopleVaccinated/population)*100
From EDAPorfolioProject..CovidDeaths dea
Join EDAPorfolioProject..CovidVaccinations vac
	 On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
-- Order by 2,3


Select*
From PercentPopulationVaccinated