#!/bin/sh
apt-get install build-essential libncurses-dev libz-dev libreadline-dev libssl-dev cmake git
git clone https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
cd SoftEtherVPN*
./configure
make
make install