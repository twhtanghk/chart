<template>
  <div class='container'>
    <div ref='candle'/>
    <price-div :data='data'/>
  </div>
</template>

<script lang='coffee'>
{Data} = require('./plugins/model.coffee').default
{ma} = require('./plugins/lib.coffee').default
{SMA, EMA} = require 'technicalindicators'
Plotly = require 'plotly.js'
unpack = (rows, key) ->
  rows.map (row) ->
    row[key]

export default
  name: 'App'
  components:
    priceDiv: require('./components/priceDiv').default
  data: ->
    data: null
  methods:
    candle: (data) ->
      x: unpack data, 'date'
      close: unpack data, 'close'
      open: unpack data, 'open'
      low: unpack data, 'low'
      high: unpack data, 'high'
      decreasing: line: color: 'red'
      increasing: line: color: 'green'
      line: color: 'rgba(31,119,180,1)'
      type: 'candlestick'
      xaxis: 'x'
      yaxis: 'y'
    ma: (data, period, {color, name}, calc) ->
      values = unpack data, 'close'
      x: unpack(data, 'date').slice 0, data.length - period + 1
      y: calc {values, period}
      line: {color}
      type: 'line'
      xaxis: 'x'
      yaxis: 'y'
      name: name
  mounted: ->
    {searchParams} = new URL window.location.href
    id = searchParams.get 'id'
    @data = await Data.list data: id: id
    layout = 
      dragmode: 'zoom'
      showlegend: false
      xaxis:
        autorange: true
        domain: [0, 1]
        type: 'category'
        categoryorder: 'category ascending'
        rangeslider:
          visible: false
      yaxis:
        autorange: true
        domain: [0, 1]
        type: 'linear'
    plots = [
      @candle @data
      @ma @data, 20, {color: 'red', name: 'sma 20'}, SMA.calculate
      @ma @data, 60, {color: 'orange', name: 'sma 60'}, SMA.calculate
      @ma @data, 20, {color: 'green', name: 'ema 20'}, EMA.calculate
      @ma @data, 60, {color: 'blue', name: 'ema 60'}, EMA.calculate
    ]
    Plotly.newPlot @$refs.candle, plots, layout
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
