module.exports =
  cron: [
    {
      at: [
        "0 */5 9-15 * * 1-5"
      ]
      task: =>
        for code, stock of @stock
          @mqtt.client.publish 'stock/yahoo', JSON.stringify
            src: 'yahoo'
            symbol: code
            quote: await stock.quote()
    }
  ]
