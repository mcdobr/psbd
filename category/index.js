const express = require('express');

module.exports = function(connection) {
    const router = express.Router();

    router.get('/', (req, res) => {
        res.end('Got categories!');
    });

    router.get('/:id', (req, res) => {
        res.end('Got id: ' + req.params.id);
    });

    return router;
}