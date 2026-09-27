--Assignment Tasks


--Task 1 — Build the Sales Detail Dataset (6 marks)
--Management needs a detailed sales dataset for analysis. Return one row per order item containing:
--order_id and order_date
--customer full name
--store name
--staff full name
--product name
--category name
--brand name
--quantity, list_price, discount
--calculated net_line_revenue

select 
    p.product_name,
    b.brand_name,
    c.first_name + ' ' + c.last_name as customer_full_name,
    s.first_name + ' ' + s.last_name as staff_full_name,
    o.order_date,
    oi.order_id,
    oi.quantity,
    oi.list_price,
    oi.discount,
    oi.quantity * oi.list_price * (1 - oi.discount) as net_line_revenue

from production.products as p
join production.brands as b 
 on p.brand_id = b.brand_id
join sales.order_items as oi 
 on oi.product_id = p.product_id
join sales.orders as o 
 on o.order_id = oi.order_id
join sales.customers as c 
 on o.customer_id = c.customer_id
join sales.staffs as s 
 on o.staff_id = s.staff_id;



--Task 2 — Store Performance Summary (5 marks)
--Create a store-level performance report for completed orders showing:
--store name
--number of distinct orders
--total units sold
--total net revenue
--average order value

--Return one row per store and order the stores from highest to lowest total net revenue.



--Task 3 — High-Value Customers (5 marks)
--Management wants to identify high-value customers. Return customers whose total completed-order spending
--is greater than the average total spending of customers who have completed orders.

--Show customer_id, customer name, completed order count, and total spending. Order the result by total spending descending.

with customer_spending as (
    select
        c.customer_id,
        c.first_name + ' ' + c.last_name as customer_name,
        COUNT(o.order_id) as completed_order_count,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_spending
    from sales.customers c
    join sales.orders o on c.customer_id = o.customer_id
    join sales.order_items oi on o.order_id = oi.order_id
    group by c.customer_id, c.first_name, c.last_name
)
select
    customer_id,
    customer_name,
    completed_order_count,
    total_spending
from customer_spending
where total_spending > (select AVG(total_spending) from customer_spending)
order by total_spending desc;