{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- if custom_schema_name is none -%}

        {{ target.schema }}

    {%- elif node.package_name == 'unified_mkt_platform'
          and (
              (target.name == 'dev'
               and target.database == 'marketing_dev')
              or
              (target.name == 'prod'
               and target.database == 'marketing_prod')
          ) -%}

        {{ custom_schema_name | trim }}

    {%- else -%}

        {{ target.schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}