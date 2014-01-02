# Mee #

#### *An utility library written in Vala* ####

Discussion and support on IRC channel [#canaldev](http://webchat.freenode.net/?channels=#canaldev) (freenode).

[![Build Status](https://travis-ci.org/inizan-yannick/mee.png)](https://travis-ci.org/inizan-yannick/mee)

## Manual installation ##

### Requirements
 * valac (>= 0.17)
 * pkg-config
 * glib-2.0
 * gio-2.0
 * gee-0.8 (>= 0.10.5)
 * at least libvala-0.24 (recommended) or libvala-0.22

On Debian based systems install following packages:

    sudo apt-get install build-essential valac-0.24 libvala-0.24-dev pkg-config libgee-0.8-dev

On Ubuntu versions under Trusty, you have to include [My PPA](https://launchpad.net/~inizan-yannick/+archive/development) first.

### Building ###
 1. `./autogen.sh`
 1. `make`

### Installation ###
 1. `sudo make install`
 1. `sudo ldconfig` (to update linker cache for the library)

## Packaging files for distributions ##
this repository contains Debian packaging.


## Contribution ##
See the wiki page for some information [Wiki](https://github.com/inizan-yannick/mee/wiki) or drop in on [#canaldev](http://webchat.freenode.net/?channels=#canaldev) (irc.freenode.net).

## License ##
Mee is distributed under the terms of the GNU General Public License version 3 or later and published by:
 * Yannick Inizan
