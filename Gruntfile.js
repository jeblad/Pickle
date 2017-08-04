/* jshint node:true */
module.exports = function ( grunt ) {
	grunt.loadNpmTasks( 'grunt-contrib-csslint' );
	grunt.loadNpmTasks( 'grunt-contrib-jshint' );
	grunt.loadNpmTasks( 'grunt-jsonlint' );
	grunt.loadNpmTasks( 'grunt-banana-checker' );
	grunt.loadNpmTasks( 'grunt-jscs' );
	grunt.loadNpmTasks( 'grunt-eslint' );
	grunt.loadNpmTasks( 'grunt-stylelint' );
	grunt.loadNpmTasks( 'grunt-contrib-lualint' );
	grunt.loadNpmTasks( 'grunt-markdownlint' );
	grunt.loadNpmTasks( 'grunt-lintspaces' );

	grunt.initConfig( {
		lintspaces: {
			all: {
				src: [
					'*.js',
					'**/*.js',
					'**/*.css',
					'!node_modules/**',
					'!vendor/**'
				],
				options: {
					newline: true,
					newlineMaximum: 2,
					trailingspaces: true,
					indentation: 'tabs',
					ignores: [ 'js-comments' ]
				}
			},
			json: {
				src: [
					'.eslintrc',
					'.jscsrc',
					'.jshintrc',
					'*.json',
					'!node_modules/**',
					'!vendor/**'
				],
				options: {
					newlineMaximum: 2,
					trailingspaces: true,
					indentationGuess: true,
					ignores: [ 'js-comments' ]
				}
			},
			lua: {
				src: [
					'**/*.lua',
					'!node_modules/**',
					'!vendor/**'
				],
				options: {
					newline: true,
					newlineMaximum: 2,
					trailingspaces: true,
					indentation: 'tabs',
					ignores: [ /^\t*--/g ]
				}
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
		lualint: {
			src: [
				'includes/LuaLibrary/**/*.lua',
				'tests/LuaLibrary/**/*.lua'
			]
		},
		markdownlint: {
			options: {
				config: {
					'default': true,
					MD013: false
				}
			},
			all: [
				'**/*.md',
				'!node_modules/**',
				'!vendor/**'
			]
		}
	} );

	grunt.registerTask( 'lint',
		[
			'lintspaces',
			'csslint',
			'stylelint',
			'eslint',
			'jshint',
			'jsonlint',
			'banana',
			'markdownlint'
		] );
	grunt.registerTask( 'smell',
		[
			'jscs',
			'lualint'
		] );
	grunt.registerTask( 'test',
		[
			'lint',
			'smell'
		] );
	grunt.registerTask( 'default',
		[
			'test'
		] );
};
