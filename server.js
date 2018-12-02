let oracledb = require('oracledb')
let express = require('express')
let config = require('./config.js');


const PORT_NO = 10000;
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
            app.use('/api/categories', categories(pool.getConnection()));
            //app.use('/api/historicquantities', historicQuantites);
            //app.use('/api/products', product);
        }
    }   
);


app.listen(config.port);


/*
app.get('/', function (request, response) {
    response.send('Hi there');
});

oracledb.getConnection({
        user: 'shop_admin',
        password: 'shop',
        connectString: 'localhost:1521/ORCLPDB1'
    },
    function (error, connection) {
        if (error) {
            console.error(error.message);
        } else {
            console.log('Connected to Oracle Database');
            connection.execute(
                `SELECT *
                FROM category
                WHERE id = :id`, [2],
                (error, result) => {
                    if (error) {
                        console.error(error.message);
                        releaseConnection(connection);
                        return;
                    } else {
                        console.log(result.rows);
                        console.log(typeof result);
                        console.log(typeof result.rows);
                        releaseConnection(connection);
                    }
                }
            )
        }
    }
)*/