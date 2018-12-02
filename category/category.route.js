const express = require('express');
const router = express.Router();
const oracledb = require('oracledb');
const controller = require('./category.controller');

router.get('/', (req, res) => {
    oracledb.getConnection((error, connection) => {
        if (error) {
            console.error(error);
        } else {
            connection.execute(
                `SELECT * FROM category`, 
                (error, result) => {
                    if (error) {
                        console.error(error);
                    } else {
                        res.json(result);
                    }
                }
            );
        }
    });
});

router.get('/:id', (req, res) => {
    
    oracledb.getConnection((error, connection) => {
        if (error) {
            console.error(error);
        } else {
            connection.execute(
                `SELECT * FROM category
                WHERE id = :id`, [req.params.id],
                (error, result) => {
                    if (error)
                        console.error(error);
                    else
                        res.json(result);
                }
            )
        }
    });
});

module.exports = router;