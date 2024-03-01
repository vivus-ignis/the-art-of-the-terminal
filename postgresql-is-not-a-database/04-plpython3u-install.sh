#!/bin/bash
#
# a little bit of trickery is needed because trunk only supports ubuntu and I'm on debian
# I rely on asdf here (https://asdf-vm.com/guide/getting-started.html)
asdf install python 3.10.13
asdf global python 3.10.13
export LD_LIBRARY_PATH=~/.asdf/installs/python/3.10.13/lib
echo 'export LD_LIBRARY_PATH=~/.asdf/installs/python/3.10.13/lib' >>~/.bashrc

# installing the OS part of the extension
trunk install plpython3u

# restarting postgresql so that it picks up the LD_LIBRARY_PATH envvar
pgenv stop
pgenv start

# I will need pandas library for my stored procedure
pip install pandas
