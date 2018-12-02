const express = require('express');
const router = express.Router();
const controller = require('./product.controller.js');

router.route('/products/:id?').get(controller.get);

module.exports = router;