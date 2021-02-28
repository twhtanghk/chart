_ = require 'lodash'
moment = require 'moment'
{PublicClient} = require 'coinbase-pro'
client = new PublicClient()
Router = require 'koa-router'
router = new Router()
{ohlc, indicators} = require 'analysis'
{Sector} = require 'yahoo-stock'

module.exports = router
  .get '/stock', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    ctx.response.body = await ohlc.stock id
  .get '/cryptoCurr', (ctx, next) ->
    {id, granularity} = _.defaults ctx.request.body, granularity: 60
    if not id?
      throw 'parameter id not defined'
    ctx.response.body = for [time, low, high, open, close, volume] in await client.getProductHistoricRates id, {granularity}
      date: time
      low: low
      high: high
      open: open
      close: close
  .get '/indicators', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    ctx.response.body = await indicators id
  .get '/breadth', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    sector = new Sector await Sector.constituent id
    ctx.response.body = await sector.breadth()
