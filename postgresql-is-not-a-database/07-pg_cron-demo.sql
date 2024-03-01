CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS pg_cron;

CREATE UNLOGGED TABLE kv_cache (
    id SERIAL PRIMARY KEY,
    data HSTORE,
    inserted_at TIMESTAMP DEFAULT NOW()
);

-- UNLOGGED means no data safety guarantees but faster writes

INSERT INTO kv_cache (data) VALUES
('key1 => "value1", key2 => "value2"'),
('key3 => "value3", key4 => "value4"');

SELECT * FROM kv_cache;

-- query by key
SELECT data -> 'key1' AS value
  FROM kv_cache
  WHERE data ? 'key1';

-- cleanup cron job
-- pay attention: no space between $$ and DELETE !
SELECT cron.schedule('*/5 * * * *',
$$DELETE FROM kv_cache
  WHERE inserted_at < NOW() - INTERVAL '5 minutes'
$$);

SELECT * FROM cron.job;

-- check the status in 5 mins
SELECT * from cron.job_run_details;

SELECT * FROM kv_cache;
