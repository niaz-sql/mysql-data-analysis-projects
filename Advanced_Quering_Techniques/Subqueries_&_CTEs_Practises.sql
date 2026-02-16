-- Connect to database


-- ASSIGNMENT 1: Subqueries in the SELECT clause
-- Return the product id, product name, unit price, average unit price,
-- and the difference between each unit price and the average unit price

-- Order the results from most to least expensive
SELECT product_id, product_name, unit_price,
(SELECT avg(unit_price) FROM products) AS avg_price,
unit_price - (SELECT avg(unit_price) FROM products) AS avg_price_diff
FROM products
ORDER BY unit_price DESC


-- ASSIGNMENT 2: Subqueries in the FROM clause

-- Return the factories, product names from the factory and number of products produced by each factory
SELECT p.factory, p.product_name, p.product_id, o.units
FROM products as p
INNER JOIN orders AS o 
ON p.product_id = o.product_id

-- All factories and products
SELECT *
FROM products

SELECT factory, product_name
FROM products

-- All factories and their total number of products
-- Final query with subqueries
SELECT p.factory, p.product_name,  count_prod.tot_num_prod
 FROM 
(SELECT factory, product_name
FROM products) AS p
INNER JOIN 
(SELECT factory, count(product_name) AS tot_num_prod
FROM products
GROUP BY factory) AS count_prod
ON p.factory = count_prod.factory





-- ASSIGNMENT 3: Subqueries in the WHERE clause

-- View all products from Wicked Choccy's
SELECT *
FROM products
WHERE factory = "Wicked Choccy's" AND unit_price IS NULL


-- Return products where the unit price is less than the unit price of all products from Wicked Choccy's
SELECT *
FROM products
WHERE unit_price < ALL 
(SELECT  unit_price
FROM products
WHERE factory = "Wicked Choccy's")

-- ASSIGNMENT 4: CTEs

-- View the orders and products tables
SELECT*
FROM products

SELECT *
FROM orders

-- Calculate the amount spent on  each order

-- Return all orders over $200
WITH order_wise_cost AS (SELECT  o.order_id, sum(p.unit_price * o.units) AS cost
FROM orders AS o INNER JOIN  products AS p
ON o.product_id = p.product_id
GROUP BY   o.order_id)
SELECT *
FROM order_wise_cost
WHERE cost >200
ORDER BY cost DESC


-- Return the number of orders over $200
WITH order_total AS (SELECT  o.order_id, count(o.order_id) AS total_orders, sum(p.unit_price * o.units) AS cost
FROM orders AS o INNER JOIN  products AS p
ON o.product_id = p.product_id
GROUP BY   o.order_id)
SELECT order_total.order_id, total_orders
FROM order_total
WHERE cost >200
ORDER BY total_orders DESC

-- ASSIGNMENT 5: Multiple CTEs

-- Copy over Assignment 2 (Subqueries in the FROM clause) solution

-- Return the factories, product names from the factory and number of products produced by each factory
SELECT p1.factory, p1.product_name, prod_count
FROM products AS p1
INNER JOIN 
(SELECT factory, COUNT(product_name) AS prod_count
FROM products
GROUP BY factory) AS p2
ON p1.factory = p2.factory



-- Rewrite the Assignment 2 subquery solution using CTEs instead

WITH p1 AS (SELECT factory, product_name
			FROM products),
	p2 AS (SELECT factory, COUNT(product_name) AS prod_count
			FROM products
			GROUP BY factory) 
SELECT p1.factory, p1.product_name, prod_count
FROM p1 INNER JOIN p2
ON p1.factory = p2.factory





