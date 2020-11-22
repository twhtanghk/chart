{Model} = require('model').default
moment = require 'moment'

class Data extends Model
  format: (data) ->
    if data.date?
      data.date = moment(new Date(data.date * 1000)).format 'YYYY-MM-DD'
    data

export default
  Stock: new Data
    baseUrl: "#{process.env.API_URL}/stock"
  CryptoCurr: new Data
    baseUrl: "#{process.env.API_URL}/cryptoCurr"
