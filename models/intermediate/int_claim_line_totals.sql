SELECT
    claim_id,
    count(*) AS line_count,
    coalesce(sum(line_amount), 0) AS lines_total_amount,
    coalesce(sum(quantity * unit_price), 0) AS lines_computed_amount
FROM {{ ref('stg_claim_lines') }}
GROUP BY claim_id
