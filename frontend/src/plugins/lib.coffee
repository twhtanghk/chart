{EMA} = require 'technicalindicators'

self =
  unpack: (rows, key) ->
    rows.map (row) ->
      row[key]
  ma: (data, period, calc) ->
    values = self.unpack data, 'close'
    x = self.unpack data,'date'
      .slice 0, data.length - period + 1
    y = calc {values, period}
    {x, y}
  priceDiv: (data) ->
    x = self.unpack data, 'date'
    close = self.unpack data, 'close'
    ema = 
      20: self.ma data, 20, EMA.calculate
      60: self.ma data, 60, EMA.calculate
      120: self.ma data, 120, EMA.calculate
    diff = [
      ema['20']
        .y
        .map (price, i) ->
          (close[i]- price) / close[i] * 100
      ema['60']
        .y
        .map (price, i) ->
          (ema['20'].y[i] - price) / close[i] * 100
      ema['120']
        .y
        .map (price, i) ->
          (ema['60'].y[i] - price) / close[i] * 100
    ]
    [
      {x: x, y: diff[0]}
      {x: x, y: diff[1]}
      {x: x, y: diff[2]}
    ]

export default self
