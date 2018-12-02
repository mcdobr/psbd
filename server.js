const oracledb = require('oracledb')
const express = require('express')
const config = require('./config.js');
const bodyParser = require('body-parser');
const app = express();
const database = require('./database/database.js');


// const bills = require('./bill');
const categories = require('./category/category.route');
// const historicQuantites = require('./historicQuantity');
// const product = require('./product');

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

            /*
            app.get('/', async (req, res) => {
                const result = await database.simpleExecute('select user, systimestamp from dual');
                const user = result.rows[0].USER;
                const date = result.rows[0].SYSTIMESTAMP;
            
                res.end(`${user}\n${date}`);
            }); */


            //app.use('/api/bills', bills);
            app.use('/api/categories', categories);
            //app.use('/api/historicquantities', historicQuantites);
            //app.use('/api/products', product);
        }
    }   
);


app.listen(config.port);