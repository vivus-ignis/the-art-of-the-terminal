#!/bin/bash -x

LOCKDIR=$HOME/.task.lock
BATCH_SIZE=2

mkdir "$LOCKDIR" || exit 127

while read -r line; do
	logger -t batch_processor "[$$] Accepted task '$line'"
	printf "%s\0" "$line"
done <"$HOME/.task_queue" | xargs -0 -t -P $BATCH_SIZE -n 1 bash -c

rm -rf "$LOCKDIR"
