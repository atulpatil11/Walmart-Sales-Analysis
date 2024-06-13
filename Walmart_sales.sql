SELECT * FROM salesdatawalmart.walmart_sales;
use salesdatawalmart;
-- -----------------------------------------------------------------
-- Find Time of day -----------------------------------------------

select time,
(Case 
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
End
) As Time_of_day
 from walmart_sales;
 
 alter table walmart_sales add column time_of_day varchar(20);
 
update walmart_sales 
 set time_of_day = (
 Case 
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
End
 );
 
-- -----------------------------------------------------------------
-- Find Week day name -----------------------------------------------

 select date, dayname(date) as day_name from walmart_sales;
 
 alter table walmart_sales add column day_name varchar(20);
 
 update walmart_sales
 set day_name = (dayname(date));
 
 -- -----------------------------------------------------------------
-- Find Month name -----------------------------------------------

select date, monthname(date) from walmart_sales;

alter table walmart_sales add column month_name varchar(20);
 
 update walmart_sales
 set month_name = (monthname(date));
 
 -- -------------------------------------------------------------------
 -- ----------------- Generic Question --------------------------------
  -- How many unique cities does the data have? --------------------------------
    select distinct(city) from walmart_sales;
  
  
  -- In which city is each branch? --------------------------------
    select distinct(city), branch from walmart_sales;
  
  
   -- ----------------- Product --------------------------------
    -- How many unique product lines does the data have? --------------------------------
    select count(distinct(product_line)) as total_product_line from walmart_sales;
    
    -- What is the most common payment method? --------------------------------
    
    select payment, count(payment) as total_payment from
    walmart_sales
    group by payment
    order by total_payment desc
    limit 1
    ;
    
-- What is the most selling product line? ------------------------------------

select product_line, count(product_line) as total_pro_line 
from walmart_sales
group by product_line
order by product_line desc
;

-- What is the total revenue by month? ----------------------------------------

select 
month_name as month,
SUM(total) as total_revenue
from walmart_sales
group by month
order by total_revenue desc;

-- What month had the largest COGS? ------------------------------------------

select month_name, sum(cogs) as total_cogs from walmart_sales
group by month_name
order by total_cogs desc;

-- What product line had the largest revenue? --------------------------------------

select sum(total) as revenue, product_line from
walmart_sales
group by product_line
order by revenue desc;

-- What is the city with the largest revenue? --------------------------------------

select branch, city, sum(total) as revenue
from walmart_sales
group by city, branch
order by revenue desc;

-- What product line had the largest VAT? ------------------------------------------

select product_line,
avg(tax_pct) as VAT
from walmart_sales
group by product_line
order by VAT desc
;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales 

SELECT product_line,
       CASE 
           WHEN total > AVG(total) OVER (PARTITION BY product_line ) THEN "Good"
           ELSE "Bad"
       END AS result
FROM walmart_sales
;

-- Which branch sold more products than average product sold? --------------------

select branch, 
sum(quantity) as total_product
from walmart_sales
group by branch
having sum(quantity) > (select avg(quantity) from walmart_sales)
order by total_product desc
;

-- What is the most common product line by gender? ------------------------------
select gender,
product_line,
count(gender) as total_count
from walmart_sales
group by gender, product_line
order by total_count desc;

-- What is the average rating of each product line? -----------------------------

select round(avg(rating),2) as AVG_rating, 
product_line from walmart_sales
group by product_line;

-- ---------------Sales-----------------------------------------------
-- Number of sales made in each time of the day per weekday-----------

select count(*), time_of_day 
from walmart_sales
where day_name ="Sunday"
group by time_of_day
;

-- Which of the customer types brings the most revenue? -------------

select customer_type, round(sum(total),2) as total_Revenue
from walmart_sales
group by customer_type
order by total_Revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)? ----

select (0.5 * cogs) as VAT from walmart_sales;

alter table walmart_sales add column VAT float;

update walmart_sales set VAT = (0.5 * cogs);

select city, round(avg(VAT),2) as largest_tax
from walmart_sales
group by city 
order by largest_tax desc
limit 1
;

-- Which customer type pays the most in VAT? ---------------------------

select customer_type, round(avg(VAT),2) as AVG_Tax
from walmart_sales
group by customer_type
order by AVG_Tax desc
;

-- Customer -----------------------------------------------------------
-- How many unique customer types does the data have?------------------

select count(distinct(customer_type)) from walmart_sales;

-- How many unique payment methods does the data have?-----------------

select count(distinct(payment)) from walmart_sales;

-- What is the most common customer type? -----------------------------

select Count(customer_type) as total_customers, customer_type
from walmart_sales
group by  customer_type
order by total_customers desc limit 1;

-- Which customer type buys the most? ---------------------------------

select count(invoice_id) as total_orders, customer_type
from walmart_sales
group by  customer_type
order by total_orders desc limit 1
;

-- What is the gender of most of the customers? -----------------------
select count(invoice_id) as  total_orders, gender
from walmart_sales 
group by gender
order by total_orders;

-- What is the gender distribution per branch? -------------------------
select count(gender) as total_employee, branch, gender
from walmart_sales
group by gender, branch
order by branch asc
;

-- Which time of the day do customers give most ratings? ----------------

select time_of_day, count(rating) as rating_per_hour
from walmart_sales
group by time_of_day
order by rating_per_hour desc;

-- Which time of the day do customers give most ratings per branch? ------

select time_of_day, count(rating) as rating_per_hour, branch
from walmart_sales
group by time_of_day, branch
order by rating_per_hour desc;

-- Which day fo the week has the best avg ratings? ------------------------

select day_name, round(avg(rating),2) as AVG_rating
from walmart_sales 
group by day_name
order by AVG_rating desc;

-- Which day of the week has the best average ratings per branch? ---------

select day_name, round(avg(rating),2) as AVG_rating, branch
from walmart_sales 
group by day_name, branch
order by AVG_rating desc;