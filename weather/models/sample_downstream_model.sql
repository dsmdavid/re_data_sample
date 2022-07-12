{{
  config(
    schema = 'original_dvd',
    materialized = 'view'
    )
}}

with source_ as (
    select * from {{ ref('sample_model') }}
)
select max(DATE_VALID_STD) as max_date from source_ /* mod */ 
 /* mod */ 
 /* mod */ 
 /* mod */ 
 /* mod */ 
