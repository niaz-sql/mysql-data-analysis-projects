-- Connect to database


-- ASSIGNMENT 1: Window function basics

-- View the orders table
SELECT *
FROM orders;

-- View the columns of interest
SELECT customer_id, order_id, order_date, transaction_id
FROM orders;

-- For each customer, add a column for transaction number
SELECT customer_id, order_id, order_date, transaction_id,
ROW_NUMBER() OVER ( PARTITION BY customer_id) as transaction_number
FROM orders;

-- ASSIGNMENT 2: Row Number vs Rank vs Dense Rank

-- View the columns of interest
SELECT order_id, product_id, units
FROM orders;

-- Try ROW_NUMBER to rank the units
SELECT order_id, product_id, units,
ROW_NUMBER() OVER ( PARTITION BY order_id ) as order_rank
FROM orders;


-- For each order, rank the products from most units to fewest units

SELECT order_id, product_id, units,
ROW_NUMBER() OVER ( PARTITION BY order_id ORDER BY units DESC) as order_rank
FROM orders


-- If there's a tie, keep the tie and don't skip to the next number after
SELECT order_id, product_id, units,
DENSE_RANK () OVER ( PARTITION BY order_id ORDER BY units DESC) as order_rank
FROM orders
ORDER BY order_id

-- Check the order id that ends with 44262 from the results preview
SELECT order_id, product_id, units,
DENSE_RANK () OVER ( PARTITION BY order_id ORDER BY units DESC) as order_rank
FROM orders
WHERE order_id LIKE "%44262"

-- ASSIGNMENT 3: First Value vs Last Value vs Nth Value

-- View the rankings from the last assignment
SELECT order_id, product_id, units,
DENSE_RANK () OVER ( PARTITION BY order_id ORDER BY units DESC) as order_rank
FROM orders
ORDER BY order_id

-- Add a column that contains the 2nd most popular product


SELECT order_id, product_id, units,
NTH_VALUE(product_id, 2) OVER ( PARTITION BY order_id ORDER BY units DESC) as order_rank
FROM orders
ORDER BY order_id


-- Return the 2nd most popular product for each order
SELECT order_id, product_id, units
 FROM
(SELECT order_id, product_id, units,
NTH_VALUE(product_id, 2) OVER ( PARTITION BY order_id ORDER BY units DESC) as product_sec_rank
FROM orders
ORDER BY order_id) AS second_prod
WHERE product_id = product_sec_rank

-- ASSIGNMENT 4: Lead & Lag

-- View the columns of interest
SELECT customer_id, order_id, units
FROM orders


-- For each customer, return the total units within each order
SELECT customer_id, order_id, SUM(units) AS all_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id


-- Add on the transaction id to keep track of the order of the orders
SELECT customer_id, order_id, MIN(transaction_id) AS t_id, SUM(units) AS all_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id

-- Turn the query into a CTE and view the columns of interest
WITH all_rows AS (SELECT customer_id, order_id, MIN(transaction_id) AS t_id, SUM(units) AS all_units
					FROM orders
					GROUP BY customer_id, order_id
					ORDER BY customer_id, t_id)
SELECT customer_id, order_id, all_units
FROM all_rows

-- Create a prior units column
WITH all_rows AS (SELECT customer_id, order_id, MIN(transaction_id) AS t_id, SUM(units) AS all_units
					FROM orders
					GROUP BY customer_id, order_id
					ORDER BY customer_id, t_id)
SELECT customer_id, order_id, all_units,
LAG (all_units) OVER ( PARTITION BY customer_id ORDER BY t_id) AS prior_units
FROM all_rows

-- For each customer, find the change in units per order over time
WITH all_rows AS (SELECT customer_id, order_id, MIN(transaction_id) AS t_id, SUM(units) AS all_units
					FROM orders
					GROUP BY customer_id, order_id
					ORDER BY customer_id, t_id)
SELECT customer_id, order_id, all_units,
LAG (all_units) OVER ( PARTITION BY customer_id ORDER BY t_id) AS prior_units,
all_units - LAG (all_units) OVER ( PARTITION BY customer_id ORDER BY t_id)  AS diff
FROM all_rows

-- ASSIGNMENT 5: NTILE

-- Calculate the total amount spent by each customer

SELECT *
FROM customers;


-- View the data needed from the orders table
SELECT customer_id, product_id, units
FROM orders

-- View the data needed from the products table
SELECT product_id, unit_price
FROM products

-- Combine the two tables and view the columns of interest
SELECT o.customer_id, o.product_id, (o.units * p.unit_price) AS price_spent
FROM orders AS o
INNER JOIN products AS p
ON o.product_id = p.product_id

        
-- Calculate the total spending by each customer and sort the results from highest to lowest
SELECT o.customer_id, SUM(o.units * p.unit_price) AS total_spent
FROM orders AS o
INNER JOIN products AS p
ON o.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_spent DESC

-- Turn the query into a CTE and apply the percentile calculation
WITH total_spent_calc AS (SELECT o.customer_id, SUM(o.units * p.unit_price) AS total_spent
FROM orders AS o
INNER JOIN products AS p
ON o.product_id = p.product_id
GROUP BY o.customer_id)
SELECT customer_id, total_spent,
NTILE (100) OVER (ORDER BY total_spent DESC) AS ntile_calc
FROM total_spent_calc


-- Return the top 1% of customers in terms of spending
WITH total_spent_calc AS (SELECT o.customer_id, SUM(o.units * p.unit_price) AS total_spent
							FROM orders AS o
							INNER JOIN products AS p
							ON o.product_id = p.product_id
							GROUP BY o.customer_id),
 ranking AS (SELECT customer_id, total_spent,
							NTILE (100) OVER (ORDER BY total_spent DESC) AS ntile_calc
							FROM total_spent_calc)
                            SELECT *
                            FROM ranking
                            WHERE ntile_calc = 1


