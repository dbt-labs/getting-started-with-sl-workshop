select
    customer_id,
    first_order_date,
    most_recent_order_date,
    number_of_orders,
    lifetime_value
from {{ ref('dim_customers') }}
where number_of_orders < 0
   or (number_of_orders = 0 and (first_order_date is not null or most_recent_order_date is not null))
   or (number_of_orders > 0 and (first_order_date is null or most_recent_order_date is null))
   or (first_order_date > most_recent_order_date)
