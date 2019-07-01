# Grunt

The [Gruntfile.js](Gruntfile.js) uses a hacked version of `grunt-contrib-lualint`
where the call to `lualint`is replaced by a call to `luacheck`. This change is rather
trivial, still a new grunt should be created and properly packaged. Use of `grunt-env`
comes from the `lualint` and is probably not necessary anymore.

A quick fix to make grunt work until all is properly packaged is to comment out all
use of `grunt-contrib-lualint` and `grunt-env`.

If running [MediaWiki-Vagrant](https://www.mediawiki.org/wiki/MediaWiki-Vagrant)
in the usual setup, with Ubuntu 12.04 (Precise), there are no deb packages available
in any repository for `luacjheck`. It does although seem like the package from Ubuntu
17.04 (Zesty) work in Precise, so download the deb-package from
[lua-check 0.17.1-1 (s390x binary) in Ubuntu Zesty](https://launchpad.net/ubuntu/zesty/s390x/lua-check/0.17.1-1)
to your vagrant-box and install with `sudo dpkg -i /path/to/file.deb`.

Yes, it is a hefty backport!

It is probably necessary to set up `lua-filesystem`, but this is available as a
deb-package, so install with `sudo apt-get install lua-filesystem`.

Lua 5.1 is available as part of the Scribunto role.
