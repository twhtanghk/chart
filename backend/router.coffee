Router = require 'koa-router'
router = new Router()
{ohlc, indicators, breadth} = require 'analysis'

module.exports = router
  .get '/stock', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    ctx.response.body = await ohlc.stock id
  .get '/cryptoCurr', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    ctx.response.body = await ohlc.cryptoCurr id
  .get '/indicators', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    ctx.response.body = await indicators id
  .get '/breadth', (ctx, next) ->
    id = ctx.request.body.id
    if not id
      throw 'parameter id not defined'
    ret = {}
    for symbol in id
      ret[symbol] = await breadth symbol
    ctx.response.body = ret
