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

