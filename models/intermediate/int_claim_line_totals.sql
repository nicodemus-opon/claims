select
    claim_id,
    count(*) as line_count,
    coalesce(sum(line_amount), 0) as lines_total_amount,
    coalesce(sum(quantity * unit_price), 0) as lines_computed_amount
from {{ ref('stg_claim_lines') }}
group by claim_id