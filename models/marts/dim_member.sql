SELECT
    m.member_id,
    m.gender,
    m.county,
    m.date_of_birth,
    m.enrolled_on,
    m.member_status,
    m.scheme_id,
    m.first_name || ' ' || m.last_name AS full_name
FROM {{ ref('stg_members') }} m
