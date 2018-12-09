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
    try {
        const context = {};
        context.id = parseInt(req.params.id, 10);
        context.categoryId = parseInt(req.query.categoryId, 10);

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

module.exports.get = get;