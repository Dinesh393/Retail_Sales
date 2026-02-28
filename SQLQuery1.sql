DROP TABLE IF EXISTS retail_sales

CREATE TABLE retail_sales
(
   transactions_id INT,
   sale_date DATE,
   sale_time TIME,
   customer_id INT,
   gender VARCHAR(10),
   age INT,
   category VARCHAR(20),
   quantity INT,
   price_per_unit FLOAT,
   cogs FLOAT,
   total_sale FLOAT
)

SElECT * FROM retail_sales

--Counting number of rows of the table
SELECT COUNT(*) AS TotalCount FROM retail_sales  --2000 records

--Let's analyse the data and check which rows have null values 
SELECT * FROM retail_sales
WHERE
   transactions_id IS NULL
   OR
   sale_date IS NULL
   OR
   sale_time IS NULL
   OR
   customer_id IS NULL
   OR
   gender IS NULL
   OR
   age IS NULL
   OR
   category IS NULL
   OR
   quantiy IS NULL
   OR
   cogs IS NULL
   OR
   total_sale IS NULL;
--We got 13 rows which have null values, so we have to delete null values where the financial related rows have bull values 
--because they doesn't made any transactions

--Deleting unwanted rows
DELETE FROM retail_sales
WHERE 
   quantiy IS NULL
   OR 
   price_per_unit IS NULL
   OR 
   cogs IS NULL
   OR 
   total_sale IS NULL;

SELECT COUNT(*) AS TotalCount FROM retail_sales
--Now we have 1997 rows 

--Replace NULL values of age with AVG(age)
UPDATE retail_sales
SET age = (SELECT AVG(age) FROM retail_sales WHERE age IS NOT NULL)
WHERE age IS NULL;

