with orders as (
    select *
    from {{ ref('fct_orders') }}
),

final as (
    select
        customer_id,
        date_trunc('month', order_date) as order_month,
        count(distinct order_id) as order_count,
        sum(amount) as order_amount,
        avg(amount) as avg_order_amount,
        max(amount) as max_order_amount,
        count(distinct case when amount > 20 then order_id end) as orders_over_20_count,
        sum(case when amount > 20 then amount else 0 end) as order_amount_over_20,
        count(distinct case when amount = 0 then order_id end) as zero_amount_orders_count
    from orders
    group by 1, 2
)

select *
from final
