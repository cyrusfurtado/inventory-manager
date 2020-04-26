const express = require('express');
const supplierRouter = express.Router();
const { clientQuery, handleError, getFields } = require('../db/driver');

supplierRouter.route('/')
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
                values: ['suppliers'],
            })
            .then(cres => {
                if (cres.rows && cres.rows.length && cres.rows[0].count) {
                    result.total = parseInt(cres.rows[0].count, 10);
                }

            const query = {
                text: 'SELECT * FROM get_suppliers($1, $2, $3, $4)',
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
            supplier: body.supplier || ''
        }

        if (Object.keys(rowdata).every(key => !!(rowdata[key]))) {            
            const query = {
                text: 'SELECT * FROM create_supplier($1)',
                values: [rowdata.supplier]
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

supplierRouter.route('/:supplier_id')
            .get((req, res, next) => { //retreive a product
                const sid = req.params.supplier_id;

                const query = {
                        text: 'SELECT * FROM get_supplier($1)',
                        values: [sid]
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
                const id = req.params.supplier_id;
                const body = req.body;
                const rowdata = {
                    id: id,
                    supplier: body.supplier || ''
                }
                
                const query = {
                    text: 'SELECT * FROM update_supplier($1, $2)',
                    values: [rowdata.id, rowdata.supplier]
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
                const sid = req.params.supplier_id;

                const query = {
                    text: 'SELECT * FROM remove_supplier($1)',
                    values: [sid]
                }

                clientQuery(query)
                .then((qres) => {
                    handleError(res, qres, (response) => {
                        response.json(qres.rows[0]);
                    });
                })
                .catch(err => next(err));
            });

module.exports = supplierRouter;