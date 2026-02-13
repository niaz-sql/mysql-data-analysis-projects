-- Connect to database


-- ASSIGNMENT 1: Subqueries in the SELECT clause

-- View the products table


-- View the average unit price


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



