-- Find the Total Number of Transactions made by each Gender in each Category 
SELECT 
	category, 
	gender, 
	count(*) transactions_id 
FROM transactions
GROUP BY 
	category,
	gender ;

-- Calculate the Average Sale for Each Month and Find the Best Seling Month in Each Year 
SELECT 
	YEAR(sale_date),
    MONTH(sale_date),
	ROUND(AVG(total_sale), 2)avg_sale
FROM transactions
GROUP BY 1, 2 
ORDER BY 1, 3 DESC ;

-- Pick the Maximum Averages per Year
SELECT * FROM 
	(
	SELECT 
		YEAR(sale_date),
		MONTH(sale_date),
		ROUND(AVG(total_sale), 2)avg_sale,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rink
	FROM transactions
	GROUP BY 1, 2 
	) AS t 
WHERE rink = 1 ;

-- find the top 5 customers based on the highest total sales 
SELECT 
	customer_id ,
	SUM(total_sale)
FROM transactions 
GROUP BY 1  
ORDER BY 2 DESC
LIMIT 5;

-- find the number of unique customers who purchased items from each category 
SELECT 
	category,
    COUNT(DISTINCT customer_id) AS cnt_unique_cst
FROM transactions 
GROUP BY 1;

-- Create each Shift and Number of Orders ( Example Morning<12, AfterNoon Between 12 & 17, Evening>17 ) 

SELECT *,
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning' 
		WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'After Noon'
		ELSE 'Evening'
	END AS shift
FROM transactions;

WITH hourly_sales
		AS
		(
		SELECT *,
			CASE
				WHEN HOUR(sale_time) < 12 THEN 'Morning' 
				WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'After Noon'
				ELSE 'Evening'
			END AS shift
		FROM transactions
		)
SELECT 
	shift,
	COUNT(transactions_id) AS number_of_orders 
FROM hourly_sales
GROUP BY shift
ORDER BY number_of_orders DESC;
