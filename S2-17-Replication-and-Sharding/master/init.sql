CREATE TABLE test_data (
    id SERIAL PRIMARY KEY,
    value TEXT
);
CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'replicator_password';