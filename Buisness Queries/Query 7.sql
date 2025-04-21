#Determine the distribution of orders by hour of the day.

select hour(order_time) hour, count(order_id) orders
from orders
group by hour
order by hour asc;
