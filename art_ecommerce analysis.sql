use sakila;
select * from large_art_ecommerce_dataset;

-- General Data Retrival
-- 1. List all painters and their respective painting styles

select name_of_painter, style
from large_art_ecommerce_dataset
order by name_of_painter;

-- 2. Retrieve all paintings priced above $500.
select * from large_art_ecommerce_dataset
where `Price($)` > 500;

-- 3.Find paintings available for free shipping
select * from large_art_ecommerce_dataset
where Shipment = "Free Shipping";

-- 4.List all paintings that are marked as "Original" (not copies).
select * from large_art_ecommerce_dataset
where copy_or_original = "Original";

-- **Price Analysis**
-- 1. Calculate the average price of all paintings
select 
avg(`Price($)`) as avg_price
from large_art_ecommerce_dataset;

-- Find the highest-priced painting and the painter's name
select name_of_painter,
max(`Price($)`) 
from large_art_ecommerce_dataset
group by name_of_painter;

select name_of_painter,
`Price($)`
from large_art_ecommerce_dataset
order by `Price($)` desc;

-- 3. Retrieve all paintings priced between $400 and $800.
select *
from large_art_ecommerce_dataset
where `Price($)` between 400 and 800;

-- 4. Group paintings by their "Style" and calculate the total price for each style
select Style,
sum(`Price($)`) as total_price
from large_art_ecommerce_dataset
group by Style;

-- Shipping and Delivery
-- 1.Find paintings that are delivered in less or equal to 5 days.
select *
from large_art_ecommerce_dataset
where Delivery_days <= 5;

-- 2. Count how many paintings are shipped using "Standard" shipment.
select count(*) as standard_shipping_cnt
from large_art_ecommerce_dataset
where Shipment = "Standard";

-- 3.List the number of paintings shipped for free to each location.
select Location,
count(*) as free_shipping_count_by_location
from large_art_ecommerce_dataset
where Shipment = "Free Shipping"
group by Location;

-- Painter and Target Audience Insights
-- 1. Find all painters who have created multiple paintings

select name_of_painter, count(*) as painting_cnt
from large_art_ecommerce_dataset
group by name_of_painter
having count(*) > 1;

-- 2. List all paintings with "Corporate Clients" as the target audience.
select * 
from large_art_ecommerce_dataset
where target_audience = "Corporate Clients";

-- 3. Find the total number of paintings for each target audience.
select target_audience, count(*) as count_target_audience 
from large_art_ecommerce_dataset
group by target_audience;

-- ##Identify the Best-Selling Painting Style##
-- 1. Find the painting style that generates the highest revenue.

select Style,
sum(`Price($)`) as revenue_by_style
from large_art_ecommerce_dataset
group by Style
order by revenue_by_style desc
limit 1;

-- **Analyze Delivery Performance**
-- Find the average delivery time for each shipping method and identify the fastest shipping method.

select Shipment, avg(Delivery_days) avg_delivery_time
from large_art_ecommerce_dataset
group by Shipment;

-- ## Price Optimization ##
-- 1. Identify the price range that has the highest number of paintings sold.

select 
concat(floor(`Price($)`/100)*100, "-", floor(`Price($)`/100)*100+100) as ranges, count(*) as no_painting_sold
from large_art_ecommerce_dataset
group by ranges
order by no_painting_sold desc;

-- ##Target Audience Trends##
-- Analyze which target audience purchases the most expensive paintings on average.

select target_audience, 
avg(`Price($)`) as avg_price 
from large_art_ecommerce_dataset
group by target_audience
order by avg_price desc
limit 1;

-- Painting Size Impact
-- Determine if larger paintings (area-wise) are more expensive on average

select Size,
avg(`Price($)`) as avg_price 
from large_art_ecommerce_dataset
group by Size
order by avg_price desc;
-- no larger painting are not the most expensive 

-- Popular Medium Analysis
-- 1. Identify which medium (e.g., Watercolor, Charcoal) is most commonly used by painters whose target audience is "Corporate Clients.”

select distinct Medium,
count(*) as medium_cnt
from large_art_ecommerce_dataset
where target_audience = "Corporate Clients"
group by Medium
order by medium_cnt desc;

-- Correlation Between Delivery Days and Price
-- Check if there is a correlation between the price of paintings and their delivery times.

select concat(floor(`Price($)`/100)*100 , "-", floor(`Price($)`/100)*100+100) as price_range,
Delivery_days
from large_art_ecommerce_dataset
order by Delivery_days desc;
-- no there is no correlation between the price of painting and their delivery times.

-- ##Shipping Cost Optimization##
-- Find which location benefits the most from "Free Shipping" by comparing the total number of paintings shipped for free.


select Location, count(*)  as free_shipping_count
from large_art_ecommerce_dataset
where Shipment = "Free Shipping"
group by Location
order by free_shipping_count desc;
-- MOntreal benifits the most when compared to total number of paintings shipped for free

-- ##Top Painters by Revenue##
-- Identify the top 3 painters generating the most revenue

select distinct name_of_painter,
sum(`Price($)`) as total_revenue 
from large_art_ecommerce_dataset
group by name_of_painter
order by total_revenue desc
limit 3;

-- ##Detect Duplicate Paintings##
-- Find paintings that have the same combination of "Style," "Medium," and "Size.”

select Style, Medium, Size,
count(*) as duplicate_count 
from large_art_ecommerce_dataset
group by Style, Medium, Size
having duplicate_count > 1;

-- ##Find Undervalued Paintings##
-- Identify paintings priced below the average price for their style and medium

SELECT *
FROM large_art_ecommerce_dataset p
WHERE `Price($)` < (
    SELECT AVG(`Price($)`)
    FROM large_art_ecommerce_dataset
    WHERE Style = p.Style AND Medium = p.Medium
);

-- ##Painting Popularity by Location##
-- Find the most common painting subject sold in each location

select  Location, subject_of_painting, count(*) as sub_painting_cnt 
from large_art_ecommerce_dataset
group by Location, subject_of_painting
order by sub_painting_cnt desc;

-- ##Profit Margin Analysis##
-- Calculate potential profit margins if the sale price includes a 20% markup over the current price

select name_of_painter, `Price($)`, `Price($)`*1.20 as sales_price, `Price($)`*0.20 as profit_margin 
from large_art_ecommerce_dataset;

-- Lighting Requirements and Target Audience
-- Analyze which target audience prefers paintings with "Natural Light" requirements.

select target_audience, count(*) as audience_count
from large_art_ecommerce_dataset
where `Theme/lighting_requirements` = "Natural Light"
group by target_audience
order by audience_count desc;

-- ##Filter Non-Standard Sizes##
-- Find all paintings that are not in standard sizes (e.g., 18"x24", 20"x30").

select *
from large_art_ecommerce_dataset
where Size not in ('18"x24"', '20"x30"');


-- Delivery Days vs Price Range
-- Classify delivery times into categories (e.g., Fast: ≤3 days, Standard: 4–6 days, Slow: >6 days) and find the average price in each category.


select case 
			when Delivery_days <=3 then "Fast"
            when Delivery_days between 4 and 6 then "Standard"
            else "Slow"
		end as delivery_category,
round(avg(`Price($)`),0) as avg_price
from large_art_ecommerce_dataset
group by delivery_category
order by avg_price desc;
