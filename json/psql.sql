CREATE TABLE IF NOT EXISTS jtrack (id SERIAL, body JSONB);
\copy jtrack (body) FROM 'library.jstxt' WITH CSV QUOTE E'\x01' DELIMITER E'\x02';
SELECT pg_typeof(body) FROM jtrack LIMIT 1;
SELECT body->>'name' FROM jtrack LIMIT 3;
SELECT MAX((body->>'count')::int) FROM jtrack;
SELECT (body->>'count')::int FROM jtrack WHERE body @> '{"name":"Summer Nights"}';
SELECT COUNT(*) FROM jtrack WHERE body ? 'favorite';

UPDATE jtrack SET body = body || '{"favorite": "yes"}' WHERE (body->'count')::int > 200;
SELECT body FROM jtrack WHERE body ? 'favorite';
INSERT INTO jtrack (body) SELECT ('{"type": "Neon", "series": "24 Hours of Lemons", "number": ' || generate_series(1000,5000) || '}')::json;

CREATE INDEX jtrack_btree ON jtrack USING BTREE ((body->>'name'));
CREATE INDEX jtrack_gin ON jtrack USING gin (body);
CREATE INDEX jtrack_gin_path_ops ON jtrack USING gin (body json_path_ops);

EXPLAIN SELECT COUNT(*) FROM jtrack WHERE body->>'artist' = 'Queen';
EXPLAIN SELECT COUNT(*) FROM jtrack WHERE body @> '{"name": "Summer Nights"}';