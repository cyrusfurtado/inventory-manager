const passport = require('passport');
const localStrategy = require('passport-local').Strategy;
const { clientQuery } = require('./db/driver');
const { userValidatonCallback } = require('./routes/users');

const verifyFunction = (request, username, password, done) => {
    console.log('verify function', username, password);
        const credentials = { 
          username: username,
        //   email: req.body.email,
          password: password
        };    

        if (credentials.username) {
            clientQuery({
                text: 'SELECT * FROM get_user($1)',
                values: [credentials.username]
            }).then(qres => {
                if (qres && qres.rows && qres.rows.length) {
                    userValidatonCallback(credentials, qres, done)();
                } else {
                    done(new Error('user not found'), false);
                }
            }).catch(err => done(err, false));
        }
        // else if (credentials.email) {
        //     clientQuery({
        //         text: 'SELECT * FROM get_user(\'\', $1)',
        //         values: [credentials.email]
        //     }).then(qres => {
        //         handleError(res, qres, userValidatonCallback(credentials, qres, req, res, next));
        //     }).catch(err => next(err));
        // } 
        else {
            const err = new Error('username / email missing');
            err.status = 400;
            done(err, false);
        }
}

exports.local = passport.use(new localStrategy({
                                                passReqToCallback: true,
                                                session: true}, verifyFunction));

passport.serializeUser(function(user, done) {
    console.log('serialise user: ', user.user_name);
    done(null, user.user_name);
});
passport.deserializeUser(function(user_name, done) {
    console.log('deserialise user: ', user_name);
    clientQuery({
        text: 'SELECT * FROM get_user($1)',
        values: [user_name]
    }).then(qres => {
        if (qres && qres.rows && qres.rows.length) {
            done(null, qres.rows[0]);
        } else {
            done(new Error('user not found'), false);
        }
    }).catch(err => done(err, false));
});