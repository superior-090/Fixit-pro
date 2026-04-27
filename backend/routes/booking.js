const express = require("express");
const router = express.Router();
const Booking = require("../models/Booking");

// CREATE BOOKING
router.post("/", async (req, res) => {
  try {
    const { customerId, mechanicId, serviceType, price } = req.body;

    const booking = new Booking({
      customerId,
      mechanicId,
      serviceType,
      price,
    });

    await booking.save();

    res.json({ msg: "Booking created" });
  } catch (err) {
    res.status(500).json({ msg: err.message });
  }
});

// GET BOOKINGS FOR A MECHANIC
router.get("/mechanic/:id", async (req, res) => {
  try {
    const bookings = await Booking.find({
      mechanicId: req.params.id,
    }).sort({ createdAt: -1 });

    res.json(bookings);
  } catch (err) {
    res.status(500).json({ msg: err.message });
  }
});
// UPDATE BOOKING STATUS
router.put("/:id", async (req, res) => {
  try {
    const { status } = req.body;

    const booking = await Booking.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true }
    );

    res.json(booking);
  } catch (err) {
    res.status(500).json({ msg: err.message });
  }
});

// GET BOOKINGS FOR CUSTOMER
router.get("/customer/:id", async (req, res) => {
  try {
    const bookings = await Booking.find({
      customerId: req.params.id,
    }).sort({ createdAt: -1 });

    res.json(bookings);
  } catch (err) {
    res.status(500).json({ msg: err.message });
  }
});

module.exports = router;