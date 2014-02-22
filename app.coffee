express = require('express')
http = require('http')
path = require('path')

app = express();

require('./routes/index')(app)

# all environments
app.set('port', process.env.PORT || 3000)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.favicon())
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(app.router)
app.use(require('stylus').middleware(__dirname + '/public'))
app.use(express.static(path.join(__dirname, 'public')))

# development only
if 'development' == app.get('env')
  app.use(express.logger('dev'))
  app.use(express.errorHandler())
  app.use(require('coffee-middleware')(
    src: __dirname + '/public'
  ))

# production only
if 'production' == app.get('production')
  console.log "Booting in production mode."

  app.use(express.logger('default'))
  app.use(require('coffee-middleware')(
    src: __dirname + '/public'
    compress: true
    once: true
  ))

http.createServer(app).listen app.get('port'), ->
  console.log('Express server listening on port ' + app.get('port'))
