# Task spooler

## Installation

```bash
sudo apt-get install task-spooler
```

## Basics

```bash
# submitting a task
tsp wget -O /dev/null https://mirror.team-cymru.com/gnu/bash/bash-5.2.tar.gz

# listing tasks
tsp

# info on a task
tsp -i <task_id>

# output of a task
tsp -c <task_id>
```

## Batch size

```bash
tsp -S 2 # set to 2
tsp -S   # show current batch size
```

## Managing tasks

```bash
# removing tasks from the queue
tsp -r <task_id> -r <task_id>

# interrupting a task
tsp -k <task_id>

# making a task urgent (moves to the top of the queue)
tsp -u <task_id>
```

## Tasks dependencies

```bash
# waiting for a task in a shell session
TASK_ID=`tsp -L download wget -O /dev/null https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.14.6.tar.xz`
tsp -w $TASK_ID && touch /tmp/download_done

# a task waits for another task to complete
TASK_ID=`tsp -L download wget -O /dev/null https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.14.6.tar.xz`
tsp sh -c "tsp -w $TASK_ID && touch /tmp/download_done"
```
