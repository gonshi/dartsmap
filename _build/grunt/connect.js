var path = require('path');
var lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet;
var proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest;
var mountFolder = function (connect, dir) {
  return connect.static(path.resolve(dir));
};

module.exports = {
  proxies: [{
    context: '/api',
    host: 'localhost',
    port: '3000',
    https: false,
    changeOrigin: false
  }],
  server: {
    options: {
      port: 9000,
      // change this to '0.0.0.0' to access the server from outside
      hostname: 'localhost',
      open: true,
      middleware: function (connect) {
        return [
          lrSnippet,
          proxySnippet,
          mountFolder(connect, '.tmp/')
        ];
      }
    }
  }
};
