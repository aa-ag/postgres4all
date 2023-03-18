CREATE TABLE IF NOT EXISTS swapi (
    id SERIAL,
    body JSONB,
    url VARCHAR(2048),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ 
)