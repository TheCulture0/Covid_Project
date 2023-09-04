
select * from Project1.dbo.['owid-covid-data$']


-- Question 1
-- Total cases v Total deaths 



-- Question 2
-- Showing countries with Highest infection rate per population

select 

	location
,	MAX(CAST(total_cases as float))		[Total cases]
,	population
,	ROUND((MAX(CAST(total_cases as float))/population)*100,4)	[InfectionRate]

from Project1.dbo.['owid-covid-data$']	 

where 1=1
and continent is not null
and total_cases is not null

group by
	location
,	population

order by
	[InfectionRate] desc

-- Question 3
-- Showing countries with Highest death count per population

--select location, MAX(convert(float,total_cases)) [Highest case], MAX(convert(float,total_deaths)) [Highest death] from Project1.dbo.['owid-covid-data$'] group by location order by location

select 

	location
,	MAX(CAST(total_deaths as float))		[Total deaths]
,	population
,	ROUND((MAX(CAST(total_deaths as float))/population)*100,4)	[Death_Percentage] 

from Project1.dbo.['owid-covid-data$']	 

where 1=1
and continent is not null
and total_deaths is not null

group by
	location
,	population

order by
	[Total deaths] desc

-- Question 4: Deaths by continent

select

	location
,	population
,	MAX(CAST(total_deaths as float))	[Total deaths]
,	ROUND((MAX(CAST(total_deaths as float))/population)*100,4)	[Death_Percentage]

from Project1.dbo.['owid-covid-data$']

where 1=1
and continent is null
--and location not like '%income%'
--and total_deaths is not null
and location in ('asia', 'africa', 'north america', 'south america', 'europe', 'oceania')

group by
	location
,	population

-- Question 5
-- Global numbers

select

	SUM(cast(new_cases as float))									[Total cases]
,	SUM(cast(new_deaths as float))									[Total deaths]
,	SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))	[Death percentage]

from Project1.dbo.['owid-covid-data$']


-- CREATE VIEW

Create View InfectionSummary as

select 

	location
,	population
,	MAX(CAST(total_cases as float))								[Total cases]
,	MAX(CAST(total_deaths as float))							[Total deaths]
,	ROUND((MAX(CAST(total_cases as float))/population)*100,4)	[InfectionRate]
,	ROUND((MAX(CAST(total_deaths as float))/population)*100,4)	[DeathRate]

from Project1.dbo.['owid-covid-data$']	 

where 1=1
and continent is not null

group by
	location
,	population

--order by
--	[InfectionRate] desc

-- Question 6
-- Total populations v Vaccinations

drop table if exists #popvsvac
select 

	location
,	population
,	date
,	isnull(new_vaccinations,0)																	[Vaccinations]
,	SUM(cast(new_vaccinations as bigint)) OVER (Partition by location order by location, date)	[RollingPVaccinated] 	

into #popvsvac
from Project1.dbo.['owid-covid-data$']

where 1=1
and continent is not null

--group by
--	location
--,	population

Select

	location
,	isnull(ROUND(MAX(VacPercent),4),0)	[PercentVac]

from (
	Select * , (RollingPVaccinated/population)*100 [VacPercent]
	from #popvsvac
	) pv

group by
	location