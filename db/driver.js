const { Client } = require('pg');

var connectionResponse = null;
var client = null;

exports.connection = connectionResponse;

exports.initConnection = async function(connection) {
    try {
        client = new Client(connection);
        connectionResponse = await client.connect();
        return connectionResponse;
    }
    catch(err) {
        throw err.stack;
    }
}

exports.endConnection = async function() {
    try {
        await client.end();
        return res;
    }
    catch(err) {
        return err;
    }
}

exports.clientQuery = async function(query) {
    try {
        const res = await client.query(query);
        return res;
    }
    catch (err) {
        return err;
    }
}

exports.handleError = (response, queryresponse, successCB) => {
    try {
        if (queryresponse.rows && queryresponse.rows.length !== undefined) {
            response.statusCode = 200;
            response.setHeader('Content-Type', 'application/json');
            successCB(response);
        } else {
            response.statusCode = 500;
            response.json({error: queryresponse});
        }
    } catch(error) {
        response.statusCode = 500;
        response.json({error: error.stack});
    }
}

exports.getFields = function(fields) {
    return fieldkeys = fields ? fields.map(field => field.name) : [];
}