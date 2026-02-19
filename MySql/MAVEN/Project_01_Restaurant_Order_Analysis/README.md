# 🍽️ Project 01 — Restaurant Order Analysis (MySQL)
## 📌 Overview


**This project analyzes restaurant order data using MySQL to uncover insights about menu performance, customer ordering patterns, and revenue drivers.**


✔️ The analysis integrates menu and transactional datasets to identify:

✔️ Most and least popular menu items

✔️ Cuisine preferences

✔️ Pricing insights

✔️ Order size distribution

✔️ High-value orders

✔️ This project demonstrates practical SQL skills applied to a real-world business scenario.*

## 🗂 Dataset Tables
***📋 menu_items***

Contains details of all dishes available on the menu:

menu_item_id

item_name

category

price

***🧾 order_details***

Contains transactional records of customer orders:

order_id

item_id

order_date

# 🎯 Analysis Objectives
## 🔎 Objective 1 — Menu Exploration

Gain insights into menu composition and pricing.

**Key Questions**

✔️ How many items are on the menu?

✔️ What are the least and most expensive items?

✔️ How many Italian dishes are available?

✔️ What are the cheapest and most expensive Italian dishes?

✔️ How many dishes are in each category?

✔️ What is the average price per category?

**🔥Techniques Used**

👉COUNT(), MIN(), MAX(), AVG()

👉Filtering with WHERE

👉Category grouping with GROUP BY

## 📅 Objective 2 — Order Exploration

Understand order volume and item distribution.

**Key Questions**

✔️ What is the date range of the dataset?

✔️ How many orders were placed?

✔️ How many total items were ordered?

✔️ Which orders contained the most items?

✔️ How many orders included more than 12 items?

**🔥Techniques Used**

👉Date aggregation

👉Grouping by order

👉COUNT() analysis

👉HAVING for group filtering

👉Sorting with ORDER BY

## 📊 Objective 3 — Customer Behavior Analysis

Combine menu and order data to analyze purchasing trends.

**Key Questions**

✔️ Merge menu and order tables

✔️ Identify least and most ordered items

✔️ Determine most popular cuisine categories

✔️ Find the top 5 highest-spending orders

✔️ Examine items in the single highest-spend order

**🔥Techniques Used**

👉INNER JOIN

👉Revenue calculation using SUM(price)

👉Ranking orders by spending

👉Subqueries and CTEs

👉Drill-down analysis

# 📈 Key Insights

✔ Identified best-selling and underperforming menu items
✔ Revealed customer cuisine preferences
✔ Measured order size distribution
✔ Detected high-revenue orders
✔ Provided data-driven recommendations for menu optimization

## 🛠 Skills Demonstrated

🔥Intermediate to Advanced SQL

🔥Data aggregation and analysis

🔥Relational database joins

🔥Business-oriented problem solving

🔥Query structuring for readability

## 🗂 Project Structure

Project_01_Restaurant_Order_Analysis/
│
├──
├── create_restaurant_db.sql            → data sets
├── Solution.sql                        → SQL solutions
└── README.md                           → Documentation

# 🚀 How to Run

Import the dataset into MySQL

Execute create_restaurant_db.sql to create tables

Load the data into the tables

Run queries from  Solution.sql 

# 💡 Business Use Case

**The insights from this analysis can help restaurant managers:**

💎Optimize menu pricing

💎Identify popular cuisines

💎Remove low-performing dishes

💎Understand customer ordering behavior

💎Increase profitability

# 👨‍💻 Author

niaz-sql

**SQL Learner | Aspiring Data Analyst**
