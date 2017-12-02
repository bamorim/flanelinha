const express = require('express');
const router = new express.Router();
const querySpot = require('../handlers/querySpot.js');

router.route('/').get(querySpot.getNearest);

module.exports = router;
