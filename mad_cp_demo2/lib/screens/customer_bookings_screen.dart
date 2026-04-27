import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart'; // or wherever UserSession is

const String baseUrl = "http://10.0.2.2:5000";

class CustomerBookingsScreen extends StatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  State<CustomerBookingsScreen> createState() =>
      _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState extends State<CustomerBookingsScreen> {
  List bookings = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final customerId = UserSession().currentUser!.id;

      print(UserSession().currentUser!.id); // ✅ DEBUG

      final response = await http.get(
        Uri.parse("$baseUrl/api/booking/customer/$customerId"),
      );

      print("Response: ${response.body}"); // ✅ DEBUG

      bookings = jsonDecode(response.body);

      setState(() {
        loading = false;
      });
    } catch (e) {
      print("ERROR: $e"); // ✅ DEBUG

      setState(() {
        loading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "accepted":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: bookings.isEmpty
          ? const Center(child: Text("No bookings yet"))
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (ctx, i) {
          final b = bookings[i];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(b["serviceType"]),
              subtitle: Text("₹${b["price"]}"),
              trailing: Text(
                b["status"],
                style: TextStyle(
                  color: getStatusColor(b["status"]),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}