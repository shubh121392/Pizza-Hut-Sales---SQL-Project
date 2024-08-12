-- Retrieve the total number of orders placed --

select * from orders;
select count(order_id) as total_orders from orders;

-- Calculate the total revenue generated from pizza sales --
select * from order_details;
select * from pizzas;
select sum(order_details.quantity * pizzas.price) as total_revenue from order_details
join 
pizzas on order_details.pizza_id = pizzas.pizza_id; 

-- Identify the highest-priced pizza.--
select * from pizzas order by price desc limit 1;

-- Identify the most common pizza size ordered.--
select  pizzas.size, count(order_details.quantity) as common_pizza_size from order_details
join 
pizzas on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size
order by common_pizza_size desc
limit 1;

-- List the top 5 most ordered pizza types along with their quantities--
select * from pizza_types;
select  pizza_types.name, count(order_details.quantity) as total_quantity from order_details
join 
pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name
order by total_quantity desc
limit 5; 

-- Join the necessary tables to find the total quantity of each pizza category ordered.--
select * from pizza_types;
select * from order_details;
select sum(order_details.quantity) as total_quantity, pizza_types.category from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.category;

-- Determine the distribution of orders by hour of the day--
select * from orders;

## By Hours
SELECT EXTRACT(HOUR FROM time) AS order_hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY order_hour
ORDER BY order_hour;

## By Minutes
SELECT EXTRACT(Minute FROM time) AS order_minute_time, COUNT(order_id) AS order_count
FROM orders
GROUP BY order_minute_time
ORDER BY order_minute_time;

-- Join relevant tables to find the category-wise distribution of pizzas--
select * from pizzas;
select * from pizza_types;
select * from order_details;
select pizza_types.category, sum(order_details.quantity) as total_quantity from order_details
join 
pizzas on order_details.pizza_id = pizzas.pizza_id
join
pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by category
order by total_quantity;

-- Group the orders by date and calculate the average number of pizzas ordered per day.--
select * from orders;
select avg(order_id) as avg_orders, date from orders
group by date
order by avg_orders desc;

select * from orders;
select distinct extract(month from date) as date, avg(order_id) as avg_orders from orders
group by date
order by avg_orders desc;

-- Determine the top 3 most ordered pizza types based on revenue.--
select * from pizza_types;
select * from pizzas;
select * from order_details;
select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue from order_details
join 
pizzas on order_details.pizza_id = pizzas.pizza_id
join
pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name
order by revenue desc
limit 3;


-- Calculate the percentage contribution of each pizza type to total revenue.--

Select
pizza_types.category,
SUM(order_details.quantity * pizzas.price) / 
(Select 
SUM(order_details.quantity * pizzas.price) AS Total_revenue
FROM order_details 
JOIN 
pizzas ON pizzas.pizza_id = order_details.pizza_id * 100) AS revenue_percentage
from pizza_types 
JOIN 
pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id 
JOIN 
order_details
ON order_details.pizza_id=pizzas.pizza_id
Group by pizza_types.category
order by revenue_percentage desc;

