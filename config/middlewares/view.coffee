
###
Pagination helper

@param {Number} pages
@param {Number} page
@return {String}
@api private
###
createPagination = (req) ->
  createPagination = (pages, page) ->
    url = require("url")
    qs = require("querystring")
    params = qs.parse(url.parse(req.url).query)
    str = ""
    params.page = 0
    clas = (if page is 0 then "active" else "no")
    str += "<li class=\"" + clas + "\"><a href=\"?" + qs.stringify(params) + "\">First</a></li>"
    p = 1

    while p < pages
      params.page = p
      clas = (if page is p then "active" else "no")
      str += "<li class=\"" + clas + "\"><a href=\"?" + qs.stringify(params) + "\">" + p + "</a></li>"
      p++
    params.page = --p
    clas = (if page is params.page then "active" else "no")
    str += "<li class=\"" + clas + "\"><a href=\"?" + qs.stringify(params) + "\">Last</a></li>"
    str

###
Format date helper

@param {Date} date
@return {String}
@api private
###
formatDate = (date) ->
  monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
  monthNames[date.getMonth()] + " " + date.getDate() + ", " + date.getFullYear()

###
Strip script tags

@param {String} str
@return {String}
@api private
###
stripScript = (str) ->
  str.replace /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/g, ""

module.exports = (app) ->
  (req, res, next) ->
    res.locals.appName = app.get('app').name
    res.locals.title = app.get('title')
    res.locals.req = req
    res.locals.isActive = (link) ->
      (if req.url is link then "active" else "")

    res.locals.formatDate = formatDate
    res.locals.stripScript = stripScript
    res.locals.createPagination = createPagination(req)
    next()
    return
