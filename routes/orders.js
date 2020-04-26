const express = require('express');
const orderRouter = express.Router();
const { clientQuery, handleError, getFields } = require('../db/driver');

orderRouter.route('/')
    .get((req, res, next) => { //get all products
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
                values: ['orders'],
            })
            .then(cres => {
                if (cres.rows && cres.rows.length && cres.rows[0].count) {
                    result.total = parseInt(cres.rows[0].count, 10);
                }

            const query = {
                text: 'SELECT * FROM get_orders($1, $2, $3, $4)',
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
    .put((req, res, next) => { // insert a product
        const body = req.body;
        const rowdata = {
            title: body.title || '',
            first: body.first_name || '',
            last: body.last_name || '',
            product_id: body.product_id || 0,
            number_shipped: body.number_shipped || 0,
            order_date: body.order_date || 0
        }

        if (Object.keys(rowdata).every(key => !!(rowdata[key]))) {            
            const query = {
                text: 'SELECT * FROM create_order($1, $2, $3, $4, $5, $6)',
                values: [rowdata.title, rowdata.first, rowdata.last, rowdata.product_id, 
                        rowdata.number_shipped, rowdata.order_date ]
            }
    
            clientQuery(query)
            .then((qres) => {
                handleError(res, qres, (response) => {
                    response.json(qres.rows[0]);
                });
            })
            .catch(err => next(err));
        } else {
            res.statusCode = 400;
            res.json({message: 'key missing'});
        }
    })
    .post((req, res, next) => {})
    .delete((req, res, next) => {});

orderRouter.route('/:order_id')
            .get((req, res, next) => { //retreive a product
                const oid = req.params.order_id

                const query = {
                        text: 'SELECT * FROM get_order($1)',
                        values: [oid]
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
            .post((req, res, next) => { // update a product
                const id = req.params.order_id;
                const body = req.body;
                const rowdata = {
                    id: id,
                    title: body.title || '',
                    first: body.first_name || '',
                    last: body.last_name || '',
                    product_id: body.product_id || 0,
                    number_shipped: body.number_shipped || 0,
                    order_date: body.order_date || 0
                }
                
                const query = {
                    text: 'SELECT * FROM update_order($1, $2, $3, $4, $5, $6, $7)',
                    values: [rowdata.id, rowdata.title, rowdata.first, rowdata.last, rowdata.product_id, rowdata.number_shipped, rowdata.order_date ]
                }
        
                clientQuery(query)
                .then((qres) => {
                    handleError(res, qres, (response) => {
                        response.json(qres.rows[0]);
                    });
                })
                .catch(err => next(err));
            })
            .delete((req, res, next) => { // delete a product
                const oid = req.params.order_id;

                const query = {
                    text: 'SELECT * FROM remove_order($1)',
                    values: [oid]
                }

                clientQuery(query)
                .then((qres) => {
                    handleError(res, qres, (response) => {
                        response.json(qres.rows[0]);
                    });
                })
                .catch(err => next(err));
            });

module.exports = orderRouter;