#!/bin/bash
set -e
set -u
##########################################################
GAME=example
DESC="My game ! (v0.0.1)"
OUTPUT=example.run
LOVE_VERSION="9.1"
MAKESELF_OPTS="--nomd5 --nocrc --nocomp"
##########################################################

TMP=`mktemp -d`
cp -r src/love-$LOVE_VERSION/* $TMP
cp src/run.sh $TMP
mkdir -p $TMP/bin/game.love
cp -r $GAME/* $TMP/bin/game.love

makeself/makeself.sh $MAKESELF_OPTS $TMP $OUTPUT "$DESC" ./run.sh

rm -rf $TMP