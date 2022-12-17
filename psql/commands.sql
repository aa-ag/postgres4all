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

DROP TABLE unesco;
CREATE TABLE unesco
 (name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER);
INSERT INTO unesco(name, description, justification, year,
    longitude, latitude, area_hectares,
    category, category_id, state, state_id,
    region, region_id, iso, iso_id
)
SELECT *
FROM unesco_raw
ON CONFLICT DO NOTHING;

CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
INSERT INTO category(name)
SELECT category
FROM unesco_raw
ON CONFLICT DO NOTHING;
UPDATE unesco_raw SET category_id = (SELECT category.id FROM category WHERE category.name = unesco_raw.category);

CREATE TABLE region (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
INSERT INTO region(name)
SELECT region
FROM unesco_raw
ON CONFLICT DO NOTHING;
UPDATE unesco_raw SET region_id = (SELECT region.id FROM region WHERE region.name = unesco_raw.region);

CREATE TABLE state (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
INSERT INTO state(name)
SELECT state
FROM unesco_raw
ON CONFLICT DO NOTHING;
UPDATE unesco_raw SET state_id = (SELECT state.id FROM state WHERE state.name = unesco_raw.state);

CREATE TABLE iso (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
INSERT INTO iso(name)
SELECT iso
FROM unesco_raw
ON CONFLICT DO NOTHING;
UPDATE unesco_raw SET iso_id = (SELECT iso.id FROM iso WHERE iso.name = unesco_raw.iso);

\copy unesco_raw(
  name, description, justification, year,longitude, latitude,
  area_hectares,category, state,region, iso)
FROM 'psql/whc-sites-2018-small.csv'
WITH (FORMAT CSV, DELIMITER ',', HEADER);

-- tracktoartis exercise
DROP TABLE album CASCADE;
CREATE TABLE album (
    id SERIAL,
    title VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE track CASCADE;
CREATE TABLE track (
    id SERIAL,
    title TEXT, 
    artist TEXT, 
    album TEXT, 
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    count INTEGER, 
    rating INTEGER, 
    len INTEGER,
    PRIMARY KEY(id)
);

DROP TABLE artist CASCADE;
CREATE TABLE artist (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE tracktoartist CASCADE;
CREATE TABLE tracktoartist (
    id SERIAL,
    track VARCHAR(128),
    track_id INTEGER REFERENCES track(id) ON DELETE CASCADE,
    artist VARCHAR(128),
    artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE,
    PRIMARY KEY(id)
);

\copy track(title,artist,album,count,rating,len) FROM '/Users/aaronaguerrevere/Documents/projects/postgres4all/psql/library.csv' WITH DELIMITER ',' CSV;

INSERT INTO album (title) SELECT DISTINCT album FROM track;
UPDATE track SET album_id = (SELECT album.id FROM album WHERE album.title = track.album);

INSERT INTO tracktoartist (track, artist) SELECT DISTINCT title,artist FROM track;
INSERT INTO artist (name) SELECT DISTINCT artist FROM track;

UPDATE tracktoartist SET track_id = (SELECT track.id FROM track WHERE track.title=tracktoartist.track);
UPDATE tracktoartist SET artist_id = (SELECT artist.id FROM artist WHERE artist.name=tracktoartist.artist);

-- We are now done with these text fields
ALTER TABLE track DROP COLUMN album;
ALTER TABLE track  DROP COLUMN artist;
ALTER TABLE tracktoartist DROP COLUMN track;
ALTER TABLE tracktoartist  DROP COLUMN artist;

SELECT 'https://www.example.com/' || trunc(random()*100000) || repeat('/lorem-ipsum/',2) || generate_series(1,5);

CREATE TABLE texttest (
  content TEXT
);
CREATE INDEX texttest_b ON  texttest (content);

SELECT pg_relation_size('texttest'), pg_indexes_size('texttest');

INSERT INTO texttest (content)
SELECT (
  CASE WHEN (random() < 0.5)
  THEN 'https://www.example.com/a/'
  ELSE 'https://www.example.com/b/'
  END) || generate_series(1,100000);

\timing
explain analyze SELECT COUNT(*) FROM texttest;