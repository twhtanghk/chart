{getHistoricalPrices} = require 'yahoo-stock-api'
{historical} = require 'coindesk.js'

do ->
  console.log await getHistoricalPrices new Date('01/01/2020'), new Date(), '0388.HK', '1d'
  console.log await historical
    start: new Date('01/01/2020')
    end: new Date()
    currency: 'USD'
