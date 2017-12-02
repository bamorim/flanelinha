const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const router = require("./routes/router.js");

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.use("/", router);

app.listen(9090);