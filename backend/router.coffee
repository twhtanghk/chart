Router = require 'koa-router'
router = new Router()
{ohlc, indicators} = require 'analysis'
{Sector} = require 'yahoo-stock'

module.exports = router
  .get '/stock', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    ctx.response.body = for row in await ohlc.stock id
      row.date = row.date * 1000
      row
  .get '/cryptoCurr', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    ctx.response.body = for row in await ohlc.cryptoCurr id
      row.date = row.date * 1000
      row
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
