const fs = require('fs');
const oracledb = require('oracledb');
const config = require('./config');

oracledb.createPool(
    config.db,
    async (error, pool) => {
        if (error) {
            console.error(error.message);
            pool.close((error) => {
                if (error) {
                    console.error(error);
                }
            });
        } else {
            console.log('Cleanup script connected to Oracle Database');
            const cleanupScript = fs.readFileSync(__dirname + '/database/db_design/clean_script.sql', { encoding : 'utf-8' });

            try {
                conn = await oracledb.getConnection();
                await conn.execute(cleanupScript);
            } catch (error) {
                console.error(error);
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
    }
);


