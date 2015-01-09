module.exports = function(grunt) {
  return {
    all: {
      files: {
        '<%= config.dir.tmp %>/js/app.js': '<%= config.dir.src %>/coffee/main.coffee',
      },
      options: {
        transform: ['coffeeify', 'debowerify'],
        browserifyOptions: {
          debug: true,
          extensions: '.coffee'
        }
      }
    }
  }
};
