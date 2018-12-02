const oracledb = require('oracledb')
const express = require('express')
const config = require('./config.js');
const app = express();

// const bills = require('./bill');
const categories = require('./category');
// const historicQuantites = require('./historicQuantity');
// const product = require('./product');

oracledb.createPool({})
oracledb.createPool(
    config.db,
    function (error, pool) {
        if (error) {
            console.error(error.message);
        } else {
            console.log('Connected to Oracle Database');
            console.log('Maximum pool listeners: ' + pool.getMaxListeners());

            //app.use('/api/bills', bills);
            app.use('/api/', categories(pool.getConnection()));
            //app.use('/api/historicquantities', historicQuantites);
            //app.use('/api/products', product);
        }
    }   
);


app.listen(config.port);