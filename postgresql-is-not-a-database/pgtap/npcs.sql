BEGIN;

SELECT PLAN(5);

SELECT is_descendent_of('npcs', 'characters');

SELECT has_column('npcs', 'character_id');
SELECT has_column('npcs', 'character');
SELECT has_column('npcs', 'quest');

SELECT ok(exists(
  SELECT 1 FROM npcs 
  WHERE quest = 'Defeat the Balrog' AND 
  (character).name = 'Gandalf'), 
'Gandalf quest "Defeat the Balrog" exists');

SELECT * FROM finish();

ROLLBACK;
