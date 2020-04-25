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
    .put((req, res, next) => {
        const body = req.body;
        const rowdata = {
            product_name: body.name || '',
            part_number: body.part || '',
            product_label: body.label || '',
            starting_inventory: body.start_inv || 0,
            inventory_received: body.inv_rec || 0,
            inventory_shipped: body.inv_shipped || 0,
            minimum_required: body.min_req || 0
        }

        const query = {
            text: 'SELECT * FROM put_product($1, $2, $3, $4, $5, $6, $7)',
            values: [rowdata.product_name, rowdata.part_number, rowdata.product_label, rowdata.starting_inventory, 
                    rowdata.inventory_received, rowdata.inventory_shipped, rowdata.minimum_required ]
        }

        clientQuery(query)
        .then((qres) => {
            handleError(res, qres, (response) => {
                response.json(qres.rows[0]);
            });
        })
        .catch(err => next(err));
    })
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
                        response.json(qres.rows[0] || {message: 'not found'});
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
                const pid = req.params.product_id;

                const query = {
                    text: 'SELECT * FROM delete_product($1)',
                    values: [pid]
                }

                clientQuery(query)
                .then((qres) => {
                    handleError(res, qres, (response) => {
                        response.json(qres.rows[0]);
                    });
                })
                .catch(err => next(err));
            });

module.exports = productRouter;