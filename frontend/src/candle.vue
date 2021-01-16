<template>
  <div>
    <div id='candle'/>
    <div id='priceDiv'/>
  </div>
</template>

<script lang='coffee'>
{Stock, CryptoCurr} = require('./plugins/model.coffee').default
{SMA, EMA} = require 'technicalindicators'
ApexCharts = require 'apexcharts'
{unpack, priceDiv, ma} = require('./plugins/lib.coffee').default
moment = require 'moment'

export default
  name: 'App'
  data: ->
    data: null
    candle: null
    priceDiv: null
  methods:
    fetch: ->
      {type, id} = @$route.params
      switch type
        when 'stock'
          @data = await Stock.list data: id: id
        when 'cryptoCurr'
          @data = await CryptoCurr.list data: id: id
      series = [
        {
          name: 'candle'
          type: 'candlestick'
          data: {x: date, y: [open, high, low, close]} for {date, open, high, low, close} in @data
        }
        {
          name: 'ema20'
          type: 'line'
          data: ma @data, 20, EMA.calculate
        }
        {
          name: 'ema60'
          type: 'line'
          data: ma @data, 60, EMA.calculate
        }
        {
          name: 'ema120'
          type: 'line'
          data: ma @data, 120, EMA.calculate
        }
        {
          name: 'basePrice'
          type: 'scatter'
          data: [
            {x: @data[20 - 1].date, y: @data[20 - 1].low, fillColor: 'yellow'}
            {x: @data[60 - 1].date, y: @data[60 - 1].low, fillColor: 'yellow'}
            {x: @data[120 - 1].date, y: @data[120 - 1].low, fillColor: 'yellow'}
          ]
        }
      ]
      @candle.updateOptions
        xaxis:
          type: 'datetime'
          labels: 
            formatter: (value, timestamp, opts) ->
              moment(timestamp).format 'YYYY-MM-DD'
        yaxis:
          decimalsInFloat: 2
          min: =>
            Math.min ...(low for {low} in @data)
          max: =>
            Math.max ...(high for {high} in @data)
      @candle.updateSeries series
  mounted: ->
    tooltip =
      default: ({seriesIndex, dataPointIndex, w}) ->
        w.globals.series[seriesIndex][dataPointIndex].toFixed 2
      candle: ({seriesIndex, dataPointIndex, w}) ->
        o = w.globals.seriesCandleO[seriesIndex][dataPointIndex]
        h = w.globals.seriesCandleH[seriesIndex][dataPointIndex]
        l = w.globals.seriesCandleL[seriesIndex][dataPointIndex]
        c = w.globals.seriesCandleC[seriesIndex][dataPointIndex]
        "open: #{o.toFixed(2)}, high: #{h.toFixed(2)}, low: #{l.toFixed(2)}, close: #{c.toFixed(2)}"
    @candle = new ApexCharts document.getElementById('candle'),
      chart:
        type: 'candlestick'
      dataLabels:
        enabled: false
      series: []
      colors: ['', 'red', 'green', 'blue', 'yellow']
      markers: 
        colors: ['', 'red', 'green', 'blue', 'yellow']
        size: [0, 2, 2, 2, 6]
      tooltip:
        shared: true
        custom: [
          tooltip.candle
          tooltip.default
          tooltip.default
          tooltip.default
          tooltip.default
        ]
      noData:
        text: 'Loading'
    @candle.render()
    @priceDiv = new ApexCharts document.getElementById('priceDiv'),
      chart:
        type: 'line'
      dataLabels:
        enabled: false
      series: []
    @priceDiv.render()
    @fetch()
</script>