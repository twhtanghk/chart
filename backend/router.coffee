Router = require 'koa-router'
router = new Router()
{getHistoricalPrices} = require 'yahoo-stock-api'
moment = require 'moment'
serve = require 'koa-static'
{token, ohlc} = require './graph.coffee'

module.exports = router
  .get '/stock', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    start = moment()
      .subtract 365, 'days'
      .toDate()
    {error, currency, response} = await getHistoricalPrices start, new Date(), id, '1d'
    if error
      throw error
    ctx.response.body = response.filter (row) ->
      not row.type
  .get '/cryptoCurr', (ctx, next) ->
    symbol = ctx.request.body.id
    if not symbol
      throw 'parameter id not defined'
    {id} = await token symbol
    ctx.response.body = await ohlc id
