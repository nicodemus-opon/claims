select
    cast(claim_line_id as integer) as claim_line_id,
    cast(claim_id as integer) as claim_id,
    cast(service_code as varchar) as service_code,
    cast(service_description as varchar) as service_description,
    cast(quantity as integer) as quantity,
    cast(unit_price as decimal(12, 2)) as unit_price,
    cast(line_amount as decimal(12, 2)) as line_amount
from {{ source('claims_raw', 'raw_claim_lines') }}
