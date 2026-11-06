-- view of claims where claim_amount does not match with sum of lines.
-- Rows are NOT dropped from fct_claims; they are flagged via line_amount_mismatch.
select
    c.claim_id,
    c.claim_amount,
    coalesce(l.lines_total_amount, 0) as lines_total_amount,
    c.claim_amount - coalesce(l.lines_total_amount, 0) as diff,
    l.line_count,
    c.current_status
from {{ ref('fct_claims') }} c
left join {{ ref('int_claim_line_totals') }} l on l.claim_id = c.claim_id
where abs(c.claim_amount - coalesce(l.lines_total_amount, 0)) > 0.01
order by abs(c.claim_amount - coalesce(l.lines_total_amount, 0)) desc