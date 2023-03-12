CREATE INDEX messages_gin ON messages USING gin(to_tsvector('english', body));
SELECT to_tsvector('english', body) FROM messages LIMIT 1;