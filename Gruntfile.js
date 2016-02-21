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
					src: ['index.html','cssmain.css','dep.html'],
					dest: 'dist/'
				}]
			},
			templated: {
				files: [{
					expand: false,
					src: ['.tmp/jsmain.js'],
					dest: 'dist/jsmain.js'
				}]
			}
		},
		includereplace: {
			build_js: {
				options: {
						// Task-specific options go here.
				},
				// Files to perform replacements and includes with
				src: 'jsmain.js',
				// Destination directory to copy files to
				dest: '.tmp/'
			}
		},
				
		'gh-pages': {
			options: {
				base: 'dist'
			},
			src: ['**']
		}
	});

    grunt.registerTask('build', ['clean:dist', 'clean:temp', 'includereplace:build_js', 'copy:dist', 'copy:templated', 'clean:temp']);

	require('load-grunt-tasks')(grunt);
};
