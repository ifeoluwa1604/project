use world_data;

select *
from bolaji2003;

select *
from samplestore;

select *
from hr_data;

select *
from emptable;

set sql_safe_updates=0;

update `samplestore assignment`
set sales= replace(sales,'$','');

update `samplestore assignment`
set sales= replace(sales,',','');

update `samplestore assignment`
set profit= replace(profit,'$','');

update `samplestore assignment`
set profit= replace(profit,',','');

update `samplestore assignment`
set profit= replace(profit,'(','');

update samplestore
set `order date` = str_to_date('order date','%m/%d/%Y');

update samplestore
set `ship date` =str_to_date('ship date','%m/%d/%y');

rename table `samplestore assignment`
to samplestore;

rename table`bajaj-2003-2020`
to bolaji2003;

rename table`employee-table_023054`
to emptable;

alter table hr_data
rename column ï»¿id to id;

select birthdate,
case
when birthdate like '%-%-%' then str_to_date(birthdate,'%d-%M-%y')
when birthdate like '%/%/%' then str_to_date(birthdate,'%m/%d/%y')
else null
end as parsed_date
from hr_data; 

alter table hr_data
ADD column formattedbirthdate date after birthdate;

update hr_data
set formatted_birthdate = case
when birthdate like '%-%-%' then str_to_date(birthdate,'%d-%M-%y')
when birthdate like '%/%/%' then str_to_date(birthdate,'%m/%d/%y')
else null
end;

alter table hr_data
drop column formatted_birthdate;


select hire_date,
case
when 'hire_date' like '%-%-%' then str_to_date('hire_date','%d-%m-%y')
when 'hire_date' like '%/%/%' then str_to_date('hire_date','%M/%d/%y')
else null
end as parsed_date
from hr_data;

set sql_safe_updates=0;

update hr_data
set hire_date= case
when hire_date like '%-%-%' then str_to_date(hire_date,'%d-%m-%y')
when hire_date like '%/%/%' then str_to_date(hire_date,'%m/%d/%y')
else null
end;



select order_date,
case
when 'order_date' like '%-%-%' then str_to_date('order_date','%d-%m-%y')
when 'order_date' like '%/%/%' then str_to_date('order_date','%M/%d/%y')
else null
end as parsed_date
from samplestore; 


--- 1
select
    `Sub-Category`,
    SUM(Quantity) AS TotalQuantitySold,
    round(sum(Profit), 2) AS TotalProfit
FROM samplestore
GROUP BY `Sub-Category`
having sum(Quantity) > 1000
and sum(profit) <= 0
order by TotalQuantitySold DESC;  

--- 2
select
'markets',
round(avg(discount),2) as  higher_discounts, 
round(avg(profit),2) as lower_profits
from samplestore
group by Market;
--- 3
select segment,
round(avg(discount),2) as avg_discount,
round(sum(profit),2) as total_profit
from samplestore
group by segment
order by total_profit desc;
--- 4
select city,
sum(quantity) as total_sold,
round(sum(profit), 2) as total_profit,
round(avg(profit),2) as avg_profit_per_order
from samplestore
group by city
order by total_sold desc;

--- 5
select market,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit,
abs(sum(sales) - sum(profit)) as sales_profit_dispartity
from samplestore
group by Market
order by sales_profit_dispartity desc;

--- 6
select region,
segment,
avg(datediff('order_date',
'ship_date')) as avg_delay_days
from samplestore
group by Region, segment
order by avg_delay_days desc;

--- 7

select year('order_date') as year,
round(sum(profit), 2) as total_profit
from samplestore
group by year('order_date')
order by total_profit desc;
--- by quater
select
year('order_date') as year,
 Quarter('order_date') as year_quarter,
round(sum(profit), 2) as total_profit
from samplestore 
group by year('order_date'),
quarter('order_date')
order by total_profit desc
limit 1; 

--- 8

select
monthname('order_date') as order_name,
sum(profit) as total_profit
from samplestore
group by monthname('order_date')
order by total_profit desc;

-- use bolaji2003

--- 9

select date,
`Prev Close`,
`open price`,
`Close Price`
from bolaji2003
where `Open Price` < 'prev close'
and `Close Price` > `Open Price`;

---- 10

select 
date,
`high price`
from bolaji2003
where `High Price` >= 1000;

---- 11

select date,
'total traded quantity',
turnover
from bolaji2003
where 'Total Traded Quantity' < 1000 and Turnover> 50000
order by 'totalt raded quantity' or Turnover desc;

---- 12
select date,
`high price`,
`low price`,
round((`high price` - `low price`), 2) as price_range
from bolaji2003
where (`high price` - `low price`) >= 100
order by date;

--- 13

select year(date) as year,
round(avg('close_price'),2) as avg_close_price
from bolaji2003
group by year
order by year;

---- 14

select year(date) as year,
sum('totaltradedqunatity') as total_shared
from bolaji2003
group by year
order by YEAR;

--- 15

select year(date) as year,
round(avg(turnover), 2)as avg_turnover
from bolaji2003
group by year(date)
order by avg_turnover desc;

---- 16
select year(date) as year,
round(avg('total_traded_quantity'),2) as avgtotal_traded_quantity
from bolaji2003
group by year(date)
having avg('Total_Traded_Quantity')< 5000
order by year;

---- 17

select year(date) AS year,
monthname(date) as month,
round(avg('close_price'), 2) as avg_close_price
from bolaji2003
group by year, month
having avg('close_price')> 500
order by year, month;

use hr_data;

-- 18

select gender, count(*) as count
from hr_data
group by gender
order by count desc;

-- 19

select department,
count(*) as remote_employees
from hr_data
where location ='remote'
group by department
order by 'remote_count' desc;

-- 20

select location,
count(*)  as employee_count
from hr_data
where location in ('remote','HQ')
group by location;

-- 21

select race,
COUNT(*) AS Employee_count
from hr_data
group by race
order by employee_count desc;
--- distribution employee
select location_state,
count(*) as total_employees
from hr_data
group by location_state
order by total_employees desc;

-- 22

select count(*) as terminated_employees
from hr_data
where termdate is not null
and termdate <> '';

--- 23
select first_name,
last_name,
hire_date,
datediff(curdate(), hire_date) as days_served
from hr_data
where termdate is not null or termdate=''
order by days_served desc
limit 5;

--- 24
select race,
count(*) as terminated_count
from hr_data
where termdate is not null
and termdate <>''
group by race
order by terminated_count desc;

---- 25
select case
when timestampdiff(year, formatted_birthday, curdate()) < 30 then 'under 30'
when timestampadd(year, formatted_birthday, curdate()) between 30 and 39 then '30-39'
when timestampdiff(year,formatted_birthday, curdate()) between 40 and 49 then '40-49'
else '50+'
end as age_group,
count(*) as employee_count
from hr_data
group by age_group
order by age_group;

---- 26

select
format(hire_date,'yyyy-mm') as hire_month,
count(*) as hires
from hr_data
group by format(hire_date,'yyyy-mm')
order by hire_month;

-- 27

SELECT 
  department,
  CASE
    WHEN tenure < 1 THEN '<1 year'
    WHEN tenure BETWEEN 1 AND 3 THEN '1–3 years'
    WHEN tenure BETWEEN 4 AND 6 THEN '4–6 years'
    WHEN tenure BETWEEN 7 AND 10 THEN '7–10 years'
    ELSE '10+ years'
  END AS tenure_range,
  COUNT(*) AS employee_count
FROM (
  SELECT 
    department,
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS tenure
  FROM hr_data
) AS sub
GROUP BY department, tenure_range
ORDER BY department, tenure_range;

--- 28

select
round(avg(timestampdiff(year, hire_date,
curdate())),2) as avg_years_of_service
from hr_data;

---- 29
 select department,
     sum( case when termdate is not null and termdate <>''
     then 1 else 0 end)
     * 100/ count(*) AS Turnover_rate
     from hr_data
     group by department
     order by turnover_rate desc
     limit 3;
















