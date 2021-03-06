var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
const session = require('express-session');
const filestore = require('session-file-store')(session);
const passport = require('passport');
const authenticate = require('./authenticate');

/**
 * initialise the db connection
 */
const connection = require('./config/connection.json');
const { initConnection, clientQuery } = require('./db/driver');
initConnection(connection)
  .then(res => console.log('client connected to DB'))
  .catch(err => { throw 'Database connection error: ', err; });

const secret = '0123456789-0987-6543-210';

const indexRouter = require('./routes/index');
const { userRouter, saltHashPassword } = require('./routes/users');
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
app.use(cookieParser(secret));
app.use(express.static(path.join(__dirname, 'public')));

app.use(session({
  name: 'session-id',
  secret: secret,
  saveUninitialized: false,
  resave: false,
  store: new filestore()
}));

// basic authorization
const auth = function(req, res, next) {
  const user = req ? req.user : null;
  if (user) {
    next();
  } else { // authenticate the user using basic method
    const error = new Error('No authorization provided');
    error.status = 401;
    next(error);
  }
}

app.use(passport.initialize());
app.use(passport.session());

app.use('/', indexRouter);
app.use('/users', userRouter);

// protected routes
app.use(auth);
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
