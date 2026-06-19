select
    order_date,
    count(order_id) as order_count
from {{ ref('fct_orders') }}
group by 1
