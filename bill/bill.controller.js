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
    console.log(req.body);


    try {
        const context = {};
        

    } catch (error) {
        next(error);
    }
}

module.exports.get = get;
module.exports.post = post;