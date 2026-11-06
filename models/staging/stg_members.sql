SELECT
    cast(member_id AS integer) AS member_id,
    cast(scheme_id AS integer) AS scheme_id,
    cast(first_name AS varchar) AS first_name,
    cast(last_name AS varchar) AS last_name,
    cast(date_of_birth AS date) AS date_of_birth,
    cast(gender AS varchar) AS gender,
    cast(enrolled_on AS date) AS enrolled_on,
    cast(status AS varchar) AS member_status,
    upper(trim(cast(county AS varchar))) AS county
FROM {{ source('claims_raw', 'raw_members') }}
