url = 'https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2'
needle = require 'needle'

module.exports =
  token: (symbol) ->
    query = "{tokens (first: 1, orderDirection: desc, orderBy: tradeVolume, where: {symbol: \"#{symbol}\"}) { id symbol name tradeVolume }}"
    (await needle 'post', url, {query}, json: true).body.data.tokens[0]
  ohlc: (id, days=365) ->
    query = "{tokenDayDatas (first: #{days}, orderBy: date, orderDirection: desc, where:{token: \"#{id}\"}){ id date priceUSD dailyVolumeUSD token { id symbol } } }"
    console.log (await needle 'post', url, {query}, json: true).body.data
