url = 'https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2'
needle = require 'needle'

module.exports =
  token: (symbol) ->
    query = "{tokens (first: 1, orderDirection: desc, orderBy: tradeVolume, where: {symbol: \"#{symbol}\"}) { id symbol name tradeVolume }}"
    (await needle 'post', url, {query}, json: true).body.data.tokens[0]
  ohlc: (id, days=365) ->
    query = "{tokenDayDatas (first: #{days}, orderBy: date, orderDirection: desc, where:{token: \"#{id}\"}){ id date priceUSD dailyVolumeUSD } }"
    data = (await needle 'post', url, {query}, json: true)
      .body.data.tokenDayDatas
      .map ({date, dailyVolumeUSD, priceUSD}) ->
        date = new Date date * 1000
        {date, price: priceUSD, volume: dailyVolumeUSD}
    curr = data[0]
    data[1..].map ({date, price, volume}) ->
      ret = 
        date: curr.date
        open: price
        close: curr.price
        high: Math.max price, curr.price
        low: Math.min price, curr.price
        volume: curr.volume
      curr = {date, price, volume}
      ret
