const oracledb = require('oracledb');
const express = require('express');
const config = require('./config.js');
const bodyParser = require('body-parser');
const mung = require('express-mung');
const app = express();
const bills = require('./bill');
const category = require('./category/category.route');
const product = require('./product');

app.use(bodyParser.json({

}));

oracledb.createPool(
    config.db,
    (error, pool) => {
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
        }
    }   
);

function redactJsonResponse(body, req, res) {
    const camelCaseKeys = require('camelcase-keys');
    return camelCaseKeys(body, {deep: true});
}

app.use(mung.json(redactJsonResponse));

app.listen(config.port);
