module.exports = {
  options: {
    pretty: true,
    basedir: '<%= config.dir.src %>/jade'
  },
  compile: {
    options: {
      pretty: true,
      data: {
        prod: false,
        debug: true,
        sc: '<%= config.jade.js %>',
        libs: '<%= config.jade.libs %>',
        meta: '<%= config.jade.meta %>'
      }
    },
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/jade',
      src: '**/!(_)*.jade',
      dest: '<%= config.dir.tmp %>',
      ext: '.html'
    }]
  },
  prod: {
    options: {
      pretty: true,
      data: {
        prod: true,
        libs: '<%= config.jade.libs %>',
        meta : '<%= config.jade.meta %>'
      }
    },
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/jade',
      src: '**/!(_)*.jade',
      dest: '<%= config.dir.dist %>',
      ext: '.html'
    }]
  }
};
