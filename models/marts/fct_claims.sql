-- Grain: one row per claim_id. All submissions are kept (no deduplication).
-- Duplicate-detection logic lives in analyses, not in this fact table.

select
    c.claim_id,
    c.member_id,
    c.provider_id,
    m.scheme_id,
    c.service_date,
    c.submitted_at,
    c.claim_amount,
    c.approved_amount,
    c.currency,
    coalesce(lt.line_count, 0) as line_count,
    coalesce(lt.lines_total_amount, 0) as lines_total_amount,
    case
        when lt.lines_total_amount is not null
             and abs(c.claim_amount - lt.lines_total_amount) > 0.01
        then true else false
    end as line_amount_mismatch,
    cs.current_status,
    cs.status_changed_at,
    adj.adjudicated_at,
    adj.turnaround_days
from {{ ref('stg_claims') }} c
left join {{ ref('stg_members') }} m on m.member_id = c.member_id
left join {{ ref('int_claim_current_status') }} cs on cs.claim_id = c.claim_id
left join {{ ref('int_claim_adjudication') }} adj on adj.claim_id = c.claim_id
left join {{ ref('int_claim_line_totals') }} lt on lt.claim_id = c.claim_id