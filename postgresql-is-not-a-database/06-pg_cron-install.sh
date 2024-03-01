#!/bin/bash
#
trunk install pg_cron
echo "shared_preload_libraries = 'pg_cron'" >>~/.pgenv/pgsql-$(pgenv current)/data/postgresql.conf
pgenv restart
