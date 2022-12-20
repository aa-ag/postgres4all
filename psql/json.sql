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

--  General Inverted Index
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

-- preConfig words
SELECT cfgname FROM pg_ts_config;

CREATE TABLE stop_words (word TEXT UNIQUE);
INSERT INTO stop_words (word) VALUES ('is'),('this'),('and');
INSERT INTO stop_words (word) VALUES ('for'),('a'),('on');

SELECT DISTINCT id,s.keyword AS keyword
FROM docs AS d, unnest(string_to_array(LOWER(d.doc),' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT word FROM stop_words)
ORDER BY id;

-- Index Excercise 1
CREATE TABLE docs01 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE TABLE invert01 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs01(id) ON DELETE CASCADE
);

INSERT INTO docs01 (doc) VALUES
('words and sentences to convey an idea to the reader There is a'),
('skill and art in constructing the story and skill in story writing'),
('is improved by doing some writing and getting some feedback In'),
('programming our program is the story and the problem you are'),
('trying to solve is the idea'),
('Once you learn one programming language such as Python you will find it'),
('much easier to learn a second programming language such as JavaScript or'),
('C The new programming language has very different vocabulary and'),
('grammar but the problemsolving skills will be the same across all'),
('You will learn the vocabulary and sentences of Python pretty');

INSERT INTO invert01 (doc_id,keyword)
SELECT DISTINCT id,LOWER(s.keyword) AS keyword
FROM docs01 AS d, unnest(string_to_array(d.doc,' ')) s(keyword)
ORDER BY id;

-- Index Excercise 1
CREATE TABLE docs02 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE TABLE invert02 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs02(id) ON DELETE CASCADE
);

INSERT INTO docs02 (doc) VALUES
('words and sentences to convey an idea to the reader There is a'),
('skill and art in constructing the story and skill in story writing'),
('is improved by doing some writing and getting some feedback In'),
('programming our program is the story and the problem you are'),
('trying to solve is the idea'),
('Once you learn one programming language such as Python you will find it'),
('much easier to learn a second programming language such as JavaScript or'),
('C The new programming language has very different vocabulary and'),
('grammar but the problemsolving skills will be the same across all'),
('You will learn the vocabulary and sentences of Python pretty');

UPDATE docs02 SET doc = LOWER(doc);

CREATE TABLE stop_words (word TEXT unique);

INSERT INTO stop_words (word) VALUES 
('i'), ('a'), ('about'), ('an'), ('are'), ('as'), ('at'), ('be'), 
('by'), ('com'), ('for'), ('from'), ('how'), ('in'), ('is'), ('it'), ('of'), 
('on'), ('or'), ('that'), ('the'), ('this'), ('to'), ('was'), ('what'), 
('when'), ('where'), ('who'), ('will'), ('with');


INSERT INTO invert02 (doc_id,keyword)
SELECT DISTINCT id,s.keyword AS keyword
FROM docs02 AS d, unnest(string_to_array(d.doc,' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT word FROM stop_words)
ORDER BY id;