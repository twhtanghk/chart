_ = require 'lodash'
{symbol, indicators} = require 'analysis'

module.exports = bootstrap: ->
  client = require 'mqtt'
    .connect process.env.MQTTURL,
      username: process.env.MQTTUSER
      clientId: process.env.MQTTCLIENT
      clean: false
    .on 'connect', ->
      client.subscribe process.env.MQTTTOPIC, qos: 2
    .on 'message', (topic, msg) ->
      {action, data} = JSON.parse msg.toString()
      if topic == 'stock'
        switch action
          when 'subscribe'
            for code in data
              try
                if code not of global.config.stock
                  opts =
                    json: true
                    headers:
                      'X-HTTP-Method-Override': 'GET'
                  global.config.stock[code] = await indicators code
                message = JSON.stringify 
                  src: 'indicators'
                  symbol: code
                  indicators: global.config.stock[code]
                client.publish 'stock/indicators', message
              catch err
                console.error "error to fetch #{code}"
          when 'unsubscribe'
            data.map (code) ->
              delete global.config.stock[code]
