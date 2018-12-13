/** Module with simple operations that are repeated over multiple tables */
const oracledb = require('oracledb');


/**
 * Intended for simple operations, no multi-step transactions
 * @param {*} statement 
 * @param {*} binds 
 * @param {*} opts 
 */
function simpleExecute(statement, binds = [], opts = {}) {
    return new Promise(async (resolve, reject) => {
        let conn;

        opts.outFormat = oracledb.OBJECT;
        opts.autoCommit = true;

        try {
            conn = await oracledb.getConnection();
            const result = await conn.execute(statement, binds, opts);
            resolve(result);
        } catch (error) {
            reject(error);
        } finally {
            if (conn) {
                try {
                    await conn.close();
                } catch (error) {
                    console.error(error);
                }
            }
        }
    });
}

/**
 * 
 * @param {*} find A function that returns the rows of a select
 * @param {*} req 
 * @param {*} res 
 * @param {*} next 
 */
async function get(find, req, res, next) {
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

module.exports.simpleExecute = simpleExecute;
module.exports.get = get;