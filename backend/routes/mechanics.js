const express = require("express");
const router = express.Router();
const User = require("../models/User");

// GET ALL MECHANICS
router.get("/", async (req, res) => {
  try {
    const mechanics = await User.find({ role: "mechanic" });

    res.json(mechanics);
  } catch (err) {
    res.status(500).json({ msg: err.message });
  }
});

module.exports = router;