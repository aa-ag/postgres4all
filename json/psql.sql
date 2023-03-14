CREATE TABLE IF NOT EXISTS jtrack (id SERIAL, body JSONB);
\copy jtrack (body) FROM 'library.jstxt' WITH CSV QUOTE E'\x01' DELIMITER E'\x02';
SELECT (body->>'count')::int FROM jtrack WHERE body @> '{"name":"Summer Nights"}';
SELECT COUNT(*) FROM jtrack WHERE body ? 'favorite';