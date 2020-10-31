<template>
  <div class='container'>
  </div>
</template>

<script lang='coffee'>
{Data} = require('./plugins/model.coffee').default
Plotly = require 'plotly.js'
unpack = (rows, key) ->
  rows.map (row) ->
    row[key]

export default
  name: 'App'
  mounted: ->
    {searchParams} = new URL window.location.href
    id = searchParams.get 'id'
    data = await Data.list data: id: id
    trace =
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
    data = [trace]
    layout = 
      dragmode: 'zoom'
      showlegend: false
      xaxis:
        autorange: true
        domain: [0, 1]
        title: 'Date'
        type: 'category'
        categoryorder: 'category ascending'
        rangeslider:
          visible: false
      yaxis:
        autorange: true
        domain: [0, 1]
        type: 'linear'
     Plotly.newPlot @$el, data, layout  
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
