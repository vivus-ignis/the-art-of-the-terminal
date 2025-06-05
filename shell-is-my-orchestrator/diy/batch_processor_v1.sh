#!/bin/bash -x

while read -r line; do
	logger -t batch_processor "[$$] Running task '$line'"
	bash -c "$line"
	logger -t batch_processor "[$$] Finished task '$line' with exit code $?"
done <"$HOME/.task_queue"
