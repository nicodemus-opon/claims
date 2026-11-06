-- Grain: one row per claim_id. All submissions are kept (no deduplication).
-- Duplicate-detection logic lives in analyses, not in this fact table.

SELECT
    c.claim_id,
    c.member_id,
    c.provider_id,
    m.scheme_id,
    c.service_date,
    c.submitted_at,
    c.claim_amount,
    c.approved_amount,
    c.currency,
    cs.current_status,
    cs.status_changed_at,
    adj.adjudicated_at,
    adj.turnaround_days,
    coalesce(lt.line_count, 0) AS line_count,
    coalesce(lt.lines_total_amount, 0) AS lines_total_amount,
    coalesce(
        lt.lines_total_amount IS NOT NULL
        AND abs(c.claim_amount - lt.lines_total_amount) > 0.01,
        FALSE
    ) AS line_amount_mismatch
FROM {{ ref('stg_claims') }} c
LEFT JOIN {{ ref('stg_members') }} m ON c.member_id = m.member_id
LEFT JOIN {{ ref('int_claim_current_status') }} cs ON c.claim_id = cs.claim_id
LEFT JOIN {{ ref('int_claim_adjudication') }} adj ON c.claim_id = adj.claim_id
LEFT JOIN {{ ref('int_claim_line_totals') }} lt ON c.claim_id = lt.claim_id
