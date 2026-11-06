-- Claims where claim_amount disagrees with sum of lines.
-- Rows kept in fct_claims; flagged via line_amount_mismatch.
SELECT
    c.claim_id,
    c.claim_amount,
    l.line_count,
    c.current_status,
    coalesce(l.lines_total_amount, 0) AS lines_total_amount,
    c.claim_amount - coalesce(l.lines_total_amount, 0) AS diff
FROM {{ ref('fct_claims') }} c
LEFT JOIN {{ ref('int_claim_line_totals') }} l ON c.claim_id = l.claim_id
WHERE abs(c.claim_amount - coalesce(l.lines_total_amount, 0)) > 0.01
ORDER BY abs(c.claim_amount - coalesce(l.lines_total_amount, 0)) DESC
