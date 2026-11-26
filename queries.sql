use shop_project;
-- Q1: Revenue per Customer.
select customers.customer_id, customers.customer_name,
coalesce(sum(orders.quantity*products.unit_price), 0) as total_revenue
from customers
left join orders
on customers.customer_id = orders.customer_id
left join products
on orders.product_id = products.product_id
group by customers.customer_id, customers.customer_name
order by total_revenue desc;

-- Q2: Revenue Per Category.
select products.category, 
coalesce(sum(orders.quantity*products.unit_price), 0) as total_revenue
from products
left join orders
on products.product_id = orders.product_id
group by products.category
order by total_revenue desc;

-- Q3: top 5 products by quantity sold.
select products.product_id, products.product_name,sum(orders.quantity)as total_quantity
from products
inner join orders
on products.product_id = orders.product_id
group by products.product_id, products.product_name
order by total_quantity desc
limit 5;

-- Q4:Customers who have never ordered.
select customers.customer_id , 
customers.customer_name,
customers.city
from customers
left join orders
on customers.customer_id = orders.customer_id
where orders.order_id is null;

-- Q5: Products that never sold
select 
products.product_id,
products.product_name,
products.category,
products.unit_price
from products
left join orders
on products.product_id = orders.product_id
where orders.order_id is null;

-- Q6: orders with no matching customer
select
orders.order_id,
orders.customer_id,
orders.quantity,
orders.product_id
from orders
left join customers
on orders.customer_id = customers.customer_id
where customers.customer_id is null;

-- Q7: customers above average revenue (customers who ordered)
with customer_revenue as (
    select customers.customer_id,
           customers.customer_name,
           sum(orders.quantity * unit_price) as total_revenue
    from customers
    inner join orders
        on orders.customer_id = customers.customer_id
    inner join products
        on products.product_id = orders.product_id
    group by customers.customer_id,
             customers.customer_name
)                                           
select customer_id,     
       customer_name,                      
       total_revenue
from customer_revenue
where total_revenue > (select avg(total_revenue)
                       from customer_revenue)
order by total_revenue desc;

-- Q8: big vs small orders per customer
select 
customers.customer_id,
customers.customer_name,
sum(case when orders.quantity >= 3 then 1 else 0 end )as Big_orders,
sum(case when orders.quantity <3 then 1 else 0 end )as Small_orders
from customers
left join orders
on orders.customer_id = customers.customer_id
group by customers.customer_id,
customers.customer_name;

-- Q9: customer activity labels
select 
customers.customer_id,
customers.customer_name,
case
 when count( orders.order_id) >= 8 then 'Active'
when count(orders.order_id) >=1 then 'Low Activity' else 'No orders'end as Activity_Label
from customers
left join orders
on orders.customer_id = customers.customer_id 
group by customers.customer_id,
customers.customer_name;

-- Q10: Revenue by city
select
customers.city,
sum(orders.quantity*unit_price) as total_revenue
from customers
inner join orders
on customers.customer_id = orders.customer_id
inner join products
on orders.product_id = products.product_id
group by customers.city
order by total_revenue desc;