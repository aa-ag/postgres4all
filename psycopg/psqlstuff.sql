CREATE INDEX pg19337_gin ON pg19337 USING gin(to_tsvector('english', body));

SELECT id, body FROM pg19337 WHERE to_tsquery('english', 'love') @@ to_tsvector('english', body) LIMIT 10;