const express = require('express');
const router = express.Router();
const controller = require('./category.controller.js');

router.get('/', async (req, res) => {
    const results = await controller.list();
    res.json(results);
});

router.get('/:id', async (req, res) => {
    const results = await controller.find(req.params.id);
    res.json(results);
});

module.exports = router;