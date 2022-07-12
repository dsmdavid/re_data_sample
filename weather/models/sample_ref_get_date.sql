{{
  config(
    materialized = 'view',
    schema = 'original_dvd'
    )
}}
with ref1 as (
select * from {{ ref('sample_get_date') }}
)
select * from ref1