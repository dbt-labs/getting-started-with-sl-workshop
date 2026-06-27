{{ config(materialized='table') }}

with orders as (
    select *
    from {{ ref('fct_orders') }}
),

daily_metrics as (
    select
        order_date,
        sum(amount) as revenue,
        count(distinct order_id) as distinct_orders,
        sum(case when amount >= 20 then 1 else 0 end) as orders_over_20
    from orders
    group by 1
)

select
    order_date,
    revenue,
    distinct_orders,
    orders_over_20,
    orders_over_20::float / nullif(distinct_orders, 0) as large_orders_percentage_derived
from daily_metrics
