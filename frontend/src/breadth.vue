<template>
  <div/>
</template>

<script lang='coffee'>
{Sector} = require 'yahoo-stock'
{Breadth} = require('./plugins/model.coffee').default
Plotly = require 'plotly.js'
{unpack} = require('./plugins/lib.coffee').default

export default
  name: 'breadth'
  methods:
    heatmap: ->
      for name in Sector.list
        name: name
        breadth: await Breadth.list data: id: name
      layout =
        xaxis:
          type: 'category'
          categoryorder: 'category ascending'
      # Plotly.newPlot @$el, 
  mounted: ->
    @heatmap()
</script>
