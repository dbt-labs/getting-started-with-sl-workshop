select
    order_date,
    sum(amount) as order_total
from {{ ref('fct_orders') }}
group by 1
