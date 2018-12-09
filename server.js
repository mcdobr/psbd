const oracledb = require('oracledb');
const express = require('express');
const config = require('./config.js');
const bodyParser = require('body-parser');
const app = express();
const database = require('./database/database.js');


const bills = require('./bill');
const category = require('./category/category.route');
// const historicQuantites = require('./historicQuantity');
const product = require('./product');

app.use(bodyParser.json({

}));
oracledb.createPool(
    config.db,
    function (error, pool) {
        if (error) {
            console.error(error.message);
            pool.close((error) => {
                if (error) {
                    console.error(error);
                }
            });
        } else {
            console.log('Connected to Oracle Database');
            console.log('Maximum pool listeners: ' + pool.getMaxListeners());


            app.use('/api', category, product, bills);

            //app.use('/api/historicquantities', historicQuantites);
        }
    }   
);

app.listen(config.port);