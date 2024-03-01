BEGIN;

SELECT plan(1);
  
SELECT has_type('rpg_character');
  
SELECT * FROM finish();

ROLLBACK;
