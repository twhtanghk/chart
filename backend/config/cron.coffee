module.exports =
  cron: [
    {
      at: [
        "0 */5 9-15 * * 1-5"
      ]
      task: ->
        {stock, mqtt} = global.config
        for code, s of stock
          mqtt.client.publish 'stock/yahoo', JSON.stringify
            src: 'yahoo'
            symbol: code
            quote: await s.quote()
    }
  ]
