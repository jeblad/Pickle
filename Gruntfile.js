/*jshint node:true */
module.exports = function ( grunt ) {
	grunt.loadNpmTasks( 'grunt-contrib-csslint' );
	grunt.loadNpmTasks( 'grunt-contrib-jshint' );
	grunt.loadNpmTasks( 'grunt-jsonlint' );
	grunt.loadNpmTasks( 'grunt-banana-checker' );
	grunt.loadNpmTasks( 'grunt-jscs' );
	grunt.loadNpmTasks( 'grunt-eslint' );
	grunt.loadNpmTasks( 'grunt-stylelint' );
	grunt.loadNpmTasks( 'grunt-phplint' );
	grunt.loadNpmTasks( 'grunt-phpcs' );
	grunt.loadNpmTasks( 'grunt-contrib-lualint' );
	grunt.loadNpmTasks( 'grunt-markdownlint' );
	grunt.loadNpmTasks( 'grunt-gulp' );
	grunt.loadNpmTasks( 'grunt-env' );

	grunt.initConfig( {
		env: {
			lint: {},
			smell: {
				LUA_PATH: '/vagrant/mediawiki/extensions/Pickle/includes/LuaLibrary/lua/pure/\?.lua'
			}
		},
		csslint: {
			all: [
				'modules/**/*.css'
			]
		},
		stylelint: {
			core: {
				src: [
					'modules/**/*.css',
					'!node_modules/**',
					'!vendor/**'
				]
			}
		},
		eslint: {
			all: [
				'modules/**/*.js',
				'!node_modules/**',
				'!vendor/**'
			]
		},
		jshint: {
			options: {
				jshintrc: true
			},
			all: [
				'*.js',
				'modules/**/*.js'
			]
		},
		jscs: {
			src: '<%= jshint.all %>'
		},
		banana: {
			all: 'i18n/'
		},
		jsonlint: {
			all: [
				'**/*.json',
				'!node_modules/**',
				'!vendor/**'
			]
		},
		phplint: {
			options: {
				swapPath: '/tmp'
			},
			all: [
				'**/*.php',
				'!node_modules/**',
				'!vendor/**'
			]
		},
		phpcs: {
			all: [
				'*.php',
				'includes/**/*.php',
				'tests/**/*.php',
				'modules/**/*.js',
				'!node_modules/**',
				'!vendor/**'
			],
			options: {
				extensions: [ 'php' ]
			}
		},
		lualint: {
			src: [
				'includes/LuaLibrary/**/*.lua',
				'tests/LuaLibrary/**/*.lua'
			]
		},
		markdownlint: {
			all: [
				'**/*.md',
				'!node_modules/**',
				'!vendor/**'
			]
		},
		gulp: {
			options: {
				tasks: function ( stream ) {
					return stream.pipe( require( 'gulp-coffee' )() );
				}
			},
			'dist/bundle.js': [
				'lib/*.coffee'
			]
		}
	} );

	grunt.registerTask( 'lint', [ 'env:lint', 'csslint', 'stylelint', 'eslint', 'jshint', 'jsonlint', 'banana', 'phplint', 'markdownlint' ] );
	grunt.registerTask( 'smell', [ 'env:smell', 'jscs', 'phpcs', 'lualint' ] );
	// grunt.registerTask( 'lint', [ 'csslint', 'stylelint', 'eslint', 'jshint', 'jsonlint', 'banana', 'phplint', 'markdownlint' ] );
	// grunt.registerTask( 'smell', [ 'jscs', 'phpcs', 'lualint' ] );
	grunt.registerTask( 'default', [ 'lint', 'smell' ] );
};
