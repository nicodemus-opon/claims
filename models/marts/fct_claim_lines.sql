-- Grain: one row per claim_line_id.

SELECT
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
FROM {{ ref('stg_claim_lines') }} cl
LEFT JOIN {{ ref('fct_claims') }} fc ON cl.claim_id = fc.claim_id
