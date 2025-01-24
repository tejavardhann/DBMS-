use mobilityservicedb;

-- How many drivers do you have registered?
SELECT COUNT(*) AS drivers_count FROM drivers;


-- Number of active vs inactive ( this month)? 
SELECT SUM(IF(is_active, 1, 0)) AS active_drivers, SUM(IF(NOT is_active, 1, 0)) AS inactive_drivers
FROM drivers
WHERE MONTH(date_joined) = MONTH(CURRENT_DATE);
    

SELECT COUNT(*) AS costomers_count FROM customers;


-- Who is the driver with the most number of rides?
SELECT  rides.driver_id,CONCAT(drivers.first_name, ' ', drivers.last_name) AS Name,
    COUNT(*) AS ride_count
FROM rides
JOIN drivers ON rides.driver_id = drivers.driver_id
GROUP BY rides.driver_id
ORDER BY ride_count DESC
LIMIT 1;


-- Who is the passenger with the most number of rides? 
SELECT  rides.customer_id, 
        CONCAT(customers.first_name, ' ', customers.last_name) AS Name,
        COUNT(*) AS ride_count
FROM rides
JOIN customers ON rides.customer_id = customers.customer_id
GROUP BY rides.customer_id
ORDER BY ride_count DESC
LIMIT 1;

-- Top 5 drivers by revenue by month- January, Feb, Mar?
WITH ranked_drivers AS (
    SELECT d.driver_id, CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
        EXTRACT(MONTH FROM r.date) AS month, SUM(r.fare) AS total_revenue,
        ROW_NUMBER() OVER (PARTITION BY EXTRACT(MONTH FROM r.date) ORDER BY SUM(r.fare) DESC) AS revenue_rank
    FROM rides r
    JOIN drivers d ON r.driver_id = d.driver_id
    WHERE EXTRACT(MONTH FROM r.date) IN (1, 2, 3)
      AND r.status = 'Completed'
    GROUP BY d.driver_id, EXTRACT(MONTH FROM r.date)
)
SELECT driver_id, driver_name, month, total_revenue
FROM ranked_drivers
WHERE revenue_rank <= 5
ORDER BY month, revenue_rank;




-- Top 5 customers by revenue this year? 
SELECT c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(fare) AS total_revenue
FROM rides r
JOIN customers c ON r.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM r.date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_revenue DESC
LIMIT 5;



-- Has our revenue increased last month compared to last year same month? 
WITH revenue_data AS (
    SELECT EXTRACT(YEAR FROM date) AS year, EXTRACT(MONTH FROM date) AS month, SUM(fare) AS total_revenue
    FROM rides WHERE status = 'Completed' GROUP BY year, month)
SELECT 
    current_month.year AS year,current_month.month AS month,
    prev_year.total_revenue AS last_year_revenue,current_month.total_revenue AS current_revenue,
    CASE 
        WHEN current_month.total_revenue > prev_year.total_revenue THEN 'Increased'
        WHEN current_month.total_revenue < prev_year.total_revenue THEN 'Decreased'
        ELSE 'No Change'
    END AS revenue_change
FROM revenue_data current_month
LEFT JOIN revenue_data prev_year
ON  current_month.year = prev_year.year + 1 AND 
    current_month.month = prev_year.month
WHERE current_month.year = 2024 AND current_month.month = 1;










-- What is the most expensive ride among my rides?

SELECT ride_id,pickup_location,drop_location,fare,date
FROM rides
WHERE customer_id = 23
ORDER BY fare DESC
LIMIT 1;







-- How many rides did I take with your business?

SELECT COUNT(*) AS total_rides
FROM rides
WHERE customer_id = 23;

-- How much money did I spend with your business year-to-date?
SELECT SUM(fare) AS total_spent
FROM rides 
WHERE customer_id = 23 AND status = 'Completed' AND EXTRACT(YEAR FROM date) = EXTRACT(YEAR FROM CURRENT_DATE);

-- what is the size of project database and size of each table?

SELECT table_schema AS "Database", SUM(data_length + index_length) / 1024 / 1024 AS "Size in MB"
FROM information_schema.tables
WHERE  table_schema = 'mobilityservicedb'
GROUP BY table_schema;



SELECT table_name AS "Table", ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size in MB"
FROM information_schema.tables
WHERE table_schema = 'mobilityservicedb'
ORDER BY (data_length + index_length) DESC;
















SET profiling = 1;
SELECT * FROM mobilityservicedb.payment_details order by  payment_method;
SHOW PROFILES;

CREATE INDEX idx_payment_method ON mobilityservicedb.payment_details (payment_method);

SELECT * FROM mobilityservicedb.payment_details order by  payment_method;
SHOW PROFILES;





