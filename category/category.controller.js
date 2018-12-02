const database = require('../database/database');

function list() {
    return database.simpleExecute(`SELECT * FROM category`);
}

function find(id) {
    return database.simpleExecute(`SELECT * FROM category WHERE id = :id`, [id]);
}

module.exports.list = list;
module.exports.find = find;