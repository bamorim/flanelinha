let querySpot = {}

querySpot.getNearest = (req, res) => {
    const msg = {message: "Come to me!"}
    res.json(msg)

}

module.exports = querySpot