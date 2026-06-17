{{ config(materialized='table') }}

with seconds as (

    {{
        dbt.date_spine(
            'second',
            "date_trunc('second', dateadd(second, -10, current_timestamp()))",
            "date_trunc('second', current_timestamp())"
        )
    }}

),

final as (
    select cast(date_second as timestamp) as second_timestamp
    from seconds
)

select * from final