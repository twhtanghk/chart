<template>
  <div/>
</template>

<script lang='coffee'>
{Breadth} = require('./plugins/model.coffee').default
Plotly = require 'plotly.js'
{unpack} = require('./plugins/lib.coffee').default

export default
  name: 'breadth'
  methods:
    heatmap: ->
      id = process.env.PEERS
        .split ','
      console.log id
      data = await Breadth.list data: id: id
      console.log data
      layout =
        xaxis:
          type: 'category'
          categoryorder: 'category ascending'
      # Plotly.newPlot @$el, 
  mounted: ->
    @heatmap()
</script>
