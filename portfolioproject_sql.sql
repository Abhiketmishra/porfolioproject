select * from portfolio.dbo.[covid death] order by 3,4;

--death percentage
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from portfolio..[covid death] where location='India'
order by 1,2 


--total case vs population
select location, date, total_cases, population, (total_cases/population)*100 as covid_percentage
from portfolio..[covid death] where location='India'
order by 1,2 


--country's highest infection rate
select location, population,max(total_cases) as highest_infection , max((total_cases/population))*100 as covid_percentage
from portfolio.dbo.[covid death] group by location,population
order by covid_percentage desc

 --country's highest death count perecntage
 --(we use cast() function beacuse total_death in your file was in varchar) 
select location,max(cast(total_deaths as int)) as highest_death
from portfolio..[covid death] 
where continent is not null
group by location
order by highest_death desc

--continents highest death count 
select continent,max(cast(total_deaths as int)) as death_count
from portfolio..[covid death]
where continent is not null
group by continent
order by death_count desc

--sum of death in a continents 
select continent,sum(cast(total_deaths as int)) as death_count
from portfolio..[covid death]
where continent is not null
group by continent
order by death_count desc

--Global deaths
select date,sum(new_cases)as case_count ,sum(cast(new_deaths as int)) as death_count
from portfolio..[covid death] 
where continent is not null
group by date


--total case, deathcount  
select sum(new_cases)as case_count ,sum(cast(new_deaths as int)) as death_count
from portfolio..[covid death] 
where continent is not null
order by 1


--total vaccination vs population
select vac.date,sum(cast( total_vaccinations as bigint)) as vaccination
from portfolio..[covid death] dea, portfolio..[covid vacination] vac
where dea.location=vac.location
and dea.date=vac.date
and dea.continent is not null
group by vac.date

--continent vacination data
select vac.date,sum(cast( total_vaccinations as bigint)) as vaccination
from portfolio..[covid death] dea, portfolio..[covid vacination] vac
where dea.location=vac.location
and dea.date=vac.date
and dea.continent is not null
--group by vac.date




--vac vs pov
with vacvspov(continent, location,date,new_vaccination,population,rolling_back)
as 
(
select dea.continent, dea.location, dea.date, vac.new_vaccinations,dea.population,
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location) as rolling_back 
from portfolio..[covid death] dea, portfolio..[covid vacination] vac
where dea.location=vac.location
and dea.date=vac.date
and dea.continent is not null
)
select *,(rolling_back/population)*100 AS percentage
from vacvspov


--creating temp table
drop table if exists #percentageofpopulationvaccinated
create table #percentageofpopulationvaccinated
(
continent nvarchar(225),location nvarchar(225),
date datetime,
population numeric,
new_vaccination numeric,
rolling_back numeric)

insert into #percentageofpopulationvaccinated
select dea.continent, dea.location, dea.date, vac.new_vaccinations,dea.population,
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location) as rolling_back 
from portfolio..[covid death] dea, portfolio..[covid vacination] vac
where dea.location=vac.location
and dea.date=vac.date
--and dea.continent is not null

select *,(rolling_back/population)*100 AS percentage
from #percentageofpopulationvaccinated


--creating views to store date for data visualization
 
create view dddfasdad
as
select dea.continent, dea.location, dea.date, vac.new_vaccinations,dea.population,
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location) as rolling_back 
from portfolio..[covid death] dea, portfolio..[covid vacination] vac
where dea.location=vac.location
and dea.date=vac.date
and dea.continent is not null
 
select * from dddfasdad