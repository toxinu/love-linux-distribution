#!/bin/bash
# LÖVE Game Startup Script for Linux
# Josef Frank, 2014 :: chikun.net

# Figure out working directory
SCRIPT_PATH=${0%/*}

# Figure out architecture
ARCH="i386"
BITS="32"
if [ "$(uname -m)" == "x86_64" ]
then
    ARCH="x64"
    BITS="64"
fi

# Save system library path for restoration
SYSTEM_LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# Change library path to our own
export LD_LIBRARY_PATH="$SCRIPT_PATH/lib/$ARCH"

# Actually run the program
exec $SCRIPT_PATH/bin/love$BITS $SCRIPT_PATH/bin/game.love

# Restore library path
export LD_LIBRARY_PATH="$SYSTEM_LD_LIBRARY_PATH"
