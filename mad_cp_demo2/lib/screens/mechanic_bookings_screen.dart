import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mechanic_bookings_screen.dart';

// adjust import if your UserSession is elsewhere
import '../main2.dart';

const String baseUrl = "http://10.0.2.2:5000"; // change if using real device

class MechanicBookingsScreen extends StatefulWidget {
  const MechanicBookingsScreen({super.key});

  @override
  State<MechanicBookingsScreen> createState() =>
      _MechanicBookingsScreenState();
}

class _MechanicBookingsScreenState extends State<MechanicBookingsScreen> {
  List bookings = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final mechanicId = UserSession().currentUser!.id;

      print("Mechanic ID: $mechanicId"); // ✅ DEBUG

      final response = await http.get(
        Uri.parse("$baseUrl/api/booking/mechanic/$mechanicId"),
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

  Future<void> updateStatus(String id, String status) async {
    await http.put(
      Uri.parse("$baseUrl/api/booking/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );

    fetchBookings(); // refresh list
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MechanicHomeScreen(),
              ),
            );
          },
        ),
      ),
      body: bookings.isEmpty
          ? const Center(child: Text("No bookings yet"))
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (ctx, i) {
          final b = bookings[i];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(b["serviceType"] ?? ""),
              subtitle:
              Text("₹${b["price"]} • ${b["status"] ?? ""}"),
              trailing: b["status"] == "pending"
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check,
                        color: Colors.green),
                    onPressed: () =>
                        updateStatus(b["_id"], "accepted"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.red),
                    onPressed: () =>
                        updateStatus(b["_id"], "rejected"),
                  ),
                ],
              )
                  : null,
            ),
          );
        },
      ),
    );
  }
}