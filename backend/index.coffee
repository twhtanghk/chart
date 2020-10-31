Koa = require 'koa'
logger = require 'koa-logger'
bodyParser = require 'koa-bodyparser'
router = require './router'

app = new Koa()
app
  .use (ctx, next) ->
    try
      await next()
    catch err
      ctx.status = err.status || 500
      ctx.body = err.message
      ctx.app.emit 'error', err, ctx
  .use logger()
  .use require 'koa-404-handler'
  .use bodyParser()
  .use router.routes()
  .listen parseInt(process.env.PORT) || 3000
  .on 'error', console.error
