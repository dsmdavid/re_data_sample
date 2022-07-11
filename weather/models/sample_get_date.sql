{{
  config(
    schema = 'original_dvd'
    )
}}

{%- set get_max_date_query %}
select max(DATE_VALID_STD) from {{ source('standard_tile', 'forecast_day') }}
{% endset -%}

{%- set results = run_query(get_max_date_query) -%}

{%- if execute %}
    {# Return the first value #}
        {%- set max_date = results.columns[0].values()[0] -%}
    {% else %}
        {%- set max_date = none -%}
{% endif -%}
{%- set today_ = modules.datetime.date.today() -%}
{%- set yesterday_ = (today_ - modules.datetime.timedelta(1)) -%}
{%- set test_day = (today_ + modules.datetime.timedelta(14)) -%}


{{ log(flags.WHICH, info=True) }}
{%- if env_var('extend_schema_name',var('extend_schema_name',false)) %} 
    {{ log('extend_schema_name:\t' ~ env_var('extend_schema_name',var('extend_schema_name',false)), info = True )}}
{% else %}
    {{ log('extend_schema_name not set or falsyy', info= True )}}
{% endif %}

{%- if execute -%}
    {%- if test_day == max_date %}
        {{ log('yes, it is', info=True) }}
    {% endif -%}
{% endif -%}
{{ log('logging_end', info=True)}}

{%- if execute %}
{# Return the first value #}
    {%- set max_date = results.columns[0].values()[0] -%}
{% else %}
    {%- set max_date = none -%}
{% endif -%}
{{ log('max_date is '~max_date, info = True)}}
{%- if max_date == test_day %}
    {% set exists_user_rpt_data_for_yesterday = True %}
{% else %}
    {% set exists_user_rpt_data_for_yesterday = False %}
{% endif -%}

{%- if exists_user_rpt_data_for_yesterday %}
    {{ log('yes, it exists', info=True) }}
{% else %}
    {{ log('nope', info=True) }}
{% endif -%}


select least(
    current_date(),
    date('{{ max_date }}')
    ) as mx_date