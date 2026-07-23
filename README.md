# SQL Window Functions & BI Reporting Analysis

Practice SQL queries for a fictional Southern California ice cream chain, covering revenue reporting by location, month-over-month trends, product and customer ranking, and order-level metrics. Built to demonstrate window functions, CTEs, and multi-table joins.

Tested in SQLite.

## Files

* `schema.sql` — Table definitions (`locations`, `customers`, `products`, `orders`, `order_items`)
* `seed_data.sql` — Synthetic data generator (5 locations, 15 products, 1,000 customers, 50,000 orders) built using a recursive CTE
* `queries.sql` — Practice queries

## Quick Start

​```bash
sqlite3 database.db < schema.sql
sqlite3 database.db < seed_data.sql
sqlite3 database.db < queries.sql
​```

## Queries Included

1. **Total Revenue by Branch Location**  
   Aggregate revenue across a three-table join (`locations` -> `orders` -> `order_items`), ranked highest to lowest.

2. **Q1 Revenue by Branch (Completed Orders Only)**  
   Filters to completed orders within a specific date range using `WHERE ... AND`, showing branch performance for a defined reporting period.

3. **Month-over-Month Revenue Change & Cumulative Revenue**  
   Uses `LAG()` to compare each month to the prior month, calculates percent change, and tracks a running cumulative total with a window `SUM()`.

4. **Product Revenue Ranked Within Category**  
   `RANK()` partitioned by product category to see top performers within each group, rather than just overall.

5. **Top 5 Customers by Revenue**  
   Uses `DENSE_RANK()` to identify the highest-spending customers.

6. **Distinct Products and Total Units Ordered per Customer**  
   Uses `COUNT(DISTINCT ...)` alongside a summed quantity to analyze order variety versus order volume per customer.

## Notes

Data is synthetic and randomly generated for practice purposes. Figures are not meaningful on their own; the focus is entirely on query logic and structure.
