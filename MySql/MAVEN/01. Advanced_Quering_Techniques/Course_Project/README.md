
# ⚾ Advanced MySQL Analytics Project
School, Salary & Player Career Analysis
📌 Project Overview

This project is a comprehensive data analysis case study built using MySQL 8+.

The goal was to analyze historical player, team, school, and salary data to uncover meaningful trends and insights across multiple dimensions.

All analysis was performed using advanced SQL only, without external analytics tools.

###  Skills & Techniques Demonstrated

✅ CTEs (Common Table Expressions)

✅ Window Functions (ROW_NUMBER, DENSE_RANK, NTILE)

✅ Running Totals (Cumulative Sum)

✅ Percentile Analysis (Top 20%)

✅ Top-N per Group Problems

✅ Date & Age Calculations (TIMESTAMPDIFF)

✅ Decade Calculations (FLOOR(year/10)*10)

✅ Complex Joins

✅ Advanced Aggregations

✅ Business-Oriented SQL Analysis

## 📂 Project Breakdown
### 🎓PART I 🎓School Analysis
Key Questions Solved

Reviewed school and school details tables

Calculated how many schools produced players per decade

Identified the Top 5 schools overall producing the most players

Determined the Top 3 schools per decade using ranking window functions

Techniques Used

COUNT(DISTINCT)

Decade calculation with FLOOR()

DENSE_RANK() for Top-N per group

CTE structuring

### 🎓 PART II Salary Analysis
Key Questions Solved

Explored team salary data

Identified the Top 20% highest spending teams using NTILE()

Calculated cumulative team spending over time

Determined the first year each team surpassed $1 Billion in cumulative spending

Techniques Used

NTILE() for percentile grouping

Running totals with SUM() OVER

Threshold milestone detection

Window function partitioning

### 🧑‍💼 PART III — Player Career Analysis
Key Questions Solved

Counted total players in the dataset

Calculated:

Age at debut

Age at final game

Career length (years)

Identified each player's starting and ending team

Counted players who:

Started and ended on the same team

Played more than 10 years

Techniques Used

TIMESTAMPDIFF() for accurate age calculation

Multi-table joins

Career duration logic

Conditional filtering

### 📊 PART IV — Player Comparison Analysi
Key Questions Solved

Identified players sharing the same birthday

Created team-level batting hand percentage breakdown

Analyzed trends in:

Average height at debut

Average weight at debut

Calculated decade-over-decade changes

Techniques Used

Window functions

Percentage calculations

Decade grouping

Trend analysis

Grouped aggregations

# 📈 Analytical Highlights

✔ Implemented scalable SQL pipelines
✔ Solved real-world percentile problems
✔ Used ranking logic for competitive comparisons
✔ Applied milestone detection in financial data
✔ Performed demographic trend analysis
✔ Structured queries in modular, readable format

🗂 Project Structure
Course_Project/
│
├── schema.sql
├── sample_queries.sql
├── full_dataset.sql
└── README.md


schema.sql → Database table structure

sample_queries.sql → Core analytical queries

full_dataset.sql → Complete dataset (large file; may not preview on GitHub)

### ⚙️ Requirements

MySQL 8+

Window function support enabled

### 🚀 How to Run This Project

Create a new MySQL database

Run schema.sql to create tables

Import data using full_dataset.sql

Execute queries from sample_queries.sql

### 💼 Real-World Relevance

This project simulates practical data analytics tasks such as:

Institutional performance benchmarking

Financial trend analysis

Player lifecycle analysis

Competitive ranking evaluation

Demographic trend reporting

Applicable to roles in:

Data Analytics

Business Intelligence

Financial Analysis

Sports Analytics

Freelance SQL Consulting

# 🎯 Author Note

This project demonstrates advanced SQL capabilities suitable for real-world analytical problem solving and freelance data work.