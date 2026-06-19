select
    customer_id,
    sum(amount) as order_total,
    count(order_id) as order_count,
    min(order_date) as first_order_date,
    max(order_date) as most_recent_order_date
from {{ ref('fct_orders') }}
group by 1
