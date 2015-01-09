module.exports = {
  options: {
    preserveComments: 'some',
    mangle: {
      except: ['$', '_', 'namespace']
    }
  },
  apps: {
    files: {
      '<%= config.dir.dist %>/js/app.min.js': ['<%= config.dir.tmp %>/js/app.js']
    }
  }
};
