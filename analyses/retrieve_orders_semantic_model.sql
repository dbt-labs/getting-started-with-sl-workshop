select
    order_id,
    customer_id,
    order_date,
    amount
from {{ ref('fct_orders') }}
order by order_date desc, order_id
