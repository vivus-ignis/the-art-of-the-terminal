CREATE EXTENSION pg_graphql;

CREATE TABLE spells(
  id int primary key,
  name text
);

INSERT INTO spells(id, name)
 VALUES (1, 'fireball');

SELECT graphql.resolve($$
query {
  spellsCollection {
    edges {
      node {
        id
      }
    }
  }
}
$$);
