{% macro clone_database() -%}
    {%- set new_database_name = env_var('new_database_name', var('new_database_name', target.database )) | trim -%}
    {%- if new_database_name |upper == 'TEST_DVD_PIPELINE' -%}
        {{ log('Nothing to do, new_database_name is same as default', info = True) }}
    {%- else -%}
        {% do log('Ready to clone TEST_DVD_PIPELINE into '~new_database_name, info = True) %}
        {% set replace_query %} 
            CREATE OR REPLACE DATABASE {{ new_database_name }} CLONE TEST_DVD_PIPELINE;
        {% endset %}
        {% do run_query(replace_query) %}
        {% do log('Finished cloning TEST_DVD_PIPELINE into '~new_database_name, info = True) %}
    {%- endif -%}

{%- endmacro %}