var express = require('express');
const crypto = require('crypto');
var userRouter = express.Router();
const { clientQuery, handleError, getFields } = require('../db/driver');

const genSalt = function(length) {
  return crypto.randomBytes(Math.round(length / 2)).toString('hex').slice(0, length);
}

const genSha512Hash = function(password, salt) {
  const hash = crypto.createHmac('sha512', salt);
  hash.update(password);
  const value = hash.digest('hex');
  return {
    passwordHash: value,
    salt: salt
  }
}

const saltHashPassword = function(password, salt) {
  if (salt) {
    return genSha512Hash(password, salt);
  } else {
    const geenrateSalt = genSalt(16);
    return genSha512Hash(password, geenrateSalt);
  }
}

/* GET users listing. */
userRouter.route('/login')
        .get((req, res, next) => {
          const password = req.body.password;
          if (password) {
            res.setHeader('Content-Type', 'application/json');
            const salt = req.body.salt;

            if(salt) {
              res.json({
                result: saltHashPassword(password, salt)
              })
            } else {
              res.json({
                result: saltHashPassword(password)
              })
            }
          } else {
            handleError(res, null, () => {})
          }
        });

        
userRouter.route('/signup')
          .get((req, res, next) => {});

module.exports = userRouter;
