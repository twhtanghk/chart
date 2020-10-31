Router = require 'koa-router'
router = new Router()

module.exports = router
  .get '/:code', (ctx, next) ->
    ctx.response.body = 'a'
