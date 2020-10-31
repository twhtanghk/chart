{Model} = require('model').default
moment = require 'moment'

class Data extends Model
  format: (data) ->
    if data.date?
      data.date = moment(new Date(data.date * 1000)).format 'DD-MM-YYYY'
    data

export default
  Data: new Data
    baseUrl: "#{process.env.API_URL}/data"
