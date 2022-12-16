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

\copy track_raw(title, artist, album, album_id, count, rating)
FROM '/Users/aaronaguerrevere/Documents/projects/postgres4all/psql/library.csv'
WITH (FORMAT CSV, DELIMITER ',', FORCE_NULL (count));

INSERT INTO track(title, album_id, count, rating)
SELECT title, album_id, count, rating
FROM track_raw
ON CONFLICT DO NOTHING;

UPDATE track_raw SET album_id = (SELECT album.id FROM album WHERE album.title = track_raw.album);

INSERT INTO album(title)
SELECT album
FROM track_raw
ON CONFLICT DO NOTHING;

-- UNESCO EXERCISE
DROP TABLE unesco_raw;
CREATE TABLE unesco_raw
 (name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER);

CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
CREATE TABLE region (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
CREATE TABLE state (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
CREATE TABLE iso (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

\copy unesco_raw(
  name, description, justification, year,longitude, latitude,
  area_hectares,category, state,region, iso)
FROM 'psql/whc-sites-2018-small.csv'
WITH (FORMAT CSV, DELIMITER ',', HEADER);