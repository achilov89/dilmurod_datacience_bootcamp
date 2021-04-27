---1.  Which campaign typically has the highest cost each year?

select sac.campaign, date_part('year',date) as year,
round(sum(sad.cost)) as total_cost
from public.search_ad_data sad 
inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id
group by 1, 2
order by 2, 3 desc 
---Answer: ladder_collection

---2. Which campaign typically has the lowest cost per conversion each year.

select year, campaign, cpc
from (select date_part('year', date) as year, sac.campaign,sum(cost)/sum (conversions) as cpc
from public.search_ad_data sad inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id 
group by 1, 2) as cpc
order by 3
---Answer: desk_organization 

---3. What is the year over year trend in campaign costs?
select date_part('year', date) as year, sac.campaign,avg(cost) as average_cost
from public.search_ad_data sad 
inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id 
group by 1, 2

---4.What is the year over year trend in CPC?
select date_part('year', date) as year, sac.campaign,sum(cost)/sum (conversions) as cpc
from public.search_ad_data sad inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id 
group by 1, 2








