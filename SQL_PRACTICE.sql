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






