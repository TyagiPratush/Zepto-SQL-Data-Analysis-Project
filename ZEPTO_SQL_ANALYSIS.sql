drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR (120),
name VARCHAR(150) not null,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availabilityQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quatity INTEGER
);

--DATA EXPLORATION

--COUNT OF ROWS
SELECT COUNT(*)FROM zepto;

--SAMPLE DATA
SELECT * FROM zepto
LIMIT 10;

--NULL VALUES
SELECT * FROM zepto
WHERE name is null
OR
mrp IS NULL
OR
discountedSellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
availabilityquantity IS NULL
OR
quatity IS NULL;

--diffrent product categories
SELECT DISTINCT category
FROM ZEPTO
ORDER BY category;

--products in stock vs out of stock
SELECT outofStock, COUNT(sku_id)
FROM zepto
GROUP BY outofStock;

--product name present multiple times
SELECT name, count(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--data cleaning
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingprice = discountedSellingprice/100.0;

SELECT mrp, discountedSellingprice
FROM zepto;

--Q1. Find Top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2. What are the products with high MRP but out of Stock
SElECT DISTINCT name, mrp
from zepto
WHERE outofStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3. Calculate estimated revenue for each category
SELECT category,
SUM(discountedSellingprice * availabilityQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. Find all products where MRP is greater than Rs500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500 and discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

--Q5. Identify the Top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightingms, discountedSellingprice,
ROUND(discountedSellingprice/weightingms,2) AS price_per_gram
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_gram;

--Q7. Group the products into categories like low, Medium, Bulk.
SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

--Q7. What is total Inventory Weight per category
SELECT category,
SUM(weightingms  * availabilityQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;