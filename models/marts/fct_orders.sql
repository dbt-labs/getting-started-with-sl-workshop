with orders as  (
   select * from {{ ref('stg_orders' )}}
),


payments as (
   select * from {{ ref('stg_payments') }}
),


order_payments as (
   select
       order_id,
       sum(case when status = 'success' then amount end) as amount


   from payments
   group by 1
),


final as (


   select
       orders.order_id,
       orders.customer_id,
       orders.order_date,
       coalesce(order_payments.amount, 0) as amount,
       case
           when coalesce(order_payments.amount, 0) = 0 then 'zero'
           when coalesce(order_payments.amount, 0) <= 20 then '1_20'
           when coalesce(order_payments.amount, 0) <= 50 then '21_50'
           else '50_plus'
       end as amount_band,
       case
           when coalesce(order_payments.amount, 0) > 20 then 'true'
           else 'false'
       end as is_order_over_20,
       case
           when coalesce(order_payments.amount, 0) = 0 then 'true'
           else 'false'
       end as is_zero_amount_order


   from orders
   left join order_payments using (order_id)
)


select * from final
