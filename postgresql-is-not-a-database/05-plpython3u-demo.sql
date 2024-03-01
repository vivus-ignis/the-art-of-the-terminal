CREATE EXTENSION plpython3u;

CREATE TABLE character_stats (
    id SERIAL PRIMARY KEY,
    character_name VARCHAR(255),
    score INTEGER
);

INSERT INTO character_stats (character_name, score) VALUES
    ('Aragorn', 85),
    ('Gandalf', 95),
    ('Legolas', 90),
    ('Gimli', 88),
    ('Frodo', 80),
    ('Samwise', 82),
    ('Merry', 78),
    ('Pippin', 76),
    ('Boromir', 84),
    ('Faramir', 86),
    ('Eowyn', 92),
    ('Galadriel', 94),
    ('Elrond', 89),
    ('Aragorn', 87),
    ('Gandalf', 93);

CREATE OR REPLACE FUNCTION analyze_character_scores()
RETURNS TABLE(
    count DOUBLE PRECISION,
    mean DOUBLE PRECISION,
    std DOUBLE PRECISION,
    min DOUBLE PRECISION,
    "25%" DOUBLE PRECISION,
    "50%" DOUBLE PRECISION,
    "75%" DOUBLE PRECISION,
    max DOUBLE PRECISION
) AS $$
    import pandas as pd
    import plpy

    # Fetch scores from the character_stats table
    result = plpy.execute("SELECT score FROM character_stats")
    scores = [row['score'] for row in result]

    # Create a DataFrame
    df = pd.DataFrame(scores, columns=['Score'])

    # Use describe() to generate descriptive statistics
    description = df['Score'].describe()

    # Convert the Series object to a list of tuples to match the RETURNS TABLE structure
    return [(description['count'],
             description['mean'],
             description['std'],
             description['min'],
             description['25%'],
             description['50%'],
             description['75%'],
             description['max'])]
$$ LANGUAGE plpython3u;

SELECT * FROM character_stats;
