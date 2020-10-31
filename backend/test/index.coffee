{getHistoricalPrices} = require 'yahoo-stock-api'

get = (code) ->
  data = await getHistoricalPrices new Date('01/01/2020'), new Date(), code, '1d'
  console.log data

do ->
  await get '0388.HK'
