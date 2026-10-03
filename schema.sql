-- Schema inferred from the INSERT in the "UpsertLead" node.
-- Loaded automatically by Postgres on first start (see docker-compose.yml).

CREATE TABLE IF NOT EXISTS leads (
    id               SERIAL PRIMARY KEY,
    transaction_hash TEXT        NOT NULL UNIQUE,   -- md5(name || '_' || email || '_' || company)
    name             TEXT        NOT NULL,
    email            TEXT        NOT NULL,
    company          TEXT        NOT NULL,
    budget           NUMERIC,                       -- budget declared by the lead (optional)
    message          TEXT        NOT NULL,
    intent           TEXT,                          -- extracted by the LLM
    estimated_budget TEXT,                          -- extracted by the LLM, may be NULL or free text
    company_size     TEXT,
    urgency          TEXT,                          -- low | medium | high | unknown
    business_needs   JSONB,
    summary          TEXT,
    lead_score       INTEGER,                       -- 0-70 (budget up to 40 + urgency up to 30)
    priority         TEXT,                          -- BASSO | MEDIO | ALTO
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
