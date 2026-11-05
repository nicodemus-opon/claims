-- Savannah Informatics / Quintus - Data Engineering Assessment
-- Reference schema: simplified health claims warehouse

CREATE TABLE schemes (
    scheme_id     INTEGER PRIMARY KEY,
    scheme_name   VARCHAR,
    payer_name    VARCHAR,
    plan_tier     VARCHAR          -- 'bronze' | 'silver' | 'gold'
);

CREATE TABLE members (
    member_id     INTEGER PRIMARY KEY,
    scheme_id     INTEGER,
    first_name    VARCHAR,
    last_name     VARCHAR,
    date_of_birth DATE,
    gender        VARCHAR,
    county        VARCHAR,
    enrolled_on   DATE,
    status        VARCHAR          -- 'active' | 'suspended' | 'terminated'
);

CREATE TABLE providers (
    provider_id   INTEGER PRIMARY KEY,
    provider_name VARCHAR,
    provider_type VARCHAR,         -- 'hospital' | 'clinic' | 'pharmacy' | 'lab'
    county        VARCHAR,
    kmpdc_level   INTEGER          -- 2..6
);

CREATE TABLE claims (
    claim_id        INTEGER PRIMARY KEY,
    member_id       INTEGER,
    provider_id     INTEGER,
    service_date    DATE,
    submitted_at    TIMESTAMP,
    claim_amount    DECIMAL(12,2),   -- amount billed by the provider
    approved_amount DECIMAL(12,2),   -- amount the payer agreed to pay (NULL until adjudicated)
    currency        VARCHAR
);

CREATE TABLE claim_lines (
    claim_line_id       INTEGER PRIMARY KEY,
    claim_id            INTEGER,
    service_code        VARCHAR,
    service_description VARCHAR,
    quantity            INTEGER,
    unit_price          DECIMAL(12,2),
    line_amount         DECIMAL(12,2)
);

-- Append-only log. One row per status change. A claim's current status is its
-- most recent event.
CREATE TABLE claim_status_events (
    event_id    INTEGER PRIMARY KEY,
    claim_id    INTEGER,
    status      VARCHAR,          -- 'received' | 'in_review' | 'approved' | 'rejected' | 'paid'
    changed_at  TIMESTAMP,
    changed_by  VARCHAR
);
