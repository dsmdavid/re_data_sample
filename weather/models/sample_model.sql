{{
    config(
        materialized='incremental',
        re_data_monitored=true,
        re_data_time_filter='DATE_VALID_STD',
        re_data_columns=['AVG_TEMPERATURE_AIR_2M_F','AVG_TEMPERATURE_DEWPOINT_2M_F','AVG_TEMPERATURE_FEELSLIKE_2M_F','AVG_TEMPERATURE_HEATINDEX_2M_F','AVG_TEMPERATURE_WETBULB_2M_F','AVG_TEMPERATURE_WINDCHILL_2M_F','MAX_TEMPERATURE_AIR_2M_F','MAX_TEMPERATURE_FEELSLIKE_2M_F','MAX_TEMPERATURE_HEATINDEX_2M_F','MAX_TEMPERATURE_WINDCHILL_2M_F','MIN_TEMPERATURE_DEWPOINT_2M_F','MIN_TEMPERATURE_FEELSLIKE_2M_F','MIN_TEMPERATURE_HEATINDEX_2M_F','MAX_TEMPERATURE_DEWPOINT_2M_F','MAX_TEMPERATURE_WETBULB_2M_F','MIN_TEMPERATURE_WINDCHILL_2M_F','MIN_TEMPERATURE_AIR_2M_F','MIN_TEMPERATURE_WETBULB_2M_F'],
        re_data_anomaly_detector={'name': 'z_score', 'threshold': 2.2},
        schema='original_dvd'
    )
}}

with forecast as (
    select * from {{ source('standard_tile', 'forecast_day') }}
)
select
    country,
    dateadd(day, -10, DATE_VALID_STD) as DATE_VALID_STD,
    {% for col in graph['nodes']['model.weather.sample_model']['config']['re_data_columns'] -%}
    avg( {{ col }} ) as {{ col }} {%- if not loop.last %},{%- endif %}
    {% endfor %}
from forecast
group by country, DATE_VALID_STD
   
