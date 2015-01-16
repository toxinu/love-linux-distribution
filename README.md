# Simple LÖVE Linux Distribution

This project allows you to distribute your LÖVE 0.9.1 game for Linux. It is an elegant alternative to making Linux users install LÖVE just for your game. Linux users simply download your game and click run.sh to run your game; they cannot install your game using this method. So this is mostly useful for Ludum Dare games, and potentially Steam distribution.

## Instructions

1. Download [love-linux-distribution.tar.gz](https://bitbucket.org/funkeh/love-linux-distribution/downloads/love-linux-distribution.tar.gz) from the [Downloads](https://bitbucket.org/funkeh/love-linux-distribution/downloads/love-linux-distribution.tar.gz) page.
    * It is recommended to download this file instead of the whole repository so that executable permissions in Linux can be preserved.
2. Package your game files into a .love file named *game.love* (make sure your filename is entirely lowercase) and drag it into the *bin/* folder in *love-linux-distribution.tar.gz*.
    * You can use an archive manager like 7zip to accomplish this.
3. Rename *love-linux-distribution.tar.gz* to *your-game-name-linux.tar.gz*.
4. That's it! Your game is now packaged for Linux.

## Supported distros

Any distro with glibc 2.15 or later should work, but these are the ones I will support:

* Ubuntu 12.04 and later
* Fedora 20 and later
* Linux Mint 13 and later
* openSUSE 13.1 and later

Currently I will not try to support older systems, or systems with older versions of glibc, simply because the oldest Linux distro that LÖVE officially supports is Ubuntu 12.04. Others are welcome to fork and submit pull requests if they feel they can do this, however.

## Licensing

Simple LÖVE Linux Distribution and LÖVE are licensed under the zlib/libpng license. This means that:

* They cost nothing.
* You can use them freely for commercial purposes with no limitations.

Read more [here](http://opensource.org/licenses/Zlib).