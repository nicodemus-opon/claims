-- Grain: one row per claim_line_id.

select
    cl.claim_line_id,
    cl.claim_id,
    fc.member_id,
    fc.provider_id,
    fc.scheme_id,
    fc.service_date,
    cl.service_code,
    cl.service_description,
    cl.quantity,
    cl.unit_price,
    cl.line_amount
from {{ ref('stg_claim_lines') }} cl
left join {{ ref('fct_claims') }} fc on fc.claim_id = cl.claim_id