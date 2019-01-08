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
            console.log('Startup script connected to Oracle Database');
            await executeScripts();
        }
    }
);


async function executeScripts() {
    const tableCreationScript = fs.readFileSync(__dirname + '/database/db_design/db_script.ddl', { encoding : 'utf-8' });
    const storedProceduresScript = fs.readFileSync(__dirname + '/database/db_design/stored_procedures.sql', { encoding : 'utf-8' });
    const populateScript = fs.readFileSync(__dirname + '/database/db_design/populate_script.sql', { encoding : 'utf-8' });

    try {
        conn = await oracledb.getConnection();
        
        console.log('Creation of tables');
        await executeMultipleDDL(conn, tableCreationScript, ';');
        console.log('Creation of tables successful');


        console.log('Population of tables');
        await executeMultipleDDL(conn, populateScript, ';');
        console.log('Population of tables successful');

        console.log('Compilation of stored objects');
        await executeMultipleDDL(conn, storedProceduresScript, /\/(\s|$)/g);
        console.log('Compilation of stored objects successful');

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

async function executeMultipleDDL(conn, script, separator) {
    for (let ddlStatement of script.split(separator)) {
        try {
            ddlStatement = removeOneLineComments(ddlStatement);
            if (ddlStatement.trim()) {
                const statementInfo = await conn.getStatementInfo(ddlStatement);
                await conn.execute(ddlStatement);
            }
        } catch (error) {
            if (error.errorNum === 2275)
                console.log('Ignored error ', error);
            else {
                console.error('Error thrown on statement: ', ddlStatement);
                throw error;
            }
        }
    }
}

function removeOneLineComments(statement) {
    return statement.replace(/--.*\r?\n/g, '').trim();
}