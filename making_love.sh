#!/bin/bash

NAME="love-builder"
LOVE_DIR="/usr/src/love"
LOVE_VERSION="0.9.0"
BOOTSTRAP_DIR="$LOVE_DIR/builds"
LOVE_URL="https://bitbucket.org/rude/love/downloads/love-$LOVE_VERSION-linux-src.tar.gz"

sudo lxc-create -t download -n $NAME -- -d ubuntu -r trusty -a amd64
sudo lxc-start -d -n $NAME

ARCH="i386"
BITS="32"
if [ "$(sudo lxc-attach -n $NAME -- uname -m)" == "x86_64" ]
then
    ARCH="x64"
    BITS="64"
fi

sudo lxc-attach -n $NAME -- apt-get update
sudo lxc-attach -n $NAME -- apt-get -y upgrade
sudo lxc-attach -n $NAME -- apt-get install -y wget
sudo lxc-attach -n $NAME -- apt-get install -y libsdl2-dev libopenal-dev libdevil-dev
sudo lxc-attach -n $NAME -- apt-get install -y libmodplug-dev libvorbis-dev libphysfs-dev
sudo lxc-attach -n $NAME -- apt-get install -y libluajit-5.1-dev libmpg123-dev
sudo lxc-attach -n $NAME -- apt-get install -y build-essential autoconf libtool libfreetype6-dev
sudo lxc-attach -n $NAME -- bash -c "if [ ! -d $LOVE_DIR ]; then mkdir -p $LOVE_DIR ;fi"
sudo lxc-attach -n $NAME -- bash -c "cd $LOVE_DIR && if [ ! -f love-$LOVE_VERSION-linux-src.tar.gz ]; then wget $LOVE_URL ;fi"
sudo lxc-attach -n $NAME -- bash -c "cd $LOVE_DIR && if [ ! -d $LOVE_DIR/love-$LOVE_VERSION ]; then tar xvf love-$LOVE_VERSION-linux-src.tar.gz ;fi"
sudo lxc-attach -n $NAME -- bash -c "if [ ! -d $LOVE_DIR/builds ]; then mkdir $LOVE_DIR/builds ;fi"

LOVE_DIR="$LOVE_DIR/love-$LOVE_VERSION"
BOOTSTRAP_DIR="$BOOTSTRAP_DIR/love-$LOVE_VERSION-$ARCH"

sudo lxc-attach -n $NAME -- bash -c "cd $LOVE_DIR && ./configure --prefix=$BOOTSTRAP_DIR"
sudo lxc-attach -n $NAME -- bash -c "cd $LOVE_DIR && make"
sudo lxc-attach -n $NAME -- bash -c "cd $LOVE_DIR && make install"
sudo lxc-attach -n $NAME -- bash -c "if [ -d $BOOTSTRAP_DIR/share ]; then rm -r $BOOTSTRAP_DIR/share ;fi"

echo "Building bootstrap in $BOOTSTRAP_DIR/{bin,lib}..."
sudo lxc-attach -n $NAME -- bash -c "if [ ! -f $BOOTSTRAP_DIR/bin/love$BITS ]; then mv $BOOTSTRAP_DIR/bin/love $BOOTSTRAP_DIR/bin/love$BITS ;fi"
sudo lxc-attach -n $NAME -- bash -c "if [ ! -d $BOOTSTRAP_DIR/lib/$ARCH ]; then mkdir $BOOTSTRAP_DIR/lib/$ARCH ;fi"

LIBS="libIL.so libSDL2-2.0.so libXss.so libjpeg.so liblcms.so libluajit-5.1.so libmng.so libmodplug.so libmpg123.so libopenal.so libphysfs.so libpng12.so libtiff.so libvorbisfile.so"
for lib in $(sudo lxc-attach -n $NAME -- bash -c "ldd $BOOTSTRAP_DIR/bin/love$BITS"); do
  for _lib in $LIBS; do
    if [[ ${lib:0:1} == "/" ]]; then
      if [[ $(basename $lib) == *$_lib* ]]; then
        echo "Copying" $(basename $lib) "($lib)..."
		sudo lxc-attach -n $NAME -- bash -c "cp $lib $BOOTSTRAP_DIR/lib/$ARCH"
      fi
    fi
  done
done

sudo lxc-attach -n $NAME -- bash -c "mv $BOOTSTRAP_DIR/lib/liblove.* $BOOTSTRAP_DIR/lib/$ARCH"

sudo lxc-attach -n $NAME -- bash -c "cd $BOOTSTRAP_DIR/.. && tar cvpzf $BOOTSTRAP_DIR/../love-$LOVE_VERSION-$ARCH-binaries.tar.gz $(basename $BOOTSTRAP_DIR)"
sudo lxc-attach -n $NAME -- bash -c "cat $BOOTSTRAP_DIR/../love-$LOVE_VERSION-$ARCH-binaries.tar.gz" > src/love-$LOVE_VERSION-$ARCH.tar.gz

cd src
tar xvf love-$LOVE_VERSION-$ARCH.tar.gz
mv love-$LOVE_VERSION-$ARCH love-$LOVE_VERSION
rm love-$LOVE_VERSION-$ARCH.tar.gz
cd -

echo "Done."