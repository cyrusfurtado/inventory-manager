const express = require('express');
const productRouter = express.Router();
const { clientQuery } = require('../db/driver');

productRouter.route('/')
    .get((req, res, next) => {
        if (req.body) {
            const limit = req.body.limit || 10;
            const page = req.body.page || 1;
            const sort_by = req.body.sort_by || null;
            const direction = req.body.direction || null;

            const response = {
                total: 0,
                resultCount: 0,
                page: req.body.page || 1,
                rows: []
            };
            clientQuery({
                text: 'SELECT * FROM get_count($1)',
                values: ['products'],
            })
            .then(cres => {
                if (cres.rows && cres.rows.length && cres.rows[0].count) {
                    response.total = parseInt(cres.rows[0].count, 10);
                }

            const query = {
                text: 'SELECT * FROM get_products($1, $2, $3, $4)',
                values: [limit, page, sort_by, direction],
                rowMode: 'array',
              }
            
               return clientQuery(query);
            })
            .then(qres => {
                res.statusCode = 200;
                res.setHeader('Content-Type', 'application/json');
                const fields = qres.fields ? qres.fields.map(field => field.name) : [];
                response.rows = qres.rows;
                response.resultCount =  qres.rows ? qres.rows.length : 0;
                response.fields = fields;
                res.json(response);
            })
            .catch(err => next(err));
        }
    })
    .put((req, res, next) => {})
    .post((req, res, next) => {})
    .delete((req, res, next) => {});

productRouter.route('/:product')
            .get((req, res, next) => {})
            .put((req, res, next) => {})
            .post((req, res, next) => {})
            .delete((req, res, next) => {});

module.exports = productRouter;