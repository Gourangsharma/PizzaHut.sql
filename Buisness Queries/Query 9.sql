#Group the orders by date and calculate the average number of pizzas ordered per day.


select round(avg(quantity),0) average_orders_per_day from (
select o.order_date ,sum(o1.quantity) quantity
from orders o join order_details o1
on o.order_id=o1.order_id
group by o.order_date) o;

