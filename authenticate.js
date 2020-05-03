const passport = require('passport');
const localStrategy = require('passport-local').Strategy;
// const Users = require('./models/users');

const verifyFunction = () => {

}

exports.local = passport.use(new localStrategy(verifyFunction()));

passport.serializeUser(/** serialise user */);
passport.deserializeUser(/** deserialise user */);