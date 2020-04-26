const express = require('express');
const purchaseRouter = express.Router();
const { clientQuery, handleError, getFields } = require('../db/driver');

purchaseRouter.route('/')
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
                values: ['purchases'],
            })
            .then(cres => {
                if (cres.rows && cres.rows.length && cres.rows[0].count) {
                    result.total = parseInt(cres.rows[0].count, 10);
                }

            const query = {
                text: 'SELECT * FROM get_purchases($1, $2, $3, $4)',
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
            supplier_id: body.supplier_id || '',
            product_id: body.product_id || '',
            number_received: body.number_received || '',
            purchase_date: body.purchase_date || ''
        }

        if (Object.keys(rowdata).every(key => !!(rowdata[key]))) {            
            const query = {
                text: 'SELECT * FROM create_purchase($1, $2, $3, $4)',
                values: [rowdata.supplier_id, rowdata.product_id, rowdata.number_received, rowdata.purchase_date]
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

purchaseRouter.route('/:purchase_id')
            .get((req, res, next) => { //retreive a product
                const pid = req.params.purchase_id;

                const query = {
                        text: 'SELECT * FROM get_purchase($1)',
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
            .post((req, res, next) => { // update a product
                const id = req.params.purchase_id;
                const body = req.body;
                const rowdata = {
                    id: id,
                    supplier_id: body.supplier_id || '',
                    product_id: body.product_id || '',
                    number_received: body.number_received || '',
                    purchase_date: body.purchase_date || ''
                }
                
                const query = {
                    text: 'SELECT * FROM update_purchase($1, $2, $3, $4, $5)',
                    values: [rowdata.id, rowdata.supplier_id, rowdata.product_id, rowdata.number_received, rowdata.purchase_date]
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
                const pid = req.params.purchase_id;

                const query = {
                    text: 'SELECT * FROM remove_purchase($1)',
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

module.exports = purchaseRouter;