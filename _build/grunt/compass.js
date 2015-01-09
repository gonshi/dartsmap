module.exports = {
  dev: {
    options: {
        sourcemap: true
    }
  },
  prod: {
    options: {
      environment: 'production',
      force: true
    }
  }
};
