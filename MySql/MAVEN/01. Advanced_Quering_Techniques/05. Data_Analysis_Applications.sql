-- Connect to database


-- ASSIGNMENT 1: Duplicate values

-- View the students data
-- Create a column that counts the number of times a student appears in the table
-- Return student ids, names and emails, excluding duplicates students
WITH dup_count AS 
(SELECT id, student_name, email, ROW_NUMBER () OVER (PARTITION BY student_name ORDER BY id) AS count_stu FROM students) 
SELECT id, student_name, email FROM dup_count WHERE count_stu = 1

-- ASSIGNMENT 2: Min / max value filtering

-- View the students and student grades tables
-- For each student, return the classes they took and their final grades
-- Return each student's top grade and corresponding class
WITH max_calc AS 
(SELECT student_id, MAX(final_grade) AS max_grade FROM student_grades 
GROUP BY student_id), 

cals_table AS 
(SELECT s.id, s.student_name, sg.final_grade, sg.class_name 
FROM students AS s 
LEFT JOIN student_grades AS sg ON s.id = sg.student_id) 

SELECT ct.id, ct.student_name, mc.max_grade, ct.class_name 
FROM cals_table AS ct 
INNER JOIN max_calc AS mc 
ON ct.id = mc.student_id 
AND ct.final_grade = mc.max_grade 
ORDER BY ct.id
               
-- WITH WINDOW FUNCTION SOLUTION
SELECT *
FROM (SELECT s.id, s.student_name, sg.final_grade, sg.class_name,
ROW_NUMBER () OVER (PARTITION BY  student_name ORDER BY final_grade DESC) AS rank_order
FROM students AS s 
LEFT JOIN student_grades AS sg ON s.id = sg.student_id) AS cals_table
WHERE rank_order =1
ORDER BY id

-- ASSIGNMENT 3: Pivoting

-- Combine the students and student grades tables
SELECT s.grade_level, sg.department, sg.final_grade
FROM students AS s
INNER JOIN student_grades AS sg
ON s.id = sg.student_id
        
-- View only the columns of interest
SELECT sg.department, sg.final_grade,
CASE WHEN grade_level =9 THEN 1 ELSE 0  END AS freshman,
CASE WHEN grade_level =10 THEN 1 ELSE 0  END AS sophomore,
CASE WHEN grade_level =11 THEN 1 ELSE 0  END AS junior,
CASE WHEN grade_level =12 THEN 1 ELSE 0  END AS senoir
FROM students AS s
INNER JOIN student_grades AS sg
ON s.id = sg.student_id
        
-- Pivot the grade_level column
SELECT sg.department,
AVG(CASE WHEN grade_level =9 THEN sg.final_grade   END) AS freshman,
AVG(CASE WHEN grade_level =10 THEN sg.final_grade   END) AS sophomore,
AVG(CASE WHEN grade_level =11 THEN sg.final_grade   END) AS junior,
AVG(CASE WHEN grade_level =12 THEN sg.final_grade   END) AS senoir
FROM students AS s
INNER JOIN student_grades AS sg
ON s.id = sg.student_id
GROUP BY department

-- ASSIGNMENT 4: Rolling calculations

-- Calculate the total sales each month
SELECT year(order_date) AS year, month (order_date) AS month,  sum(p.unit_price * o.units) AS tot_price
FROM products AS p
INNER JOIN orders o
ON p.product_id = o.Product_id
GROUP BY  year,  month

-- Add on the cumulative sum and 6 month moving average

SELECT year(order_date) AS year, month (order_date) AS month,  sum(p.unit_price * o.units) AS tot_price,
sum(sum(p.unit_price * o.units)) OVER (PARTITION BY year(order_date) ORDER BY month (order_date)) AS run_sum,
ROUND(AVG(sum(p.unit_price * o.units)) OVER (PARTITION BY year(order_date) ORDER BY month (order_date) ROWS BETWEEN 5 PRECEDING AND CURRENT ROW),2) AS run_sum_6_month_Avg
FROM products AS p
INNER JOIN orders o
ON p.product_id = o.Product_id
GROUP BY  year,  month

-- FINAL DEMO: Imputing NULL Values

/* Stock prices table was created in prior section:
   This is the code if you need to create it again */

 Create a stock prices table
CREATE TABLE IF NOT EXISTS stock_prices (
    date DATE PRIMARY KEY,
    price DECIMAL(10, 2)
);

INSERT INTO stock_prices (date, price) VALUES
	('2024-11-01', 678.27),
	('2024-11-03', 688.83),
	('2024-11-04', 645.40),
	('2024-11-06', 591.01); 

    
   WITH RECURSIVE mydate(dt) AS
    (SELECT DATE('2024-11-1')
    UNION ALL
    SELECT dt + INTERVAL 1 DAY
    FROM mydate
    WHERE dt<'2024-11-6') 
    SELECT mydate.dt, sp.price
    FROM mydate LEFT JOIN stock_prices AS sp
    ON mydate.dt = sp.date
    
    -- Let's replace the NULL values in the price column 4 different ways (aka imputation)
-- 1. With a hard coded value
-- 2. With a subquery
-- 3. With one window function
-- 4. With two window functions

   WITH RECURSIVE mydate(dt) AS
								(SELECT DATE('2024-11-1')
								UNION ALL
								SELECT dt + INTERVAL 1 DAY
								FROM mydate
								WHERE dt<'2024-11-6'),
				   fin_tbl  AS (SELECT mydate.dt, sp.price
												FROM mydate LEFT JOIN stock_prices AS sp
												ON mydate.dt = sp.date)
  SELECT dt, price,
  COALESCE (price, 600) AS fill_with_hardcode,
  COALESCE (price, (SELECT avg(price) FROM stock_prices)) AS fill_with_avg,
   COALESCE (price, LEAD (price) OVER()) AS fill_with_One_window,
   COALESCE (price, (LEAD (price) OVER() + LAG (price) OVER())/2) AS fill_with_Two_window
  FROM fin_tbl  
  
