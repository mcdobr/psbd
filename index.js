let oracledb = require('oracledb')
let express = require('express')

const PORT_NO = 10000;
var app = express()
app.get('/', function(request, response){
    response.send('Hi there');
});
app.listen(PORT_NO);

oracledb.getConnection(
    {
        user: 'shop_admin',
        password: 'shop',
        connectString: 'localhost:1521/ORCLPDB1'
    },
    function(error, connection) {
        if (error) {
            console.error(error.message);
        } else {
            console.log('connected');
        }
    }
)