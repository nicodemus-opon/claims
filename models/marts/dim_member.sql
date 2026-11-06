select
    m.member_id,
    m.first_name || ' ' || m.last_name as full_name,
    m.gender,
    m.county as county,
    m.date_of_birth,
    m.enrolled_on,
    m.member_status,
    m.scheme_id
from {{ ref('stg_members') }} m