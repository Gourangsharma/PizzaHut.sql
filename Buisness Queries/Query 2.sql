#Calculate the total revenue generated from pizza sales.

select round(sum(o.quantity*p.price), 2) total_revenue
from order_details o join pizzas p
on o.pizza_id = p.pizza_id;