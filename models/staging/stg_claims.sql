select
    cast(claim_id as integer) as claim_id,
    cast(member_id as integer) as member_id,
    cast(provider_id as integer) as provider_id,
    cast(service_date as date) as service_date,
    cast(submitted_at as timestamp) as submitted_at,
    cast(claim_amount as decimal(12, 2)) as claim_amount,
    cast(approved_amount as decimal(12, 2)) as approved_amount,
    cast(currency as varchar) as currency,
    case when approved_amount =0 then
    'REJECTED'
    when approved_amount is null then
    'AWAITING'
    when approved_amount >0 then
    'APPROVED'
    end as approval_status
from {{ source('claims_raw', 'raw_claims') }}
