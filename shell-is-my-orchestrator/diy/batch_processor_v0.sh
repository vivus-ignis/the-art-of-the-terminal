#!/bin/bash -x

while read -r line; do
	echo "[$$] Running task '$line'"
	bash -c "$line"
	echo "[$$] Finished task '$line' with exit code $?"
done <"$HOME/.task_queue"
