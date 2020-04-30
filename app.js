var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

/**
 * initialise the db connection
 */
const connection = require('./config/connection.json');
const { initConnection } = require('./db/driver');
initConnection(connection)
  .then(res => console.log('client connected to DB'))
  .catch(err => { throw 'Database connection error: ', err; });

const cookieSecret = '0123456789-0987-6543-210';
const defaultUser = {
  username: 'admin',
  password: 'password'
}

const indexRouter = require('./routes/index');
const usersRouter = require('./routes/users');
const productRouter = require('./routes/products');
const orderRouter = require('./routes/orders');
const supplierRouter = require('./routes/suppliers');
const purchaseRouter = require('./routes/purchases');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser(cookieSecret));
app.use(express.static(path.join(__dirname, 'public')));

// basic authorization
const auth = function(req, res, next) {
  const cookieUser = req.signedCookies ? req.signedCookies.user : null;
  if (cookieUser) {
    if (cookieUser === defaultUser.username) {
      next();
    } else {
      const err = new Error('Forbidden');
      err.status = 403;
      next(err);
    }
  } else { // authenticate the user using basic method
    const authorization = req.headers.authorization;
    if(authorization) {
      try {
        const auth = new Buffer.from(authorization.split(' ')[1], 'base64').toString().split(':');
  
        const user = auth[0];
        const pass = auth[1];
    
        if( user === defaultUser.username && pass === defaultUser.password ) {
          res.cookie('user', defaultUser.username, { signed: true });
          next();
        } else {
          const err = new Error('Forbidden');
          err.status = 403;
          next(err);
        }
      } catch(e) {
        next(e);
      }
    } else {
      res.setHeader('WWW-Authenticate', 'Basic');
      const error = new Error('No authorization provided');
      error.status = 401;
      next(error);
    }
  }
}

app.use(auth);

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/products', productRouter);
app.use('/orders', orderRouter);
app.use('/suppliers', supplierRouter);
app.use('/purchases', purchaseRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
