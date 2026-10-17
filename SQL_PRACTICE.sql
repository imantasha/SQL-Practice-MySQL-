show databases;
use sql_practice;
-- Retrieve all columns from `customers`.
SELECT * from customers;

-- 2. Get `first_name`, `last_name`, `city` for customers in the `"Corporate"` segment. 
SELECT first_name, last_name,city FROM customers WHERE segment ="Corporate";

-- 3. Find all orders with `order_status = 'Cancelled'`.
SELECT order_id FROM  orders Where  order_status ="Cancelled";

--  4. List products priced above 20000, sorted by `unit_price` descending.
SELECT product_name FROM products where cost_price > 20000  Order by unit_price desc;

-- 5. Find customers who signed up after `'2023-01-01'`.
SELECT first_name, last_name  ,signup_date FROM customers WHERE signup_date > "2023-01-01";

-- 6. Get distinct `country` values from `customers`.
SELECT distinct(country) From customers;

-- 7. Find orders placed using `'UPI'` or `'Wallet'` (use `IN`).
SELECT order_id , payment_method FROM orders WHERE payment_method IN ("UPI","Wallet");

--  8. Find products with `stock_quantity` between 0 and 20 (use `BETWEEN`).
SELECT product_name , stock_quantity FROM products WHERE stock_Quantity BETWEEN 0 AND 20;

-- 9. Find customers whose email contains `'gmail'`... 
-- (there's none here — try `email LIKE '%1%'` instead, or search `product_name LIKE '%Laptop%'`).
SELECT first_name,last_name , email FROM customers WHERE email like "%gmail%" ;
SELECT *
FROM products
WHERE product_name LIKE '%Laptop%';

SELECT *
FROM customers
WHERE email LIKE '%1%';


-- 10. Get the top 10 highest-value orders
SELECT *
FROM order_items
ORDER BY quantity DESC
LIMIT 10;

-- 11 Count total number of orders.
SELECT  count(*) order_total  FROM orders ;

-- 12. Find total revenue (`SUM(order_total)`) from all delivered orders.
SELECT SUM(order_total) as total_revenue FROM orders WHERE order_status ="Delivered";


-- 13. Find average `unit_price` per `category` in `products`.
SELECT category , AVG(unit_price) AS Average_unit_price FROM products Group by category;

-- 14. Count number of orders per `order_status`.
SELECT order_status ,count(*) order_total FROM orders Group by order_status;

-- 15. Find total quantity sold per `product_id` (from `order_items`).
SELECT product_id , SUM(quantity) AS total_quantity_sold FROM  order_items group by product_id;

-- 16. Find number of customers per `country`.
SELECT country , Count(*) customer_id FROM customers GROUP BY country;

-- 17. Find categories where average unit price is above 5000 (use `HAVING`).

SELECT category, AVG(unit_price) AS average_unit_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 5000;



-- 18. Find employees who have handled more than 150 orders (`GROUP BY employee_id HAVING COUNT(*) > 150`).
SELECT employee_id, COUNT(*) AS order_count
FROM orders
GROUP BY employee_id
HAVING COUNT(*) > 150; 



-- 19. Find the minimum and maximum `order_total` per `payment_method`.
SELECT payment_method , MIN(order_total) AS minimum_order_total , MAX(order_total) AS maximum_order_total FROM orders group by payment_method;


-- 20. Find total revenue per month (`GROUP BY strftime('%Y-%m', order_date)` in SQLite, or `DATE_FORMAT` in MySQL).
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(order_total) AS total_revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- 8. Data Analysis / Business Questions (for your portfolio write-up)


-- ## 3. JOINs
-- 21. `INNER JOIN` `orders` with `customers` to show customer name next to each order.
SELECT 
    o.order_id,
    c.first_name,
    c.last_name,
    o.order_total
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;


-- 22. `INNER JOIN` `order_items` with `products` to show product name, quantity, and line total.
SELECT 
	o.order_id,
    o.quantity,
    o.line_total,
    p.product_name
FROM order_items o
Inner Join products p
	 ON o.product_id = p.product_id
     order by o.order_id;

-- 23. Three-way join: `orders` + `customers` + `order_items` to show which customer bought what.
SELECT o.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       oi.product_id, oi.quantity, oi.line_total
FROM orders o
INNER JOIN customers c    ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON oi.order_id = o.order_id
ORDER BY o.order_id;
 
-- 23. Employees with zero orders
-- (expected: 0 rows, every employee has handled orders)
SELECT e.employee_id, e.employee_name
FROM employees e
LEFT JOIN orders o ON o.employee_id = e.employee_id
WHERE o.order_id IS NULL;
 
-- 24. Products that were never ordered
-- (expected: 0 rows, every product appears in order_items)
SELECT p.product_id, p.product_name, p.category
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;
 
-- 25. Total revenue per employee
SELECT e.employee_id, e.employee_name,
       ROUND(SUM(o.order_total), 2) AS total_revenue
FROM employees e
INNER JOIN orders o ON o.employee_id = e.employee_id
GROUP BY e.employee_id, e.employee_name
ORDER BY total_revenue DESC;
 
-- 26. Total spend per customer per category
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       p.category,
       ROUND(SUM(oi.line_total), 2) AS total_spend
FROM customers c
INNER JOIN orders o       ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON oi.order_id = o.order_id
INNER JOIN products p     ON p.product_id = oi.product_id
GROUP BY c.customer_id, customer_name, p.category
ORDER BY c.customer_id, total_spend DESC;
 
-- 27. Pairs of customers from the same city
-- (a.customer_id < b.customer_id keeps each pair once; use <> for both directions)
SELECT a.customer_id AS customer_a,
       b.customer_id AS customer_b,
       a.city
FROM customers a
JOIN customers b
  ON a.city = b.city
 AND a.customer_id < b.customer_id
ORDER BY a.city, customer_a, customer_b;
 
 
-- =====================================================================
-- 4. SUBQUERIES
-- =====================================================================
 
-- 29. Customers with more orders than the average per customer
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(cnt)
    FROM (SELECT COUNT(*) AS cnt FROM orders GROUP BY customer_id) t
)
ORDER BY order_count DESC;
 
-- 30. Products priced above the average unit_price of their own category
SELECT p.product_id, p.product_name, p.category, p.unit_price
FROM products p
WHERE p.unit_price > (
    SELECT AVG(p2.unit_price)
    FROM products p2
    WHERE p2.category = p.category
)
ORDER BY p.category, p.unit_price DESC;
 
-- 31. Customer(s) with the single highest total spend
SELECT c.customer_id, c.first_name, c.last_name,
       ROUND(SUM(o.order_total), 2) AS total_spend
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.order_total) = (
    SELECT MAX(spend)
    FROM (SELECT SUM(order_total) AS spend FROM orders GROUP BY customer_id) t
);
 
-- 32. Orders above the average order_total
SELECT order_id, customer_id, order_total
FROM orders
WHERE order_total > (SELECT AVG(order_total) FROM orders)
ORDER BY order_total DESC;
 
-- 33. Employees whose handled revenue is below the average across employees
SELECT e.employee_id, e.employee_name,
       ROUND(SUM(o.order_total), 2) AS revenue
FROM employees e
JOIN orders o ON o.employee_id = e.employee_id
GROUP BY e.employee_id, e.employee_name
HAVING SUM(o.order_total) < (
    SELECT AVG(rev)
    FROM (SELECT SUM(order_total) AS rev FROM orders GROUP BY employee_id) t
)
ORDER BY revenue;
 
-- 34. Customers who have never placed an order (NOT EXISTS)
-- (expected: 1 customer)
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);
 
 
-- =====================================================================
-- 5. WINDOW FUNCTIONS
-- =====================================================================
 
-- 35. Rank customers by total spend
SELECT customer_id,
       ROUND(SUM(order_total), 2) AS total_spend,
       RANK()       OVER (ORDER BY SUM(order_total) DESC) AS spend_rank,
       DENSE_RANK() OVER (ORDER BY SUM(order_total) DESC) AS spend_dense_rank
FROM orders
GROUP BY customer_id
ORDER BY spend_rank;
 
-- 36. Each customer's most recent order
SELECT order_id, customer_id, order_date, order_total
FROM (
    SELECT o.*,
           ROW_NUMBER() OVER (PARTITION BY customer_id
                              ORDER BY order_date DESC, order_id DESC) AS rn
    FROM orders o
) t
WHERE rn = 1;
 
-- 37. Running total of revenue over time
-- (a) per order. Orders on the same date share one running value because
--     the default frame is RANGE.
SELECT order_id, order_date, order_total,
       SUM(order_total) OVER (ORDER BY order_date) AS running_revenue
FROM orders;
 
-- (b) cleaner for a chart: per day
SELECT order_date,
       ROUND(SUM(order_total), 2) AS daily_revenue,
       ROUND(SUM(SUM(order_total)) OVER (ORDER BY order_date), 2) AS running_revenue
FROM orders
GROUP BY order_date;
 
-- 38. Compare each order to the customer's previous (LAG) and next (LEAD) order
SELECT customer_id, order_id, order_date, order_total,
       LAG(order_total)  OVER w AS prev_order_total,
       order_total - LAG(order_total) OVER w AS change_vs_prev,
       LEAD(order_total) OVER w AS next_order_total
FROM orders
WINDOW w AS (PARTITION BY customer_id ORDER BY order_date, order_id);
 
-- 39. Spending quartiles with NTILE(4)  (1 = top spenders)
SELECT customer_id, total_spend,
       NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile
FROM (
    SELECT customer_id, ROUND(SUM(order_total), 2) AS total_spend
    FROM orders
    GROUP BY customer_id
) t;
 
-- 40. Product rank within its category by total quantity sold
SELECT category, product_name, total_qty,
       RANK() OVER (PARTITION BY category ORDER BY total_qty DESC) AS rank_in_category
FROM (
    SELECT p.category, p.product_name, SUM(oi.quantity) AS total_qty
    FROM products p
    JOIN order_items oi ON oi.product_id = p.product_id
    GROUP BY p.product_id, p.category, p.product_name
) t
ORDER BY category, rank_in_category;
 
-- 41. 3-order moving average of order_total per customer
SELECT customer_id, order_id, order_date, order_total,
       ROUND(AVG(order_total) OVER (
           PARTITION BY customer_id
           ORDER BY order_date, order_id
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS moving_avg_3
FROM orders;
 
 
-- =====================================================================
-- 6. DATE & STRING FUNCTIONS
-- =====================================================================
 
-- 42. Orders per year-month
SELECT YEAR(order_date)  AS order_year,
       MONTH(order_date) AS order_month,
       COUNT(*)          AS order_count
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;
 
-- 43. Average days between order_date and ship_date
-- (only orders that have shipped; Cancelled/Returned/Processing have no ship_date)
SELECT ROUND(AVG(DATEDIFF(ship_date, order_date)), 2) AS avg_days_to_ship
FROM orders
WHERE ship_date IS NOT NULL;
 
-- 44. Weekend vs weekday orders
SELECT CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
       COUNT(*) AS order_count,
       ROUND(SUM(order_total), 2) AS revenue
FROM orders
GROUP BY day_type;
 
-- 45. Build full_name
SELECT customer_id,
       CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;
 
-- 46. Standardize city names (trim + UPPER, and proper case)
-- (your city values are already clean, so original and standardized will match)
SELECT customer_id,
       city AS original_city,
       UPPER(TRIM(city)) AS city_upper,
       CONCAT(UPPER(LEFT(TRIM(city), 1)), LOWER(SUBSTRING(TRIM(city), 2))) AS city_proper
FROM customers;
 
-- 47. Customers whose email domain is example.com
-- (every customer has this domain, so expect all 600 rows)
SELECT customer_id, email,
       SUBSTRING(email, INSTR(email, '@') + 1) AS email_domain
FROM customers
WHERE SUBSTRING(email, INSTR(email, '@') + 1) = 'example.com';
 
 
-- =====================================================================
-- 7. CASE STATEMENTS
-- =====================================================================
 
-- 48. Order value label
SELECT order_id, order_total,
       CASE
           WHEN order_total > 10000 THEN 'High Value'
           WHEN order_total >= 2000 THEN 'Medium'
           ELSE 'Low'
       END AS order_value_label
FROM orders;
 
-- 49. Customer age groups
SELECT customer_id, age,
       CASE
           WHEN age BETWEEN 18 AND 25 THEN '18-25'
           WHEN age BETWEEN 26 AND 40 THEN '26-40'
           WHEN age BETWEEN 41 AND 60 THEN '41-60'
           WHEN age > 60 THEN '60+'
           ELSE 'Unknown'
       END AS age_group
FROM customers;
 
-- 50. Flag delayed orders (shipped more than 5 days after order date)
SELECT order_id, order_date, ship_date,
       DATEDIFF(ship_date, order_date) AS days_to_ship,
       CASE WHEN DATEDIFF(ship_date, order_date) > 5 THEN 'Delayed' ELSE 'On Time' END AS ship_flag
FROM orders
WHERE ship_date IS NOT NULL;
 
 
-- =====================================================================
-- 8. BUSINESS QUESTIONS
-- =====================================================================
 
-- 51. Category with the most revenue (excluding Cancelled and Returned orders)
SELECT p.category, ROUND(SUM(oi.line_total), 2) AS revenue
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned')
GROUP BY p.category
ORDER BY revenue DESC;
 
-- 52. Top 10 best sellers by quantity (excluding Cancelled and Returned orders)
SELECT p.product_name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned')
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC
LIMIT 10;
 
-- 53. Month-over-month revenue for the last 2 years of data
-- (anchored to the latest order date, 2025-12-31, so this covers 2024-2025)
WITH monthly AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
           SUM(order_total) AS revenue
    FROM orders
    WHERE order_status NOT IN ('Cancelled', 'Returned')
      AND order_date > DATE_SUB((SELECT MAX(order_date) FROM orders), INTERVAL 24 MONTH)
    GROUP BY month
)
SELECT month,
       ROUND(revenue, 2) AS revenue,
       ROUND(LAG(revenue) OVER (ORDER BY month), 2) AS prev_month_revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 2) AS mom_growth_pct
FROM monthly
ORDER BY month;
 
-- 54. Segment with the highest average order value
SELECT c.segment, ROUND(AVG(o.order_total), 2) AS avg_order_value
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.segment
ORDER BY avg_order_value DESC;
 
-- 55. Cancellation / return rate by ship_mode
SELECT ship_mode,
       COUNT(*) AS total_orders,
       SUM(order_status IN ('Cancelled', 'Returned')) AS cancelled_or_returned,
       ROUND(100 * SUM(order_status IN ('Cancelled', 'Returned')) / COUNT(*), 2) AS cancel_return_rate_pct
FROM orders
GROUP BY ship_mode
ORDER BY cancel_return_rate_pct DESC;
 
-- 56. Top revenue region (via employees; excluding Cancelled and Returned orders)
SELECT e.region, ROUND(SUM(o.order_total), 2) AS revenue
FROM orders o
JOIN employees e ON e.employee_id = o.employee_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned')
GROUP BY e.region
ORDER BY revenue DESC;
 
-- 57. Retention: customers who ordered in more than one calendar year
SELECT COUNT(*) AS retained_customers
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(DISTINCT YEAR(order_date)) > 1
) t;
 
-- 57b. Breakdown: customers by number of distinct years they ordered in
SELECT active_years, COUNT(*) AS customers
FROM (
    SELECT customer_id, COUNT(DISTINCT YEAR(order_date)) AS active_years
    FROM orders
    GROUP BY customer_id
) t
GROUP BY active_years
ORDER BY active_years;
 
-- 58a. Average discount and average quantity per category
SELECT p.category,
       ROUND(AVG(oi.discount_percent), 2) AS avg_discount_pct,
       ROUND(AVG(oi.quantity), 2)         AS avg_quantity
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY avg_discount_pct DESC;
 
-- 58b. Does a higher discount mean higher quantity? Grouped by discount level
SELECT discount_percent,
       COUNT(*) AS line_items,
       ROUND(AVG(quantity), 3) AS avg_quantity
FROM order_items
GROUP BY discount_percent
ORDER BY discount_percent;
 
-- 58c. Pearson correlation between discount and quantity (MySQL has no CORR())
SELECT ROUND(
    (COUNT(*) * SUM(discount_percent * quantity) - SUM(discount_percent) * SUM(quantity))
    / SQRT(
        (COUNT(*) * SUM(discount_percent * discount_percent) - POW(SUM(discount_percent), 2)) *
        (COUNT(*) * SUM(quantity * quantity) - POW(SUM(quantity), 2))
      ), 4) AS discount_quantity_correlation
FROM order_items;
 
-- 59a. Top 5% of customers by spend (NTILE(20): bucket 1 = top 5%)
WITH spend AS (
    SELECT customer_id, SUM(order_total) AS total_spend
    FROM orders
    GROUP BY customer_id
),
bucketed AS (
    SELECT customer_id, total_spend,
           NTILE(20) OVER (ORDER BY total_spend DESC) AS bucket
    FROM spend
)
SELECT customer_id, ROUND(total_spend, 2) AS total_spend
FROM bucketed
WHERE bucket = 1
ORDER BY total_spend DESC;
 
-- 59b. Pareto check: share of revenue from the top 5% and top 20% of customers
WITH spend AS (
    SELECT customer_id, SUM(order_total) AS total_spend
    FROM orders
    GROUP BY customer_id
),
ranked AS (
    SELECT customer_id, total_spend,
           NTILE(20) OVER (ORDER BY total_spend DESC) AS bucket
    FROM spend
)
SELECT ROUND(100 * SUM(CASE WHEN bucket = 1 THEN total_spend END) / SUM(total_spend), 2) AS top_5pct_share,
       ROUND(100 * SUM(CASE WHEN bucket <= 4 THEN total_spend END) / SUM(total_spend), 2) AS top_20pct_share
FROM ranked;
 
-- 60. RFM summary per customer
-- Recency is measured from the latest order date in the data (2025-12-31),
-- not CURDATE(), because the dataset is historical.
SELECT o.customer_id,
       DATEDIFF((SELECT MAX(order_date) FROM orders), MAX(o.order_date)) AS recency_days,
       COUNT(o.order_id)           AS frequency,
       ROUND(SUM(o.order_total), 2) AS monetary
FROM orders o
GROUP BY o.customer_id
ORDER BY monetary DESC;
 
-- 60b. Optional: score each RFM dimension 1-4 with NTILE (4 = best)
WITH rfm AS (
    SELECT customer_id,
           DATEDIFF((SELECT MAX(order_date) FROM orders), MAX(order_date)) AS recency_days,
           COUNT(order_id)  AS frequency,
           SUM(order_total) AS monetary
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id, recency_days, frequency, ROUND(monetary, 2) AS monetary,
       NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
       NTILE(4) OVER (ORDER BY frequency ASC)     AS f_score,
       NTILE(4) OVER (ORDER BY monetary ASC)      AS m_score
FROM rfm;
 

