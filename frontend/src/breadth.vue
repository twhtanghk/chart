<template>
  <div/>
</template>

<script lang='coffee'>
{Sector} = require 'yahoo-stock'
{Breadth} = require('./plugins/model.coffee').default
{unpack} = require('./plugins/lib.coffee').default
ApexCharts = require 'apexcharts'
moment = require 'moment'

export default
  name: 'breadth'
  methods:
    heatmap: ->
      sectors = for name in Sector.list
        name: name
        breadth: await Breadth.list data: id: name
      opts =
        chart:
          type: 'heatmap'
        dataLabels:
          enabled: false
        plotOptions:
          heatmap:
            enableShades: true
            shadeIntensity: 0.9
            colorScale:
              ranges: [
                { from: 0, to: 30, color: '#FF0000', name: 'low' }
                { from: 31, to: 100, color: '#1E8449', name: 'high'}
              ]
        series:
          for {name, breadth} in sectors
            name: name
            data: {x: moment(date, "YYYY-MM-DD").format('YYYY-MM-DD'), y: percent} for {date, percent} in breadth
      chart = new ApexCharts @$el, opts
      chart.render()
  mounted: ->
    @heatmap()
</script>
