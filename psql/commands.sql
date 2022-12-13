-- brew services start postgresql@14
-- psql postgres
CREATE USER pg4e WITH PASSWORD 'thisisajoke';
CREATE DATABASE people WITH OWNER 'pg4e' ENCODING 'UTF8';
\dt
CREATE TABLE users(
    name VARCHAR(128),
    email VARCHAR(128)
);
\d+ users
-- psql -h HOST -p POSRT -U USER DB
CREATE TABLE pg4e_debug (
  id SERIAL,
  query VARCHAR(4096),
  result VARCHAR(4096),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
);

ALTER TABLE pg4e_debug ADD COLUMN neon553 INTEGER;

CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp()
BEFORE UPDATE ON keyvalue
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

UPDATE keyvalue SET howmuch=howmuch+1
WHERE post_id=1 AND account_id=1;