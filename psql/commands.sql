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

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON keyvalue
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TABLE album (
  id SERIAL,
  title VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE track (
    id SERIAL,
    title VARCHAR(128),
    len INTEGER, rating INTEGER, count INTEGER,
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    UNIQUE(title, album_id),
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS track_raw;
CREATE TABLE track_raw
 (title TEXT, artist TEXT, album TEXT, album_id INTEGER,
  count INTEGER, rating INTEGER, len INTEGER);

\copy track_raw(title, artist, album, album_id, count, rating, len)
FROM 'https://www.pg4e.com/tools/sql/library.csv?PHPSESSID=8f5c77ffec4ef4533f25accba9df14aa%22'
DELIMITER ','
CSV HEADER;