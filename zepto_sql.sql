DROP TABLE IF EXISTS zepto;


CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
Category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);


--data exploration

--count of row
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

SELECT * FROM zepto
WHERE name is NULL
OR
Category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
availableQuantity is NULL
OR
discountedSellingPrice is NULL
OR
weightInGms is NULL
OR
outOfStock is NULL
OR
quantity is NULL;




--- different product categories

SELECT DISTINCT category
FROM zepto
ORDER BY category;


--product in stock vs out of stock

SELECT outOfStock ,COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;



--product names present in multiple times
SELECT name ,COUNT(sku_id) AS "NUMBER od SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id)>1
ORDER BY count(sku_id) DESC;

--data cleaning

--product with price =0
SELECT * FROM zepto
WHERE mrp = 0 AND discountedSellingPrice =0;


DELETE FROM zepto 
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp,discountedSellingPrice
FROM zepto;


--Q1 top 10 best value product  based on discount percent
SELECT DISTINCT name ,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2 What are the product with high MRP with bit out of stock

SELECT DISTINCT name ,mrp
FROM zepto
WHERE outOfstock = TRUE AND mrp>300
ORDER BY mrp DESC;

--Q3 calculate Estimated revenue foreach category

SELECT category,
SUM(discountedSellingPrice* availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4 find all the product where mRP is greter that 500 and  discount is less than 10%
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
WHERE mrp >500 AND discountPercent <10
ORDER BY mrp DESC,discountPercent DESC;

--Q5  identitify top 5 categories offerning the highest avg discount percentage
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;




--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;




--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;











