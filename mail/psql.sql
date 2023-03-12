CREATE INDEX messages_gin ON messages USING gin(to_tsvector('english', body));
SELECT to_tsvector('english', body) FROM messages LIMIT 1;
SELECT id, to_tsquery('english', 'michigan') @@ to_tsvector('english', body) FROM messages;
ALTER TABLE messages ADD COLUMN sender TEXT;
SELECT SUBSTRING(headers, '\nFrom: [^\n]*<([^>]*)') FROM messages;
UPDATE messages SET sender = SUBSTRING(headers, '\nFrom: [^\n]*<([^>]*)');
SELECT subject, sender FROM messages WHERE to_tsquery('english', 'password') @@ to_tsvector('english', subject) LIMIT 10;