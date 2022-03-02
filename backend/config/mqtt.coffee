{connect} = require 'mqtt'
{Stock} = require 'yahoo-stock'
{ohlc, dataForgeIndicators} = require 'analysis'

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
        {stock, history} = global.config
        if topic == 'stock'
          switch action
            when 'subscribe'
              for code in data
                try
                  if code not of stock
                    stock[code] = new Stock code
                  if code not of history
                    rows = await ohlc.stock code
                    {validate, ema, rsi} = dataForgeIndicators
                    rows = validate rows
                    rows = ema rows
                    rows = rsi rows
                    {emaS, emaM, emaL, rsi} = rows.last()
                    history[code] =
                      indicators: await stock[code].indicators()
                      ema: [emaS, emaM, emaL]
                      rsi: rsi
                  @publish 'stock/analysis', JSON.stringify
                    src: 'yahoo'
                    symbol: code
                    analysis: history[code]
                catch err
                  console.error "error to fetch #{code}"
            when 'unsubscribe'
              data.map (code) ->
                delete stock[code]
