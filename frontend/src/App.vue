<template>
  <div class='container'>
    <candle :data='data'/>
    <price-div :data='data'/>
  </div>
</template>

<script lang='coffee'>
{Data} = require('./plugins/model.coffee').default

export default
  name: 'App'
  components:
    candle: require('./components/candle').default
    priceDiv: require('./components/priceDiv').default
  data: ->
    data: null
  mounted: ->
    {searchParams} = new URL window.location.href
    id = searchParams.get 'id'
    @data = await Data.list data: id: id
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
