select
    order_date,
    count(distinct customer_id) as customers_with_orders
from {{ ref('fct_orders') }}
group by 1
order by order_date desc
