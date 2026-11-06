SELECT
    cast(claim_line_id AS integer) AS claim_line_id,
    cast(claim_id AS integer) AS claim_id,
    cast(service_code AS varchar) AS service_code,
    cast(service_description AS varchar) AS service_description,
    cast(quantity AS integer) AS quantity,
    cast(unit_price AS decimal(12, 2)) AS unit_price,
    cast(line_amount AS decimal(12, 2)) AS line_amount
FROM {{ source('claims_raw', 'raw_claim_lines') }}
