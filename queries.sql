-- ============================================================
-- SQL Practice Queries: Window Functions, Joins & BI Reporting
-- Built in SQLite
-- ============================================================

-- Total revenue by branch location in DESC order
SELECT  l.branch_name, 
        SUM(oi.quantity * oi.price_at_sale) AS total_revenue
FROM locations l
JOIN orders o ON l.location_id = o.location_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY l.branch_name
ORDER BY total_revenue DESC;

-- Q1 revenue by branch location, completed orders only
SELECT  l.branch_name, 
        SUM(oi.quantity * oi.price_at_sale) AS total_revenue
FROM locations l
JOIN orders o ON l.location_id = o.location_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
  AND o.order_date >= '2025-01-01'
  AND o.order_date < '2025-04-01'
GROUP BY l.branch_name
ORDER BY total_revenue DESC;


-- Month-over-month revenue change and cumulative revenue
WITH monthly_revenue AS (
    SELECT  strftime('%Y-%m', o.order_date) AS month,
            SUM(oi.quantity * oi.price_at_sale) AS total_revenue
    FROM orders o 
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY month
)
SELECT  month, 
        total_revenue, 
        LAG(total_revenue) OVER (ORDER BY month) AS prev_revenue, 
        total_revenue - LAG(total_revenue) OVER (ORDER BY month) AS mom_change, 
        ROUND(
            (total_revenue - LAG(total_revenue) OVER (ORDER BY month)) * 100.0 
            / LAG(total_revenue) OVER (ORDER BY month), 2
        ) AS mom_pct_change, 
        SUM(total_revenue) OVER (ORDER BY month) AS cumulative_revenue
FROM monthly_revenue;


-- Product revenue ranked within each category (partition by category)
SELECT  p.category,
        p.product_name,
        SUM(oi.quantity * oi.price_at_sale) AS product_revenue,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.price_at_sale) DESC) AS revenue_rank
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category, p.product_name
ORDER BY p.category, revenue_rank;


-- Top 5 customers by total revenue (top-N ranking)
SELECT  c.name,
        SUM(oi.quantity * oi.price_at_sale) AS customer_revenue,
        DENSE_RANK() OVER (ORDER BY SUM(oi.quantity * oi.price_at_sale) DESC) AS revenue_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.name
ORDER BY revenue_rank
LIMIT 5;


-- Distinct units ordered per customer
SELECT  c.name,
        COUNT(DISTINCT oi.product_id) AS distinct_products_ordered,
        SUM(oi.quantity) AS total_units_ordered
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.name
ORDER BY total_units_ordered DESC;
