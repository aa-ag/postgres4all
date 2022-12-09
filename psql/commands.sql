-- brew services start postgresql@14
-- psql postgres
CREATE USER pg4e WITH PASSWORD 'thisisajoke';
CREATE DATABASE people WITH OWNER 'pg4e';
\dt
CREATE TABLE users(
    name VARCHAR(128),
    email VARCHAR(128)
);