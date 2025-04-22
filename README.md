# PizzaHut Sales Data Analysis Using SQL
![Pizza_Hutlogo](https://github.com/Gourangsharma/PizzaHut.sql/blob/main/294_pizza_hut_new_logo.webp)

## Overview
This project involves a comprehensive analysis of PizzaHut sales data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
- Analyze the sales of pizzas of different catgory.
- Identify the top selling pizzas.
- List and analyze the sales data based on pricing,category and sales.
- Explore and find the best sellers and best selling time period.

## Schema

```sql
create database pizzahut;

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);
```

## Business Problems and Solutions

### 1. Retrieve the total number of orders placed.
```sql
SELECT 
    COUNT(order_id) total_orders
FROM
    orders;
```

### 2.Calculate the total revenue generated from pizza sales.
```sql
SELECT 
    ROUND(SUM(o.quantity * p.price), 2) total_revenue
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id;
```

### 3.Identify the highest-priced pizza.
```sql
SELECT 
    p.name Highest_priced_pizza, p1.price
FROM
    pizza_types p
        JOIN
    pizzas p1 ON p.pizza_type_id = p1.pizza_type_id
ORDER BY p1.price DESC
LIMIT 1;
```
### Alternate Solution
```sql
SELECT 
    p.name Highest_priced_pizza, p1.price
FROM
    pizza_types p
        JOIN
    pizzas p1 ON p.pizza_type_id = p1.pizza_type_id
WHERE
    price >= (SELECT 
            MAX(price)
        FROM
            pizzas);
```


### 4.Identify the most common pizza size ordered.
```sql
SELECT 
    p.size size, COUNT(o.order_details_id) total_orders
FROM
    pizzas p
        JOIN
    order_details o ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY total_orders DESC
LIMIT 1;
```

### 5. List the top 5 most ordered pizza types along with their quantities.
```sql
with cte as(SELECT 
    p.pizza_type_id pizza_types, SUM(quantity) quantities
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id
GROUP BY p.pizza_type_id)

SELECT 
    p.name, quantities
FROM
    cte c
        JOIN
    pizza_types p ON c.pizza_types = p.pizza_type_id
ORDER BY quantities DESC
LIMIT 5;
```

### 6.Join the necessary tables to find the total quantity of each pizza category ordered.
```sql
SELECT 
    p1.category, SUM(o.quantity) quantity
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id
        JOIN
    pizza_types p1 ON p.pizza_type_id = p1.pizza_type_id
GROUP BY p1.category
ORDER BY quantity DESC;
```

### 7.Determine the distribution of orders by hour of the day.
```sql
SELECT 
    HOUR(order_time) hour, COUNT(order_id) orders
FROM
    orders
GROUP BY hour
ORDER BY hour ASC;
```

### 8.Join relevant tables to find the category-wise distribution of pizzas.
```sql
SELECT 
    category, COUNT(name) Total_pizzas
FROM
    pizza_types
GROUP BY category
ORDER BY Total_pizzas DESC;
```

### 9.Group the orders by date and calculate the average number of pizzas ordered per day.
```sql
SELECT 
    ROUND(AVG(quantity), 0) average_orders_per_day
FROM
    (SELECT 
        o.order_date, SUM(o1.quantity) quantity
    FROM
        orders o
    JOIN order_details o1 ON o.order_id = o1.order_id
    GROUP BY o.order_date) o;
```

### 10. Determine the top 3 most ordered pizza types based on revenue.
```sql
with cte as(SELECT 
    p.pizza_type_id pizza_types,
    SUM(o.quantity * p.price) revenue
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id
GROUP BY p.pizza_type_id)

SELECT 
    p.name, revenue
FROM
    cte c
        JOIN
    pizza_types p ON c.pizza_types = p.pizza_type_id
ORDER BY revenue DESC
LIMIT 3;
```

### 11.Calculate the percentage contribution of each pizza type to total revenue.
```sql
SELECT 
    p1.category,
    ROUND(((SUM(o.quantity * p.price)) / (SELECT 
                    (SUM(o.quantity * p.price))
                FROM
                    order_details o
                        JOIN
                    pizzas p ON o.pizza_id = p.pizza_id)) * 100,
            2) percentage_revenue
FROM
    pizza_types p1
        JOIN
    pizzas p ON p1.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY p1.category
ORDER BY percentage_revenue DESC;
```
### Alternate Solution
```sql
with cte as(SELECT 
    ROUND(((SUM(o.quantity * p.price)) / (SELECT 
                    (SUM(o.quantity * p.price)) total_revenue
                FROM
                    order_details o
                        JOIN
                    pizzas p ON o.pizza_id = p.pizza_id)) * 100,
            2) percentage_revenue,
    p.pizza_type_id pizza_types
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id
GROUP BY p.pizza_type_id)

SELECT 
    p.name, percentage_revenue
FROM
    cte c
        JOIN
    pizza_types p ON c.pizza_types = p.pizza_type_id
ORDER BY percentage_revenue DESC
```

### 12.Analyze the cumulative revenue generated over time.
```sql
SELECT order_date, SUM(revenue) over (order by order_date) cummulative_revenue
FROM
(SELECT 
    o.order_date, ROUND(SUM(o1.quantity * p.price), 2) revenue
FROM
    order_details o1
        JOIN
    pizzas p ON o1.pizza_id = p.pizza_id
        JOIN
    orders o ON o1.order_id = o.order_id
GROUP BY o.order_date) as s;
```

### 13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
```sql
with cte as
(select category ,name ,revenue, rank() over (partition by category order by revenue desc) as rn
from
(SELECT 
    p1.category,
    p1.name,
    ROUND(SUM(o.quantity * p.price), 2) revenue
FROM
    pizza_types p1
        JOIN
    pizzas p ON p1.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY p1.category , p1.name) as s)

SELECT 
    category, name, revenue
FROM
    cte
WHERE
    rn <= 3;
```

## Findings and Conclusion
- Content Distribution: The dataset contains a diverse range of pizzas with varying prices and categories.
- Common Ratings: Insights into the most common orders provide an understanding of the pizza's target audience.
- Categorization: Categorizing Pizzas based on specific keywords helps in understanding the types of pizzas available on PizzaHut.
- This analysis provides a comprehensive view of PizzaHut's pizzas and can help inform content strategy and decision-making.

## Author - Gourang Sharma
This project is a part of my portfolio, showcasing the SQL skills essential for data analyst roles.

## Thank You



