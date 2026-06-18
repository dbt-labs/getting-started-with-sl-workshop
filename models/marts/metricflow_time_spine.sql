{{
    config(
        materialized = 'table',
    )
}}

with days as (

    {{
        dbt.date_spine(
            'day',
            "to_date('01/01/2000','mm/dd/yyyy')",
            "to_date('01/01/2027','mm/dd/yyyy')"
        )
    }}

),

final as (
    select 
        cast(date_day as date) as date_day,
        -- Option A: If your Fiscal Year matches the Calendar Year (Jan-Dec)
        extract(year from date_day) as fiscal_year_column
        
        -- Option B: If your Fiscal Year starts in July (e.g., Australian FY)
        -- case 
        --     when extract(month from date_day) >= 7 then extract(year from date_day) + 1
        --     else extract(year from date_day)
        -- end as fiscal_year_column
    from days
)

select * from final
where date_day > dateadd(year, -4, current_timestamp()) 
and date_day < dateadd(day, 30, current_timestamp())
