const express = require("express");
const router = express.Router();

// define endpoints herer
router.use("/query_spot", require("./querySpot.js"));
// router.use("/notify_trip", require("./notifyTrip.js"));
// router.use("/login", require("./login.js"));
// router.use("/info", require("/info.js"))

module.exports = router;