create database zomato_Analysis;
use zomato_Analysis;
-- 2 Question

SELECT 
    YEAR(date) AS Year,
    MONTH(date) AS MonthNo,
	monthname(date) as MonthfullName,
    CONCAT('Qtr-', QUARTER(date)) AS Quarter,
    date_format(date, '%Y-%b') AS YearMonth,
    dayofweek(date) AS WeekdayNo,  
    DAYNAME(date) AS WeekdayName,
                      -- financialMonthNo
    CASE 
        WHEN MONTH(Date) >= 4 THEN MONTH(Date) - 3
        ELSE MONTH(Date) + 9
    END AS FinancialMonthNo,  
                       -- financialMonth
    CONCAT('FM',
        CASE 
            WHEN MONTH(Date) >= 4 THEN MONTH(Date) - 3
            ELSE MONTH(Date) + 9
        END
    ) AS FinancialMonth,   
                       -- financialquarter
    CONCAT('FQ',
        CASE 
            WHEN MONTH(Date) BETWEEN 4 AND 6 THEN 1
            WHEN MONTH(Date) BETWEEN 7 AND 9 THEN 2
            WHEN MONTH(Date) BETWEEN 10 AND 12 THEN 3
            ELSE 4
        END
    ) AS FinancialQuarter   
    from main;

-- 3. Convert the Average cost for 2 column into USD dollars

select
    restaurant,
    Average_Cost_for_two,
    ROUND(Average_Cost_for_two / 83.0, 2) AS cost_usd
FROM main;

-- 4.Find the Numbers of Resturants based on City and Country

select c.countryname,m.city,count(m.restaurant) as no_of_restaurants
from main m left join country c
on m.countrycode=c.countryid
group by 1,2;

-- 5.Numbers of Resturants opening based on Year , Quarter , Month

select  year(date) as year,quarter(date) as quarter,month(date) as month,count(restaurant) as no_of_restaurants from main
group by 1,2,3
order by year asc;

select year(date) as year,count(restaurant) as no_restaurants from main
group by 1 order by no_restaurants desc;

select concat("Qtr-",quarter(date)) as Quarter,count(restaurant) as no_restaurants from main
group by 1 order by no_restaurants desc;

select monthname(date) as Month,count(restaurant) as no_restaurants from main
group by 1 order by no_restaurants desc;

-- 6. Count of Resturants based on Average Ratings

select count(restaurant) as no_of_restaurnts,round(avg(rating),1) from main
where rating is not null;

select count(restaurant) as no_of_restaurnts,rating from main
where rating is not null group by 2
order by rating desc;

-- 7. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

select bucket_cost_range,
count(*) as total_restaurants from 
(select 
case 
when average_cost_for_two between 0 and 300 then '0-300'
when average_cost_for_two between 301 and 600 then '301-600'
when average_cost_for_two between 601 and 1000 then '601-1000'
when average_cost_for_two between 1001 and 43000 then '1001-43000'
else 'other'
end as bucket_cost_range from main) as subquery
group by 1;

-- 8.Percentage of Resturants based on "Has_Table_booking"

SELECT 
    Has_Table_booking,
    COUNT(*) AS total_restaurants,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM main), 2) AS percentage
FROM main
GROUP BY Has_Table_booking;

-- 9.Percentage of Resturants based on "Has_Online_delivery"
SELECT 
    Has_online_delivery,
    COUNT(*) AS total_restaurants,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM main), 2) AS percentage
FROM main
GROUP BY Has_online_delivery;

-- 10. Develop Charts based on Cusines, City, Ratings
 select cuisines,city,rating, count(cuisines) as count from main
 group by 1,2,3 order by count desc;
 
 
 

































