const database = require('../database/database');
const oracledb = require('oracledb');
const moment = require('moment');

async function find(context) {
    const baseQuery =
        `SELECT id, bill_date, other_party_name, bill_type 
        FROM bill`;

    let query = baseQuery;
    const binds = {};
    if (context.id) {
        binds.id = context.id;
        query += `\nWHERE id = :id`;
    }

    query += `\nORDER BY bill_date DESC`;

    const billsResult = await database.simpleExecute(query, binds);

    const itemsOfBillQuery =
        `SELECT billItem.id, billItem.quantity, billItem.product_id, product.name
        FROM billItem
        INNER JOIN product ON billItem.product_id = product.id
        WHERE billItem.bill_id = :bill_id`;

    for (let bill of billsResult.rows) {
        const itemsResult = await database.simpleExecute(itemsOfBillQuery, { bill_id: bill.ID });
        bill.items = itemsResult.rows;
    }

    return billsResult.rows;
}

async function get(req, res, next) {
    database.get(find, req, res, next);
}

async function createNewBill(req, res, next) {
    const formattedBillDate = moment(req.body.billDate).format('YYYY/MM/DD hh:mm:ss');

    const billBinds = {
        returnedBillId: {
            dir: oracledb.BIND_OUT,
            type: oracledb.NUMBER
        },
        billDate: {
            dir: oracledb.BIND_IN,
            type: oracledb.STRING,
            val: formattedBillDate
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
        let result = await conn.execute(`BEGIN :returnedBillId := new_bill(:billDate, :otherPartyName, :billType); END;`, billBinds);

        let billId = result.outBinds.returnedBillId;
        for (const billedItem of req.body.billedItems) {
            const billedItemBinds = {
                billId: billId,
                productId: billedItem.productId,
                quantity: billedItem.quantity
            };
            await conn.execute(`BEGIN new_bill_item(:billId, :productId, :quantity); END;`, billedItemBinds);
        }

        await conn.commit();
        res.status(201).json(result);
    } catch (error) {
        console.error(error);
        conn.rollback();
        res.status(400).end(database.getHumanReadableErrorMessage(error));
        next(error);
    } finally {
        database.tryToCloseConnection(conn);
    }
}

async function editBill(req, res, next) {
    const formattedBillDate = moment(req.body.billDate).format('YYYY/MM/DD hh:mm:ss');

    req.params.id = parseInt(req.params.id, 10);
    const editBinds = {
        billId: {
            dir: oracledb.BIND_IN,
            type: oracledb.NUMBER,
            val: req.params.id
        },
        billDate: {
            dir: oracledb.BIND_IN,
            type: oracledb.STRING,
            val: formattedBillDate
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

        await conn.execute(`BEGIN edit_bill(:billId, :billDate, :otherPartyName, :billType); END;`, editBinds);
        await conn.execute(`BEGIN delete_bill_items(:billId); END;`, { billId: req.params.id });

        for (const billedItem of req.body.billedItems) {
            const billedItemBinds = {
                billId: req.params.id,
                productId: billedItem.productId,
                quantity: billedItem.quantity
            };
            await conn.execute(`BEGIN new_bill_item(:billId, :productId, :quantity); END;`, billedItemBinds);
        }
        await conn.commit();
        res.status(204).end();
    } catch (error) {
        console.error(error);
        conn.rollback();
        res.status(400).end(database.getHumanReadableErrorMessage(error));
        next(error);
    } finally {
        database.tryToCloseConnection(conn);
    }
}

module.exports.get = get;
module.exports.post = createNewBill;
module.exports.put = editBill;