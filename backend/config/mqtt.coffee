{connect} = require 'mqtt'
{Stock} = require 'yahoo-stock'

module.exports =
  mqtt:
    client:
      connect process.env.MQTTURL,
        username: process.env.MQTTUSER
        clientId: process.env.MQTTCLIENT
        clean: false 
      .on 'connect', ->
        @subscribe process.env.MQTTTOPIC, qos: 2
      .on 'error', console.error
      .on 'message', (topic, msg) ->
        try
          {action, data} = JSON.parse msg.toString()
        catch err
          console.error err
        {stock} = global.config
        if topic == 'stock'
          switch action
            when 'subscribe'
              for code in data
                try
                  if code not of stock
                    stock[code] = new Stock code
                  @publish 'stock/yahoo', JSON.stringify 
                    src: 'yahoo'
                    symbol: code
                    quote: await stock[code].quote()
                    indicators: await stock[code].indicators()
                catch err
                  console.error "error to fetch #{code}"
            when 'unsubscribe'
              data.map (code) ->
                delete stock[code]
