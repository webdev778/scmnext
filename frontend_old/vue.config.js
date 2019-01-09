module.exports = {
  lintOnSave: false,
  runtimeCompiler: true,
  devServer: {
    headers: {
      'Access-Control-Allow-Origin': '*'
    },
    host: '192.168.33.21',
    watchOptions: {
      poll: true
    }
  }
}
