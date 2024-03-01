#!/bin/bash
#
cd /tmp

wget https://github.com/PostgREST/postgrest/releases/download/v12.0.2/postgrest-v12.0.2-linux-static-x64.tar.xz

tar xf postgrest-v12.0.2-linux-static-x64.tar.xz

mv postgrest ~/.local/bin

postgrest -h

# In psql:
# --------
# create role web_anon nologin;
#
# grant usage on schema public to web_anon;
#   -- just for demo purposes; create a separate named schema instead
# grant select on public.npcs to web_anon;
#
# create role authenticator noinherit login password 'TheArtOfTheTerminal';
# grant web_anon to authenticator;

cat <<EOF >game_api.conf
db-uri = "postgres://authenticator:TheArtOfTheTerminal@localhost:5432/postgres"
db-schemas = "public"
db-anon-role = "web_anon"
EOF

postgrest game_api.conf

# curl http://localhost:3000/npcs
