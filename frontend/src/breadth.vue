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
          events: 
            click: (event, chartContext, {seriesIndex}) ->
              if sectors[seriesIndex]?
                window.open "https://hk.finance.yahoo.com/industries/#{sectors[seriesIndex].name}"
              event.stopPropagation()
        dataLabels:
          enabled: false
        plotOptions:
          heatmap:
            enableShades: true
            shadeIntensity: 0.5
            reverseNegativeShade: true
            colorScale:
              ranges: [
                { from: 1, to: 50, color: '#1E8449', name: 'high'}
                { from: -50, to: 0, color: '#FF0000', name: 'low' }
              ]
        series:
          for {name, breadth} in sectors
            name: name
            data: {x: moment(date, "YYYY-MM-DD").format('YYYY-MM-DD'), y: Math.round percent - 50} for {date, percent} in breadth
      chart = new ApexCharts @$el, opts
      chart.render()
  mounted: ->
    @heatmap()
</script>
