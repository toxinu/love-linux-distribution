# Simple LÖVE Linux Distribution

This project allows you to distribute your LÖVE (0.9.1, more ?) game for Linux. It is an elegant alternative to making Linux users install LÖVE just for your game. Linux users simply download your game and click run.sh to run your game; they cannot install your game using this method. So this is mostly useful for Ludum Dare games, and potentially Steam distribution.

## Instructions

1. Download this repository (as .zip or git clone)
2. Edit `build.sh` script to add your `GAME`, `DESC` and `OUTPUT` variables
3. Run `./build.sh`
4. Enjoy

## Supported distros

Any distro with glibc 2.15 or later should work, but these are the ones I will support:

Distro        | State
--------------|---------
Ubuntu 12.04  | Ok
Ubuntu 14.04  | Verified
Ubuntu 14.10  | Verified
Fedora 20     | Ok
Linux Mint 13 | Ok
openSUSE 13.1 | Ok

Currently I will not try to support older systems, or systems with older versions of glibc, simply because the oldest Linux distro that LÖVE officially supports is Ubuntu 12.04. Others are welcome to fork and submit pull requests if they feel they can do this, however.

## Licensing

Simple LÖVE Linux Distribution and LÖVE are licensed under the zlib/libpng license. This means that:

* They cost nothing.
* You can use them freely for commercial purposes with no limitations.

Read more [here](http://opensource.org/licenses/Zlib).
