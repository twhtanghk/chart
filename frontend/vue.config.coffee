{EnvironmentPlugin} = require 'webpack'
CompressionWebpackPlugin = require 'compression-webpack-plugin'

module.exports =
  publicPath: '.'
  outputDir: '../backend/dist'
  lintOnSave: false
  pwa:
    name: 'portfolio'
    workboxPluginMOde: 'GenerateSW'
  pages:
    index:
      entry: 'src/main.js'
      template: 'public/index.html'
      filename: 'index.html'
  configureWebpack: (config) ->
    if process.env.NODE_ENV == 'production'
      config.plugins.push new CompressionWebpackPlugin
        deleteOriginalAssets: true
        include: [
          /\.ico$/
          /\.html$/
          /\.js$/
          /\.css$/
          /\.map$/
        ]
      process.env.API_URL = '.'
    config.plugins.push new EnvironmentPlugin [
      'API_URL'
      'PEERS'
    ]
    config.module.rules.push
      test: /\.coffee$/
      use: [
        'coffee-loader'
      ]
    return
