## Filespooler

### Installing and initializing a queue

```bash
sudo apt-get install filespooler
fspl queue-init -q queue
ls -l queue
```

### Packets

```bash
fspl prepare -s sender001 -- -O /dev/null https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.14.6.tar.xz

fspl prepare -s sender002 -- -O /dev/null https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.14.6.tar.xz | fspl queue-write -q queue
fspl queue-ls -q queue
```

### Remote queue

```bash
scp -r queue <remote_server>:.
ssh <remote_server> fspl queue-process -q queue --allow-job-params wget
ssh <remote_server> fspl queue-process -q queue --allow-job-params wget

fspl prepare -s sender002 -- -O /dev/null https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.14.6.tar.xz | ssh <remote_server> fspl queue-write -q queue
ssh <remote_server> fspl queue-process -q queue --allow-job-params wget
```

### Data & code in filespooler packets

```bash
for f in work/input/*.png; do \
  filename=$(basename $f .png); \
  cat ./$f | fspl prepare -s sender002 -i - -- png:- -resize 120x120 /tmp/work/${filename}.jpg | ssh <remote_server> fspl queue-write -q queue; \
done
ssh <remote_server> mkdir /tmp/work
ssh <remote_server> sudo apt install -y imagemagick
ssh <remote_server> fspl queue-process -q queue --allow-job-params convert
ssh <remote_server> ls -l work/
```

### "Universal" script

`process.sh` is an example of a universal script to run any command passed to filespooler.
