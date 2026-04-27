const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema({
  customerId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  mechanicId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  serviceType: String,
  price: Number,
  status: { type: String, default: "pending" }, // pending / accepted / rejected
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Booking", bookingSchema);