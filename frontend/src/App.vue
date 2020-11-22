<template>
  <div/>
</template>

<script lang='coffee'>
{Stock, CryptoCurr} = require('./plugins/model.coffee').default
{SMA, EMA} = require 'technicalindicators'
Plotly = require 'plotly.js'
{unpack, priceDiv, ma} = require('./plugins/lib.coffee').default

export default
  name: 'App'
  data: ->
    data: null
  methods:
    priceDiv: ->
      priceDiv @data
        .map ({x, y, name, color}) ->
          x: x
          y: y
          name: name
          line: {color}
          type: 'line'
          xaxis: 'x'
          yaxis: 'y2'
    market: ->
      x: unpack @data, 'date'
      close: unpack @data, 'close'
      open: unpack @data, 'open'
      low: unpack @data, 'low'
      high: unpack @data, 'high'
      decreasing: line: color: 'red'
      increasing: line: color: 'green'
      line: color: 'rgba(31,119,180,1)'
      name: 'ohlc'
      type: 'candlestick'
      xaxis: 'x'
      yaxis: 'y'
    ma: (period, {color, name}, calc) ->
      {x, y} = ma @data, period, calc
      x: x
      y: y
      line: {color}
      type: 'line'
      xaxis: 'x'
      yaxis: 'y'
      name: name
    traces: ->
      @priceDiv().concat [
        @market()
        @ma 20, {color: 'red', name: 'ema 20'}, EMA.calculate
        @ma 60, {color: 'green', name: 'ema 60'}, EMA.calculate
        @ma 120, {color: 'blue', name: 'ema 120'}, EMA.calculate
      ]
    fetch: ->
      {type, id} = @$route.params
      switch type
        when 'stock'
          @data = await Stock.list data: id: id
        when 'cryptoCurr'
          @data = await CryptoCurr.list data: id: id
  mounted: ->
    @fetch()
  watch:
    '$route': ->
      @fetch()
    data: ->
      layout =
        showlegend: false
        grid:
          rows: 2
          columns: 1
          subplots: ['xy2', 'xy']
          roworder: 'bottom to top'
        xaxis:
          type: 'category'
          categoryorder: 'category ascending'
          rangeslider:
            visible: false
        yaxis:
          domain: [0, 0.7]
        yaxis2:
          domain: [0.8, 1]
      if @data?
        Plotly.newPlot @$el, @traces(), layout
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
