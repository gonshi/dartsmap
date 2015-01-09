module.exports = {
  js: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/js',
      src:['lib/**/*.js'],
      dest: '<%= config.dir.tmp %>/js'
    }]
  },
  jsProd: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/js/',
      src:['lib/**/*.js'],
      dest: '<%= config.dir.dist %>/js/'
    }]
  },
  img: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/img',
      src:['**/*'],
      dest: '<%= config.dir.tmp %>/img'
    }]
  },
  imgProd: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/img',
      src:['**/*'],
      dest: '<%= config.dir.dist %>/img'
    }]
  }
};
