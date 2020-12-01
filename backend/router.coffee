Router = require 'koa-router'
router = new Router()
{ohlc, indicators} = require 'analysis'

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
