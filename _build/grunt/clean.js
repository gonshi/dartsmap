module.exports = {
  temp:['<%= config.dir.tmp %>/**/*'],
  prod:{
    src: [ '<%= config.dir.dist %>/img/**/*' ],
    options: {
      force: true
    }
  },
  bower:['<%= config.dir.src %>/js/lib/*']
};
