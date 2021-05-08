---1.	What are the top 5 metros by population?

select metro_city, sum(population) as total_population
from census_metro_data_exp 
group by 1
order by 2 desc
--- Answer: New York, Los Angeles, Chicago, Houston, Dallas

---2.	For those metro areas, what does the spread of median_hh_income look like?
select metro_city, floor (median_hh_income/5000)*5000 as income, count (distinct zip) as total_zips
from census_metro_data_exp cmde 
where metro_city in ('New York', 'Los Angeles', 'Chicago', 'Houston', 'Dallas')
group by 1, 2

---3.	What does the spread of the % of students look like?
select metro_city, floor (percent_students) as income_bucket, count (*)
from (select metro_city, (population_age_5_9+population_age_10_14+population_age_15_17::numeric)*100 percent_students
from census_metro_data_exp
where metro_city in ('New York', 'Los Angeles', 'Chicago', 'Houston', 'Dallas') and population >0) base
group by 1,2
order by 1,2

---4. Which zip codes in each metro area should receive the most federal funding?
select *
from (select pop.metro_city, pop.zip, percent_students, median_income,
     rank () over (
                   partition by pop.metro_city
                   order by population_rank+income_rank desc
                   ) as overall_rank
from (select metro_city, zip, ((population_age_5_9+population_age_10_14+population_age_15_17)::numeric/population::numeric)*100 as percent_students,
     rank () over (
                   partition by metro_city
                   order by ((population_age_5_9+population_age_10_14+population_age_15_17)::numeric/population::numeric)*100
                   ) as population_rank
     from public.census_metro_data_exp
     where metro_city in ('New York', 'Los Angeles', 'Chicago', 'Houston', 'Dallas')
     and population > 0) pop
inner join (select metro_city, zip, median_hh_income as median_income,
     rank () over(
                  partition by metro_city
                  order by median_hh_income desc 
                  ) as income_rank
     from public.census_metro_data_exp
     where metro_city in ('New York', 'Los Angeles', 'Chicago', 'Houston', 'Dallas')
     and population > 0) as income on 
pop.metro_city=income.metro_city
and pop.zip=income.zip) base
where overall_rank <= 10
                  
