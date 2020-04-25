const express = require('express');
const productRouter = express.Router();
const { clientQuery, handleError, getFields } = require('../db/driver');

productRouter.route('/')
    .get((req, res, next) => {
        if (req.body) {
            const limit = req.body.limit || 10;
            const page = req.body.page || 1;
            const sort_by = req.body.sort_by || null;
            const direction = req.body.direction || null;

            const result = {
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
                    result.total = parseInt(cres.rows[0].count, 10);
                }

            const query = {
                text: 'SELECT * FROM get_products($1, $2, $3, $4)',
                values: [limit, page, sort_by, direction],
                rowMode: 'array',
              }
            
               return clientQuery(query);
            })
            .then(qres => {
                handleError(res, qres, (response) => {
                    const fields = getFields(qres.fields);
                    result.rows = qres.rows;
                    result.resultCount =  qres.rows ? qres.rows.length : 0;
                    result.fields = fields;
                    res.json(result);
                });
            })
            .catch(err => next(err));
        }
    })
    .put((req, res, next) => {})
    .post((req, res, next) => {})
    .delete((req, res, next) => {});

productRouter.route('/:product_id')
            .get((req, res, next) => {
                const pid = req.params.product_id

                const query = {
                        text: 'SELECT * FROM get_product($1)',
                        values: [pid]
                    }

                    clientQuery(query)
                    .then((qres) => {
                        handleError(res, qres, (response) => {
                            response.json(qres.rows[0]);
                        });
                    })
                    .catch(err => next(err));
            })
            .put((req, res, next) => {
                res.json({
                    message: 'coming soon'
                });
            })
            .post((req, res, next) => {
                res.json({
                    message: 'coming soon'
                });
            })
            .delete((req, res, next) => {
                res.json({
                    message: 'coming soon'
                });
            });

module.exports = productRouter;