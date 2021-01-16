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
    {x: date, y: y[i]} for date, i in x
  priceDiv: (data) ->
    x = self.unpack data, 'date'
    close = self.unpack data, 'close'
    ema = 
      20: self.ma data, 20, EMA.calculate
      60: self.ma data, 60, EMA.calculate
      120: self.ma data, 120, EMA.calculate
    [
      ema['20']
        .map ({x, y}, i) ->
          x: data[i].date
          y: (data[i].close - y) / data[i].close * 100
      ema['60']
        .map ({x, y}, i) ->
          x: data[i].date
          y: (ema['20'][i].y - y) / data[i].close * 100
      ema['120']
        .map ({x, y}, i) ->
          x: data[i].date
          y: (ema['60'][i].y - y) / data[i].close * 100
    ]

export default self
