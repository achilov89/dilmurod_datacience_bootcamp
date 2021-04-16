--- Unit 2 1 sql project Dilmurod Achilov
---Which metro area in the country has the highest average household income in the US?

select  metro_city, avg (median_hh_income) as avg_hh_income
from public.census_metro_data
group by metro_city 
order by 2 desc 

---Answer:Bridgeport

---What metro area has the zip code with the largest population? 

select  metro_city, zip, max (population) as largest_poulation
from public.census_metro_data 
group by metro_city, zip
order by 3 desc 
---Answer: Houston 

---What state has the most metro areas?
select state, count (metro_city) as number_of_metro_areas
from public.census_metro_data 
group by state
order by 2 desc 
---Answer:CA

---Which metro area has the largest proportion of people aged 70-97?
select metro_city , max (population_age_75_79) as number_people_aged_70_79
from public.census_metro_data
group by metro_city 
order by 2 desc
---Answer: Phoenix 
