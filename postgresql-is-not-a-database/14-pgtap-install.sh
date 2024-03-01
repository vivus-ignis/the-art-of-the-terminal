#!/bin/bash
#
trunk install pgtap

# In psql:
# --------
# CREATE EXTENSION pgtap;
#
sudo apt install libtap-parser-sourcehandler-pgtap-perl
pg_prove -U postgres ./pgtap/*.sql
