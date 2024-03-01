-- psql 1
-- game_events is a channel name
LISTEN game_events;

-- psql 2
NOTIFY game_events, 'foo';

-- psql 1
SELECT 1;
