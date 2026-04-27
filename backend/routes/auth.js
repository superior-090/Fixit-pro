const express = require("express");
const router = express.Router();
const User = require("../models/User");
const bcrypt = require("bcrypt");

// ================= REGISTER =================
router.post("/register", async (req, res) => {
  try {
    const { name, email, phone, password, role, serviceType, price } = req.body;

    const existing = await User.findOne({ email });
    if (existing) {
      return res.status(400).json({ msg: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = new User({
      name,
      email,
      phone,
      password: hashedPassword,
      role,
      serviceType,
      price,
    });

    await user.save();

    res.json({ msg: "Registered successfully" });

  } catch (err) {
    res.status(500).json({ msg: err.message });
  }
});

// ================= LOGIN =================
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: "User not found" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Invalid password" });
    }

    // ✅ SAFE RESPONSE (NO NULLS)
    res.json({
      id: user._id.toString(),
      name: user.name || "",
      email: user.email || "",
      phone: user.phone || "",
      role: user.role || "customer",
      serviceType: user.serviceType || "",
      price: user.price || 0,
    });

  } catch (err) {
    console.log(err); // for debugging
    res.status(500).json({ msg: "Server error" });
  }
});

module.exports = router;