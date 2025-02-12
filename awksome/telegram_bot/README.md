# Prerequisites

## API access

Get your Telegram and OpenAI tokens handy.

## Gawk extensions

```bash
sudo apt install autoconf libtool-bin autopoint rapidjson-dev libhiredis-dev
git clone git://git.code.sf.net/p/gawkextlib/code gawkextlib
cd gawkextlib
cd lib
autoupdate
autoreconf -i
./configure --prefix=$HOME/awk_ext
make
make install

cd ../json
autoreconf -i
./configure --prefix=$HOME/awk_ext
make
make install

cd ../redis
autoreconf -i
./configure --prefix=$HOME/awk_ext
make
make install
```

## Configuration file

Copy `.env.example` to `.env` and put your Telegram and OpenAI tokens there.

## Just

To run projects-related commands, I use [just](https://just.systems).

Check out my video on just & other terminal project management tools: https://youtu.be/OYl-wrsMGZo

## Docker

This project uses docker to run redis server.

# Running the bot

Simply type

```bash
just run
```
