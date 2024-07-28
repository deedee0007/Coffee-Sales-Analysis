use coffee_sales;

select * from Coffee ;

--primary key

select transaction_id , count(transaction_id) as count
from Coffee
group by transaction_id
having count(transaction_id)>1; --transaction_id can be primary key

--EXTRACTING DAYNAME FROM TRANSACTION DATE 

SELECT transaction_date, DATENAME(weekday, transaction_date) AS DayName
FROM Coffee;

ALTER TABLE coffee
ADD DayName VARCHAR(20); 

UPDATE Coffee
SET DayName = DATENAME(weekday, transaction_date);

--TIME CATEGORY FROM TRANSACTION TIME

SELECT
    transaction_time,
    CASE
        WHEN CONVERT(TIME, transaction_time) >= '05:00:00' AND CONVERT(TIME, transaction_time) < '12:00:00' THEN 'Morning'
        WHEN CONVERT(TIME, transaction_time) >= '12:00:00' AND CONVERT(TIME, transaction_time) < '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS TimeCategory
FROM Coffee;


ALTER TABLE coffee
ADD TimeCategory VARCHAR(20); 


UPDATE Coffee
SET TimeCategory =
    CASE
        WHEN CONVERT(TIME, transaction_time) >= '05:00:00' AND CONVERT(TIME, transaction_time) < '12:00:00' THEN 'Morning'
        WHEN CONVERT(TIME, transaction_time) >= '12:00:00' AND CONVERT(TIME, transaction_time) < '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;


--EXTRACTING MONTH NAME FROM TRANSACTION DATE  

SELECT transaction_date, DATENAME(month, transaction_date) AS MonthName
FROM Coffee ;

ALTER TABLE Coffee
ADD MonthName VARCHAR(20); 

UPDATE Coffee
SET MonthName = DATENAME(month, transaction_date);

--BASIC QUERIES RELATING TO SALES

SELECT DayName , CAST(sum(sales) AS decimal(10,2)) as total_sales
FROM Coffee
GROUP BY DayName
ORDER BY total_sales DESC;

SELECT TimeCategory , CAST(sum(sales) AS decimal(10,2)) as total_sales , sum(transaction_qty) as total_qty
FROM Coffee
GROUP BY TimeCategory
ORDER BY total_sales DESC;

SELECT MonthName , CAST(sum(sales) AS decimal(10,2)) as total_sales , SUM(transaction_qty) as total_qty
FROM Coffee
GROUP BY MonthName
ORDER BY total_sales DESC;

SELECT
    DayName,
   ROUND(AVG(total_sales),2)AS avg_sales
FROM (
    SELECT
        DayName,
        SUM(Sales) AS total_sales
    FROM Coffee
    GROUP BY DayName
) AS MonthlySales
GROUP BY DayName;


SELECT store_location , CAST(sum(sales) AS decimal(10,2)) as total_sales
FROM Coffee
GROUP BY store_location
ORDER BY total_sales DESC;


SELECT product_category , CAST(sum(sales) AS decimal(10,2)) as total_sales
FROM Coffee
GROUP BY product_category
ORDER BY total_sales DESC;


SELECT product_type , CAST(sum(sales) AS decimal(10,2)) as total_sales
FROM Coffee
GROUP BY product_type
ORDER BY total_sales DESC;


SELECT product_category , product_type , product_detail, CAST(sum(sales) AS decimal(10,2)) as total_sales
FROM Coffee
GROUP BY product_category , product_type , product_detail
ORDER BY total_sales DESC;

-- UNIT_PRICE ANALYSIS

SELECT product_category , product_type , product_detail , CAST(MAX(unit_price) AS DECIMAL(10,2)) AS PRICE
FROM Coffee
GROUP BY product_category , product_type , product_detail
ORDER BY MAX(unit_price) DESC;

-- QUANTITY ANALYSIS

SELECT DayName , sum(transaction_qty) as total_qty
FROM Coffee
GROUP BY DayName 
ORDER BY total_qty DESC;


SELECT store_location , sum(transaction_qty) as total_qty
FROM Coffee
GROUP BY store_location
ORDER BY total_qty DESC;


SELECT product_category , sum(transaction_qty) as total_qty
FROM Coffee
GROUP BY product_category
ORDER BY total_qty DESC;


SELECT product_category , product_type , product_detail ,sum(transaction_qty) as total_qty
FROM Coffee
GROUP BY product_category , product_type , product_detail
ORDER BY total_qty DESC;

--STORE LOCATION ANALYSIS

SELECT store_location , product_category,product_type,product_detail , sum(sales) as total_sales ,sum(transaction_qty) as total_qty
from coffee 
group by store_location , product_category,product_type,product_detail
order by sum(sales) desc;


SELECT
    store_location,
    dayname,
    CONCAT(ROUND(SUM(sales),2),'K')AS total_sales
FROM Coffee
GROUP BY store_location, dayname
ORDER BY
    store_location,
    CASE
        WHEN dayname = 'Monday' THEN 1
        WHEN dayname = 'Tuesday' THEN 2
        WHEN dayname = 'Wednesday' THEN 3
        WHEN dayname = 'Thursday' THEN 4
        WHEN dayname = 'Friday' THEN 5
        WHEN dayname = 'Saturday' THEN 6
        WHEN dayname = 'Sunday' THEN 7
    END;


SELECT
    store_location,
    MonthName,
    CONCAT(ROUND(SUM(sales),2),'K')AS total_sales
FROM Coffee
GROUP BY store_location, MonthName
ORDER BY
    store_location,
    CASE
        WHEN MonthName = 'January' THEN 1
        WHEN MonthName = 'February' THEN 2
        WHEN MonthName = 'March' THEN 3
        WHEN MonthName = 'April' THEN 4
        WHEN MonthName = 'May' THEN 5
        WHEN MonthName = 'June' THEN 6
    END;


SELECT
    store_location,
    TimeCategory,
    CONCAT(ROUND(SUM(sales),2),'K')AS total_sales
FROM Coffee
GROUP BY store_location, TimeCategory
ORDER BY
    store_location,
    CASE
        WHEN TimeCategory = 'Morning' THEN 1
        WHEN TimeCategory = 'Afternoon' THEN 2
        WHEN TimeCategory = 'Evening' THEN 3
    END;

--PERCENTAGE GROWTH IN SALES FROM JANUARY TO JUNE 

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(
        (SUM(Sales) - LAG(SUM(Sales), 1) OVER (ORDER BY MONTH(transaction_date))) /
        LAG(SUM(Sales), 1) OVER (ORDER BY MONTH(transaction_date)) * 100,
        2
    ) AS percentage_change
FROM 
    coffee
WHERE 
    MONTH(transaction_date) IN (1, 6) 
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);


--PERCENTAGE CHANGE IN QUANTITY FROM JANUARY TO JUNE 

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty),2) AS total_quantity_sold,
	ROUND(
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 ,2)
	AS percentage_change
FROM 
    coffee
WHERE 
    MONTH(transaction_date) IN (1, 6)   
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);


select * from coffee;
