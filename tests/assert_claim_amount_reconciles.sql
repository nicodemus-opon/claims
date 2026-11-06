-- Reconciliation: claim_amount should agree with sum of its lines.
-- Warn only: source-data mismatches (14 in current data) are flagged in fct_claims
-- via line_amount_mismatch and triaged in analyses/claim_amount_mismatches.sql;
-- they do not block the run.
{{ config(severity='warn') }}

SELECT
    c.claim_id,
    c.claim_amount,
    coalesce(l.lines_total_amount, 0) AS lines_total_amount,
    c.claim_amount - coalesce(l.lines_total_amount, 0) AS diff
FROM {{ ref('stg_claims') }} c
LEFT JOIN {{ ref('int_claim_line_totals') }} l
    ON c.claim_id = l.claim_id
WHERE abs(c.claim_amount - coalesce(l.lines_total_amount, 0)) > 0.01
