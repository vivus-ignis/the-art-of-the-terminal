#!/bin/bash

git clone https://github.com/theory/pgenv.git ~/.pgenv
pgenv build 15.6
pgenv use 15.6
