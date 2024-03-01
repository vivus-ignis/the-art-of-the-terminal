CREATE EXTENSION pgmq;

SELECT pgmq.create('game_events');
SELECT * from pgmq.send('game_events', '{"foo": "bar1"}');
SELECT * from pgmq.send('game_events', '{"foo": "bar2"}');
SELECT * FROM pgmq.read('game_events', 30, 2); -- take 2, make them invisible for 30 seconds
SELECT pgmq.read('game_events', 30, 1); -- messages are invisible for 30 seconds
SELECT pgmq.delete('game_events', 1);
