const express = require('express');
const router = express.Router();
const controller = require('./category.controller.js');

router.route('/categories/:id?').get(controller.get);

module.exports = router;