const router = require('express').Router();
const controller = require('./bill.controller.js');

router.route('/bills/:id?').get(controller.get);
router.route('/bills').post(controller.post);

module.exports = router;