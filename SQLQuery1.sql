DROP TABLE IF EXISTS retail_sales

CREATE TABLE retail_sales
(
   transactions_id INT,
   sale_date DATE,
   sale_time TIME,
   customer_id INT,
   gender VARCHAR(15),
   age INT,
   category VARCHAR(20),
   quantity INT,
   price_per_unit FLOAT,
   cogs FLOAT,
   total_sale FLOAT
);

SElECT * FROM retail_sales;	


-----Data Cleaning----
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
   quantity IS NULL
   OR
   cogs IS NULL
   OR
   total_sale IS NULL;
--We got 13 rows which have null values, so we have to delete null values where the financial related rows have bull values 
--because they doesn't made any transactions

--Deleting unwanted rows
DELETE FROM retail_sales
WHERE 
   quantity IS NULL
   OR 
   price_per_unit IS NULL
   OR 
   cogs IS NULL
   OR 
   total_sale IS NULL;

SELECT COUNT(*) AS TotalCount FROM retail_sales;
--Now we have 1997 rows 

--Replace NULL values of age with AVG(age)
UPDATE retail_sales
SET age = (SELECT AVG(age) FROM retail_sales WHERE age IS NOT NULL)
WHERE age IS NULL;


-----Data Exploration-----
--How many sakes we have
SELECT COUNT(*) AS TotalSale FROM retail_sales;

--How many customers we have?
SELECT COUNT(DISTINCT customer_id) AS TotalCustomers FROM retail_sales;  
--we have total of 155 customers, some of them with multiple purchases

--How much categories we have?
SELECT DISTINCT category FROM retail_sales;  
--We have 3 categories which are Beauty, Electronics and Clothing



----Data analysis and Business Key problems and Answers---
--My analysis and Findings
--1) Write a sql query to retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';


--2)Write a sql query to retrieve all the transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND
quantity >= 4
AND 
sale_date >= '2022-11-01' AND sale_date<'2022-12-01';


--3) Write a sql query to calculate the total sales(total_sale) and number of orders for each category
SELECT 
      category, 
	  SUM(total_sale) AS NetSale,
	  COUNT(*) AS TotalOrders
FROM retail_sales
GROUP BY category;


--4) Write a sql query to find the average age of customers who purchased items from the 'Beauty' category
SELECT 
	 ROUND(AVG(age),2) AS AvgAge
FROM retail_sales
WHERE category = 'Beauty';


--5)Write a sql query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


--6) Write a sql query to find the total number of transactions (transaction_id) made by each gender.
SELECT
   category, 
   gender, 
   COUNT(*) AS TotalTransactions
FROM retail_sales
GROUP BY 
     category,
	 gender
ORDER BY 1;


--7) Write a sql query to calculate the average sale for each month. 
SELECT
    YEAR(sale_date) AS Year,
	MONTH(sale_date) AS Month,
	AVG(total_sale) AS AvgSale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY YEAR(sale_date), AVG(total_sale) DESC


--8) Find out best selling month in each year.
SELECT 
     YEAR,
	 MONTH,
	 AvgSale
FROM
(
      SELECT
    YEAR(sale_date) AS Year,
	MONTH(sale_date) AS Month,
	AVG(total_sale) AS AvgSale,
	RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS Rank
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS T1
WHERE Rank = 1;


--9) Write a sql query to find the top 5 customers based on the highest total sales
SELECT 
      TOP 5 customer_id,
	  SUM(total_sale) AS TotalSale
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC;


--10) Write a sql query to find the number of unique customers who purchased items from each category
SELECT 
     COUNT(DISTINCT customer_id) AS UniqueCust,
	 category
FROM retail_sales
GROUP BY category;


--11) Write a sql query to create each shift and number of orders (Example morning <12, Afternoon between 12 and 17, Evening > 17)
SELECT *,
      CASE   
	     WHEN DATEPART(HOUR,sale_time) < 12 THEN 'Morning'
		 WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
	  END AS shift
FROM retail_sales;


--12) Write a sql query to get total number of sales done in each shift.
WITH hourly_sale
AS
(
SELECT *,
      CASE   
	     WHEN DATEPART(HOUR,sale_time) < 12 THEN 'Morning'
		 WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
	  END AS shift
FROM retail_sales
)
SELECT
    shift,
	COUNT(*) AS TotalSale
FROM hourly_sale
GROUP BY shift;

------END------