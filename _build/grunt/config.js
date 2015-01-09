module.exports = function(grunt) {
  var testFiles = [];
  testFiles.push('test/**/*.js');

  return {
    dir: {
      src: 'src',
      tmp: '.tmp',
      dist: '..'
    },
    pkg: grunt.file.readJSON('package.json'),
    jade: {
      meta: grunt.file.readJSON('config/meta.json')
    },
    files: {
      testFiles: testFiles
    }
  };
};
