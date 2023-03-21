select * from CovidDeaths
select * from CovidVacinnations
order by 3,4

--select * from CovidDeath
--select * from CovidVacinnation
--order by 3,4

--select data that we are going to be using

select location,date,total_cases,new_cases,total_deaths,population from CovidDeaths
order by 3,4

--Looking at Total cases vs Total Deaths

select  location, date, total_cases,total_deaths,(total_deaths/total_cases) *100 as DeathPercentage from CovidDeaths
where location like '%states'
order by 1,2


--looking at Total cases vs Population
--shows what percentage of population got covid

select location,date,population,total_cases,(total_cases/population)*100 as Deathpercentage from CovidDeaths
where location like '%states%'
order by 1,2

--looking at Countries with Highest Infection Rate compared to Poulation

select location, population, MAX(total_cases) as HighestInfectionCount,Max(total_cases/population)*100 as PercentPopulationInfected  from CovidDeaths
group by location, population
order by 4 desc

--Showing Countries with Highest Death Count per Population

select location, max(cast(total_deaths as int)) as TotalDeathCount from CovidDeaths
where continent is not null
group by location, population
order by TotalDeathCount desc

--Showing the Continent with the Highest Death Count per population

select continent, max(cast(total_deaths as int)) as TotalDeathCount from CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers

select sum(new_cases)as TotalCases, sum(cast(new_deaths as int))as TotalDeath,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage from CovidDeaths 
order by 1,2



select ca.continent,ca.location, ca.date, ca.population,cv.new_vaccinations from CovidDeaths ca
join CovidVacinnations cv
on ca.date=cv.date
and ca.location=cv.location
where ca.continent is not null
order by 2,3

--Looking at Total Popuation vs Vacinnations

select cd.continent,cd.location, cd.date,cd.population,cv.new_vaccinations,
sum(cast(cv.new_vaccinations as int))  over (partition by cd.location order by cd.location, cd.date)from CovidDeaths cd
join CovidVacinnations cv
on cd.date=cv.date
and cd.location=cv.location
where cd.continent is not null
order by 2,3


create view  PercenPopulationVacinated as
select cd.continent,cd.location, cd.date,cd.population,cv.new_vaccinations,
sum(cast(cv.new_vaccinations as int))  over (partition by cd.location order by cd.location, cd.date)from CovidDeaths cd
join CovidVacinnations cv
on cd.date=cv.date
and cd.location=cv.location
where cd.continent is not null
order by 2,3
