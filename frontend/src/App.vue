<template>
  <div class='container'>
  </div>
</template>

<script lang='coffee'>
{Data} = require('./plugins/model.coffee').default
sma = require 'sma'
Plotly = require 'plotly.js'
unpack = (rows, key) ->
  rows.map (row) ->
    row[key]

export default
  name: 'App'
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
    sma: (data, period, color) ->
      values = unpack data, 'close'
      x: unpack(data, 'date').slice 0, data.length - period + 1
      y: sma values, period
      line: {color}
      type: 'line'
      xaxis: 'x'
      yaxis: 'y'
  mounted: ->
    {searchParams} = new URL window.location.href
    id = searchParams.get 'id'
    data = await Data.list data: id: id
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
     Plotly.newPlot @$el, [@candle(data), @sma(data, 20, 'red'), @sma(data, 60, 'blue')], layout  
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
