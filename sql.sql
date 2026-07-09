use project_orders;

-- 1.What are the top 10 aisles with the highest number of products?;
SELECT a.aisle,COUNT(p.product_id) AS product_count
FROM aisles a
JOIN products p
ON a.aisle_id = p.aisle_id
GROUP BY a.aisle
ORDER BY product_count DESC
LIMIT 10;

-- 2.How many unique departments are there in the dataset?;
select  count(distinct department) from departments;

-- 3.What is the distribution of products across departments?
SELECT d.department,COUNT(p.product_id) AS product_count
FROM departments d
JOIN products p
ON d.department_id = p.department_id
GROUP BY d.department
ORDER BY product_count DESC;

-- 4.What are the top 10 products with the highest reorder rates?;
SELECT p.product_name,ROUND(AVG(op.reordered) * 100,2) AS reorder_rate
FROM products as p
JOIN order_products_train  as op
ON p.product_id = op.product_id
GROUP BY p.product_name
ORDER BY reorder_rate DESC
LIMIT 10;

-- 5.How many unique users have placed orders in the dataset?;
select count(distinct user_id)as users from orders;

-- 6.What is the average number of days between orders for each user?;
SELECT user_id,ROUND(AVG(days_since_prior_order), 2) AS avg_days_between_orders
FROM orders
WHERE days_since_prior_order IS NOT NULL
GROUP BY user_id;

-- 7.What are the peak hours of order placement during the day?;
select order_hour_of_day,COUNT(order_id) AS total_orders FROM orders
GROUP BY order_hour_of_day
ORDER BY total_orders DESC
LIMIT 5;

-- 8.How does order volume vary by day of the week?;
select order_dow,count(user_id) as total_orders from orders
group by order_dow
order by  total_orders desc;

-- 9. What are the top 10 most ordered products?;
SELECT p.product_name,COUNT(*) AS total_orders
FROM products p
JOIN order_products_train as o
    ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC
LIMIT 10;

-- 10.How many users have placed orders in each department?;
SELECT d.department,COUNT(DISTINCT o.user_id) AS unique_users
FROM departments d
JOIN products p
ON d.department_id = p.product_id
JOIN order_products_train op
ON p.product_id = op.product_id
JOIN orders o
ON op.order_id = o.order_id
GROUP BY d.department
ORDER BY unique_users DESC;

-- 11. What is the average number of products per order?;
SELECT AVG(product_count) AS avg_products_per_order
FROM (SELECT order_id,count(product_id) AS product_count
FROM order_products_train
GROUP BY order_id) gs;

-- 12.What are the most reordered products in each department?;;
SELECT d.department,p.product_name,COUNT(*) AS reorder_count
FROM departments d
JOIN products p
ON d.department_id = p.department_id
JOIN order_products_train op
ON p.product_id = op.product_id
WHERE op.reordered >1
GROUP BY d.department, p.product_name;

-- 13.How many products have been reordered more than once?
SELECT COUNT(*) AS products_reordered_more_than_once
FROM (SELECT product_id
FROM order_products_train
WHERE reordered = 1
GROUP BY product_id
HAVING COUNT(*) > 1
) gs;

-- 14.What is the average number of products added to the cart per order?
SELECT AVG(product_count) AS avg_products_per_order
FROM (SELECT order_id,
COUNT(*) AS product_count
FROM order_products_train
GROUP BY order_id) gs;

 -- 15.How does the number of orders vary by hour of the day?;
select order_hour_of_day,count(*) as total_orders from orders
group by order_hour_of_day
ORDER BY order_hour_of_day;

-- 16.what is the distribution of order sizes (number of products per order)?;
SELECT product_count,COUNT(*) AS number_of_orders
FROM (SELECT order_id,COUNT(*) AS product_count
FROM order_products_train
GROUP BY order_id) gs
GROUP BY product_count
ORDER BY product_count;

-- 17.What is the average reorder rate for products in each aisle?
SELECT a.aisle,AVG(op.reordered) AS avg_reorder_rate
FROM order_products_train op
JOIN products p
ON op.product_id = p.product_id
JOIN aisles a
ON p.aisle_id = a.aisle_id
GROUP BY a.aisle;

-- 18.How does the average order size vary by day of the week?
SELECT o.order_dow,AVG(t.order_size) AS avg_order_size
FROM orders o
JOIN (SELECT order_id,COUNT(*) AS order_size
FROM order_products_train
GROUP BY order_id) gs
ON o.order_id = t.order_id
GROUP BY o.order_dow
ORDER BY o.order_dow;

-- 19.What are the top 10 users with the highest number of orders?
SELECT user_id,COUNT(order_id) AS total_orders
FROM orders
GROUP BY user_id
ORDER BY total_orders DESC LIMIT 10;

-- 20.How many products belong to each aisle and department?
SELECT a.aisle,d.department,COUNT(p.product_id) AS total_products
FROM products p
JOIN aisles a
ON p.aisle_id = a.aisle_id
JOIN departments d
ON p.department_id = d.department_id
GROUP BY a.aisle, d.department
ORDER BY total_products DESC;







    