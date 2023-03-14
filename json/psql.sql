CREATE TABLE IF NOT EXISTS jtrack (id SERIAL, body JSONB);
\copy jstrack (body) FROM 'library.txt' WITH CSV QUOTE E'\x01' DELIMITER '\x02';
SELECT (body->>'count')::int FROM jstrack WHERE body @> '{"name":"Summer Nights"}';
SELECT COUNT(*) FROM jstrack WHERE body ? 'favorite';