select
    cast(member_id as integer) as member_id,
    cast(scheme_id as integer) as scheme_id,
    cast(first_name as varchar) as first_name,
    cast(last_name as varchar) as last_name,
    cast(date_of_birth as date) as date_of_birth,
    cast(gender as varchar) as gender,
    upper(trim(cast(county as varchar))) as county,
    cast(enrolled_on as date) as enrolled_on,
    cast(status as varchar) as member_status
from {{ source('claims_raw', 'raw_members') }}
