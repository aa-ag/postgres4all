select string_to_array('Hello world', ' ');
select unnest(string_to_array('Hello world', ' '));

CREATE TABLE docs (
    id SERIAL,
    doc TEXT,
    PRIMARY KEY(id)
);

INSERT INTO docs (doc)
VALUES ('This is SQL: a class focused on PostgreSQL'),
('PostgreSQL is open source'),
('PostgreSQL For Everybody is a Coursera Specialization');

CREATE TABLE docs_gin (
    keyword TEXT,
    doc_id INTEGER REFERENCES docs(id) ON DELETE CASCADE
);

INSERT INTO docs_gin (doc_id,keyword)
SELECT DISTINCT id,s.keyword AS keyword
FROM docs AS d, unnest(string_to_array(d.doc,' ')) s(keyword)
ORDER BY id;

SELECT * FROM docs_gin;

SELECT DISTINCT id,doc FROM docs AS d
JOIN docs_gin AS g ON d.id=g.doc_id
WHERE g.keyword IN ('PostgreSQL');

SELECT DISTINCT id,doc FROM docs AS d
JOIN docs_gin AS g ON d.id=g.doc_id
WHERE g.keyword = ANY(string_to_array('open source',' '));