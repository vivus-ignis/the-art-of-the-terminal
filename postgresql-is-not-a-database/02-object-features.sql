iCREATE TYPE
  rpg_character AS (
    name VARCHAR,
    class VARCHAR,
    inventory TEXT[], -- array of items of TEXT type
    skills TEXT[]
);

CREATE SEQUENCE
  rpg_character_id_seq;

CREATE TABLE
  characters (
    character_id INTEGER,
    character rpg_character
);

INSERT INTO
  characters
  (character_id, character) VALUES
    (nextval('rpg_character_id_seq'), -- get next number from a sequence
     (ROW(  -- ROW constructs a composite value for a record
       'Aragorn',
       'Ranger',
       ARRAY['Sword', 'Cloak'],
       ARRAY['Tracking', 'Swordsmanship']
      )::rpg_character));  -- type cast composite value to rpg_character

SELECT
   (character).name,
   (character).inventory
 FROM characters
 WHERE (character).name = 'Aragorn';

CREATE TABLE npcs (
  quest VARCHAR
) INHERITS (characters);

INSERT INTO npcs (character_id, character, quest)
VALUES (
  nextval('rpg_character_id_seq'),
  ROW('Gandalf',
      'Wizard',
      ARRAY['Wizard Staff'],
      ARRAY['Fireworks', 'Combat Magic'])::rpg_character,
  'Defeat the Balrog'
);

INSERT INTO npcs (character_id, character, quest)
VALUES (
  nextval('rpg_character_id_seq'),
  ROW('Elrond',
      'Elf Lord',
      ARRAY['Sword', 'Cloak'],
      ARRAY['Healing', 'Diplomacy'])::rpg_character,
  'Protect Rivendell'
);

SELECT * FROM npcs;

SELECT * FROM characters;
