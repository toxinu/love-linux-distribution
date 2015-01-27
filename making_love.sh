#!/bin/bash

NAME="love-builder"
LOVE_DIR="/tmp/love"

# sudo lxc-create -t download -n $NAME -- -d ubuntu -r trusty -a amd64
# sudo lxc-start -d -n $NAME
# sudo lxc-attach -n $NAME -- apt-get update
# sudo lxc-attach -n $NAME -- apt-get -y upgrade
# sudo lxc-attach -n $NAME -- apt-get -y install mercurial
# sudo lxc-attach -n $NAME -- apt-get install -y libsdl2-dev libopenal-dev libdevil-dev
# sudo lxc-attach -n $NAME -- apt-get install -y libmodplug-dev libvorbis-dev libphysfs-dev
# sudo lxc-attach -n $NAME -- apt-get install -y libluajit-5.1-dev libmpg123-dev
# sudo lxc-attach -n $NAME -- apt-get install -y build-essential autoconf libtool libfreetype6-dev
sudo lxc-attach -n $NAME -- bash -c "hg clone https://socketubs@bitbucket.org/rude/love $LOVE_DIR"
sudo lxc-attach -n $NAME -- bash -c "mkdir $LOVE_DIR/builds"
sudo lxc-attach -n $NAME -- bash -c "cd $LOVE_DIR && platform/unix/automagic -d"
sudo lxc-attach -n $NAME -- bash -c "cd $LOVE_DIR && ./configure --prefix=$LOVE_DIR/builds"
sudo lxc-attach -n $NAME -- bash -c "cd $LOVE_DIR && make"

ARCH="i386"
BITS="32"
if [ "$(sudo lxc-attach -n $NAME -- uname -m)" == "x86_64" ]
then
    ARCH="x64"
    BITS="64"
fi

echo "Building bootstrap in $LOVE_DIR/builds/bootstrap/{bin,lib}..."
sudo lxc-attach -n $NAME -- bash -c "mkdir $LOVE_DIR/builds/bootstrap/{bin,lib} -p"
sudo lxc-attach -n $NAME -- bash -c "cp $LOVE_DIR/builds/lib/liblove.so.0 $LOVE_DIR/builds/bootstrap/lib"
sudo lxc-attach -n $NAME -- bash -c "cp $LOVE_DIR/builds/bin/love $LOVE_DIR/builds/bootstrap/bin/love$BITS"


LIBS="libIL.so libSDL2-2.0.so libXss.so libjpeg.so liblcms.so libluajit-5.1.so libmng.so libmodplug.so libmpg123.so libopenal.so libphysfs.so libpng12.so libtiff.so libvorbisfile.so"

for lib in $(sudo lxc-attach -n $NAME -- bash -c "ldd $LOVE_DIR/builds/bin/love | awk '{ print $3 }' | sed  '/^$/d'"); do
	for _lib in $LIBS; do
		if [[ $lib == *$_lib* ]]; then
			echo "Copying $lib ..."
			sudo lxc-attach -n $NAME -- bash -c "cp $lib $LOVE_DIR/builds/bootstrap/lib"
		fi
	done
done
echo "Done."