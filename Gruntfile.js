module.exports = function(grunt) {

	grunt.initConfig({
		clean: {
			  dist: ["dist"],
				temp: [".tmp"]
		},
		copy: {
			dist: {
				files: [{
					expand: true,
					cwd: '.tmp/final',
					src: ['*.min.css', '*.min.js', '*.html'],
					flatten: true,
					dest: 'dist/'
				}]
			},
			templated: {
				files: [{
					expand: true,
					flatten: true,
					src: ['.tmp/*.js', '.tmp/*.html'],
					dest: 'dist/'
				}]
			}
		},
		cssmin: {
			target: {
				files: [{
					expand: false,
					src: ['cssmain.css'],
					dest: '.tmp/final/combined.min.css',
				}]
			}
		},
		uglify: {
   	 all_js: {
      files: {
        	'.tmp/final/combined.min.js': ['.tmp/templated/jsmain.js']
      	}
  	  }
 		},
		htmlmin: {
			dist: {
				options: {
					removeComments: true,
					collapseWhitespace: true
				},
				files: [{
					expand: true,
					cwd: '.tmp/templated',
					src: ['*.html'],
					dest: '.tmp/final'
					}]
				}
    },
		includereplace: {
			build_all: {
				options: {
						// Task-specific options go here.
				},
				// Files to perform replacements and includes with
				src: ['jsmain.js', 'index.html', 'dep.html'],
				// Destination directory to copy files to
				dest: '.tmp/templated/'
			}
		},
				
		'gh-pages': {
			options: {
				base: 'dist'
			},
			src: ['**']
		}
	});

    grunt.registerTask('build', ['clean:dist', 'clean:temp', 'includereplace:build_all', 'htmlmin:dist', 'uglify:all_js', 'cssmin', 'copy:dist', 'clean:temp']);

	require('load-grunt-tasks')(grunt);
};
