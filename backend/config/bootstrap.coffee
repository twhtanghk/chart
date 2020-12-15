_ = require 'lodash'
{symbol} = require 'analysis'
list = []

module.exports = bootstrap: ->
  require 'mqtt'
    .connect process.env.MQTTURL,
      username: process.env.MQTTUSER
      clientId: process.env.MQTTCLIENT
      clean: false
    .on 'connect', ->
      client.subscribe process.env.MQTTTOPIC, qos: 2
    .on 'message', (topic, msg) ->
      {action, data} = JSON.parse msg.toString()
      switch action
        when 'subscribe'
          list = _
            .uniq list.concat data
            .sort()
