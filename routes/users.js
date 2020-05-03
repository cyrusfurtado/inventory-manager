var express = require('express');
const crypto = require('crypto');
var userRouter = express.Router();
const { clientQuery, handleError, getFields } = require('../db/driver');
const passport = require('passport');

const genSalt = function(length) {
  return crypto.randomBytes(Math.round(length / 2)).toString('hex').slice(0, length);
};

const genSha512Hash = function(password, salt) {
  const hash = crypto.createHmac('sha512', salt);
  hash.update(password);
  const value = hash.digest('hex');
  return {
    passwordHash: value,
    salt: salt
  }
};

const userValidatonCallback = (credentials, queryresponse, request, response, next) => {
  return () => {
    const userdata = queryresponse.rows[0];
    if (userdata) {
      const result = saltHashPassword(credentials.password, userdata.salt)
  
      if (result.passwordHash === userdata.hash) {
        request.session.user = userdata.user_name;
        response.json({
          id: userdata.id,
          user: userdata.user_name
        });
      } else {
        const error = new Error('Invalid password');
        error.status = 401;
        next(error);
      }
    } else {
      const error = new Error('User does not exist');
      error.status = 401;
      next(error);
    }
  }
};

const saltHashPassword = function(password, salt) {
  if (salt) {
    return genSha512Hash(password, salt);
  } else {
    const geenrateSalt = genSalt(16);
    return genSha512Hash(password, geenrateSalt);
  }
};

/* GET users listing. */
userRouter.route('/login')
        .get(passport.authenticate('local'), (req, res, next) => {
          // const credentials = { 
          //   username: req.body.username,
          //   email: req.body.email,
          //   password: req.body.password
          // };

          // if (credentials.username) {
          //   clientQuery({
          //     text: 'SELECT * FROM get_user($1)',
          //     values: [credentials.username]
          //   }).then(qres => {
          //     handleError(res, qres, userValidatonCallback(credentials, qres, req, res, next));
          //   }).catch(err => next(err));
          // } else if (credentials.email) {
          //   clientQuery({
          //     text: 'SELECT * FROM get_user(\'\', $1)',
          //     values: [credentials.email]
          //   }).then(qres => {
          //     handleError(res, qres, userValidatonCallback(credentials, qres, req, res, next));
          //   }).catch(err => next(err));
          // } else {
          //   const err = new Error('username / email missing');
          //   err.status = 400;
          //   next(err);
          // }
        });

        
userRouter.route('/signup')
          .get((req, res, next) => {
            const userdata = {
              username: req.body.username,
              email: req.body.email,
              first_name: req.body.first_name,
              last_name: req.body.last_name,
              password: req.body.password || '',
              account_type: req.body.account_type,
              address: req.body.address,
              contact: req.body.contact
            };

            // passport.authenticate('local')(req, res, () => {});
            const passResult = saltHashPassword(userdata.password);
            clientQuery({
              text: 'SELECT * FROM create_user($1, $2, $3, $4, $5, $6, $7, $8, $9)',
              values: [userdata.username, userdata.email, userdata.first_name, userdata.last_name, passResult.passwordHash, passResult.salt, userdata.account_type, userdata.address, userdata.contact]
            }).then(qres => handleError(res, qres, () => {
              res.json(qres.rows[0]);
            }))
            .catch(err => next(err));
          });

userRouter.get('/logout', (req, res, next) => {
  req.session.destroy();
  res.clearCookie('session-id');
  res.statusCode = 200;
  res.json({
    message: 'signed out'
  })
})

exports.userRouter = userRouter;

exports.saltHashPassword = saltHashPassword;