#!/bin/bash

command=$(cat)

$command
echo "Command '$command' executed with return code: $?"
