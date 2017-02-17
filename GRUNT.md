# Grunt

The [Gruntfile.js](Gruntfile.js) uses a hacked version of `grunt-contrib-lualint` where the call to `lualint`is replaced by a call to `luacheck`. This change is rather trivial, still a new grunt should be created and properly packaged. Use of `grunt-env` comes from the `lualint` and is probably not necessary anymore.

A quick fix to make grunt work until all is properly packaged is to comment out all use of `grunt-contrib-lualint` and `grunt-env`.