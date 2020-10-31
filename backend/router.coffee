Router = require 'koa-router'
router = new Router()
{getHistoricalPrices} = require 'yahoo-stock-api'
moment = require 'moment'
serve = require 'koa-static'

module.exports = router
  .get '/data', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    start = moment()
      .subtract 90, 'days'
      .toDate()
    {error, currency, response} = await getHistoricalPrices start, new Date(), id, '1d'
    if error
      throw error
    ctx.response.body = response
