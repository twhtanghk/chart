<template>
  <div class='container'>
  </div>
</template>

<script lang='coffee'>
{Data} = require('./plugins/model.coffee').default
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
        .map ({x, y}) ->
          x: x
          y: y
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
      type: 'candlestick'
      xaxis: 'x'
    ma: (period, {color, name}, calc) ->
      {x, y} = ma @data, period, calc
      x: x
      y: y
      line: {color}
      type: 'line'
      xaxis: 'x'
      name: name
    traces: ->
      [
        @market()
        @ma 20, {color: 'red', name: 'sma 20'}, SMA.calculate
        @ma 60, {color: 'orange', name: 'sma 60'}, SMA.calculate
        @ma 20, {color: 'green', name: 'ema 20'}, EMA.calculate
        @ma 60, {color: 'blue', name: 'ema 60'}, EMA.calculate
      ].concat @priceDiv()
  mounted: ->
    {searchParams} = new URL window.location.href
    id = searchParams.get 'id'
    @data = await Data.list data: id: id
  watch:
    data: ->
      layout =
        showlegend: false
        xaxis:
          type: 'category'
          categoryorder: 'category ascending'
          rangeslider:
            visible: false
        yaxis2:
          overlaying: 'y'
          side: 'right'
          range: [-10, 50]
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
