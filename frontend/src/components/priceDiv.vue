<template>
  <div/>
</template>

<script lang='coffee'>
Plotly = require 'plotly.js'
{priceDiv} = require('../plugins/lib.coffee').default

export default
  props: [
    'data'
  ]
  methods:
    traces: ->
      priceDiv @data
        .map ({x, y}) ->
          x: x
          y: y
          type: 'line'
          xaxis: 'x'
          yaxis: 'y'
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
      if @data?
        Plotly.newPlot @$el, @traces(), layout
</script>
