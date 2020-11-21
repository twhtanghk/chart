{getHistoricalPrices} = require 'yahoo-stock-api'
{token, ohlc} = require '../graph.coffee'

do ->
  console.log await getHistoricalPrices new Date('01/01/2020'), new Date(), '0388.HK', '1d'
  {id} = await token 'WETH'
  console.log await ohlc id
