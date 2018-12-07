const database = require('../database/database');

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
    try {
        const context = {};
        context.id = parseInt(req.params.id, 10);

        const rows = await find(context);
        if (req.params.id) {
            if (rows.length === 1) {
                res.status(200).json(rows[0]);
            } else {
                res.status(404).end();
            }
        } else {
            res.status(200).json(rows);
        }
    } catch (error) {
        next(error);
    }
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