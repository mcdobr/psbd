const database = require('../database/database');
const oracledb = require('oracledb');

async function find(context) {
    const baseQuery = 
        `SELECT id, billdate, otherPartyName, billtype 
        FROM bill`;

    let query = baseQuery;
    const binds = {};
    if (context.id) {
        binds.id = context.id;
        query += `\nWHERE id = :id`;
    }

    query += `\nORDER BY billdate DESC`;

    const result = await database.simpleExecute(query, binds);
    return result.rows;
}

async function get(req, res, next) {
    database.get(find, req, res, next);
}


async function createNewBill() {

}

async function post(req, res, next) {
    const binds = {
        returnedBillId: {
            dir: oracledb.BIND_OUT,
            type: oracledb.NUMBER
        },
        billDate: {
            dir: oracledb.BIND_IN,
            type: oracledb.STRING,
            val: req.body.billDate
        },
        otherPartyName: {
            dir: oracledb.BIND_IN,
            type: oracledb.STRING,
            val: req.body.otherPartyName
        },
        billType: {
            dir: oracledb.BIND_IN,
            type: oracledb.STRING,
            val: req.body.billType
        }
    };

    let conn;
    try {
        conn = await oracledb.getConnection();
        let result = await conn.execute(`BEGIN :returnedBillId := new_bill(:billDate, :otherPartyName, :billType); END;`, binds);

        conn.commit();
        res.status(200).json(result);
    } catch (error) {
        console.error(error);
        res.status(400).end();
        next(error);
    } finally {
        if (conn) {
            try {
                await conn.close();
            } catch (error) {
                console.error(error);
            }
        }
    }
}
/**
 * Example requests for POST
 * {
	"billDate": "2018/08/05",
	"otherPartyName": "Mircea Dobreanu",
	"billType": "incoming",
	"billedItems": [
		{
			"productId": 1,
			"quantity": 10
		},
		{
			"productId": 2,
			"quantity": 5
		},
		{
			"productId": 3,
			"quantity": 2
		}
	]
}
 */

module.exports.get = get;
module.exports.post = post;