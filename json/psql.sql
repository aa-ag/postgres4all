CREATE TABLE IF NOT EXISTS jtrack (id SERIAL, body JSONB);
\copy jstrack (body) FROM 'library.txt' WITH CSV QUOTE E'\x01' DELIMITER '\x02';