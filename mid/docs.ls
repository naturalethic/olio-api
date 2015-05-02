require! \inflection

# The path to retrieve documentation
olio.config.api.docs ?= '/'

api = require-dir \api

content = []
content.push "\n\# Rapsheet API"
content.push "***\n"
for aname, amod of api
  content.push "\#\#\# #{aname.to-upper-case!}\n"
  for name, definition of amod
    if name not in [ aname, inflection.pluralize(aname) ]
      name = "#aname/#name"
    content.push "\#\#\#\# /#name"
    content ++= definition.0.split('\n')
    content.push ''
    for pname, pvals of definition.1
      content.push "* #pname[#{keys pvals}]"
    content.push ''

docs = """
  <!DOCTYPE html>
  <html>
    <head>
      <title>Rapsheet</title>
    </head>
    <body>
      <xmp theme="cyborg" style="display:none">
        #{content.join '\n'}
      </xmp>
      <script src="http://strapdownjs.com/v/0.2/strapdown.js"></script>
    </body>
  </html>
  """

module.exports = (next) ->*
  if @url == olio.config.api.docs
    @response.body = yield documentation!
    @response.status = 200
    return
  yield next
