const database = require('../database/database');

async function find(context) {
    const baseQuery = 
        `SELECT id, name, unit, price, category_id
        FROM product`;

    let query = baseQuery;
    const binds = {};
    if (context.id) {
        binds.id = context.id;
        query += `\nWHERE id = :id`;
    } else if (context.categoryId) {
        binds.categoryId = context.categoryId;
        query += `\nWHERE category_id = :categoryId`;
    }

    const result = await database.simpleExecute(query, binds);
    return result.rows;
}

async function get(req, res, next) {
    database.get(find, req, res, next);
}

module.exports.get = get;