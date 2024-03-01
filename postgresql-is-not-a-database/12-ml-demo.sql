-- psql postgres://pg:ml@sql.cloud.postgresml.org:38042/pgml
SELECT pgml.transform_stream(
  task   => '{
    "task": "text-generation",
    "model": "TheBloke/zephyr-7B-beta-GPTQ",
    "model_type": "mistral",
    "revision": "main",
    "device_map": "auto"
  }'::JSONB,
  input  => 'AI is going to',
  args   => '{
    "max_new_tokens": 100
  }'::JSONB
);
