const oracledb = require('oracledb');

/* Intended for simple operations, no multi-step transactions */
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
                    console.log(error);
                }
            }
        }
    });
}

module.exports.simpleExecute = simpleExecute;