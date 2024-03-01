CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    data JSONB
);

INSERT INTO players (data)
VALUES ('{"playerName": "Hero123", "level": 1, "achievements": []}'::jsonb);

INSERT INTO players (data)
VALUES ('{"playerName": "Adventurer", "level": 5, "achievements": [{"name": "First Quest"}]}'::jsonb);


SELECT * FROM players
WHERE jsonb_path_query_first(data, '$.achievements[*].name') ? 'First Quest';
-- ^^^ this is JSONPath
