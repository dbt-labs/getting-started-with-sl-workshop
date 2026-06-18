with customers as (
   select * from {{ ref('stg_customers')}}
),
orders as (
   select * from {{ ref('fct_orders')}}
),
customer_orders as (
   select
       customer_id as customer_id,
       min(order_date) as first_order_date,
       max(order_date) as most_recent_order_date,
       count(order_id) as number_of_orders,
       sum(amount) as lifetime_value
   from orders
   group by 1
),
final as (
   select
       customers.customer_id,
       customers.first_name,
       customers.last_name,
       customer_orders.first_order_date,
       customer_orders.most_recent_order_date,
       coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
       coalesce(customer_orders.lifetime_value, 0) as lifetime_value,
       case
           when coalesce(customer_orders.number_of_orders, 0) > 0 then 'true'
           else 'false'
       end as has_orders,
       case
           when coalesce(customer_orders.number_of_orders, 0) > 1 then 'true'
           else 'false'
       end as is_repeat_customer,
       case
           when coalesce(customer_orders.lifetime_value, 0) = 0 then 'no_value'
           when coalesce(customer_orders.lifetime_value, 0) < 50 then 'low'
           when coalesce(customer_orders.lifetime_value, 0) < 150 then 'medium'
           else 'high'
       end as customer_value_segment
   from customers
   left join customer_orders using (customer_id)
)
select * from final
