<template>
  <div/>
</template>

<script lang='coffee'>
{unpack, ma} = require('../plugins/lib.coffee').default
{SMA, EMA} = require 'technicalindicators'
Plotly = require 'plotly.js'

export default
  props: [
    'data'
  ]
  methods:
    traces: ->
      [
        @candle()
        @ma 20, {color: 'red', name: 'sma 20'}, SMA.calculate
        @ma 60, {color: 'orange', name: 'sma 60'}, SMA.calculate
        @ma 20, {color: 'green', name: 'ema 20'}, EMA.calculate
        @ma 60, {color: 'blue', name: 'ema 60'}, EMA.calculate
      ]
    candle: ->
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
  watch:
    data: ->
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
      if @data?
        Plotly.newPlot @$el, @traces(), layout
</script>
