import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://10.0.2.2:5000"; // emulator

// ================== CREATE BOOKING ==================
Future<void> createBooking(Map<String, dynamic> data) async {
  final res = await http.post(
    Uri.parse("$baseUrl/api/bookings"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data),
  );

  print("CREATE BOOKING: ${res.body}");
}

// ================== CUSTOMER BOOKINGS ==================
Future<List<dynamic>> getCustomerBookings(String userId) async {
  final res = await http.get(
    Uri.parse("$baseUrl/api/bookings/customer/$userId"),
  );

  return jsonDecode(res.body);
}

// ================== MECHANIC BOOKINGS ==================
Future<List<dynamic>> getMechanicBookings(String mechanicId) async {
  final res = await http.get(
    Uri.parse("$baseUrl/api/bookings/mechanic/$mechanicId"),
  );

  return jsonDecode(res.body);
}

// ================== UPDATE STATUS ==================
Future<void> updateBookingStatus(String id, String status) async {
  await http.put(
    Uri.parse("$baseUrl/api/bookings/$id"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"status": status}),
  );
}