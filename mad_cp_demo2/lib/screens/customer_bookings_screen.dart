import 'package:flutter/material.dart';

import '../main.dart';
import '../services/api_service.dart';

class CustomerBookingsScreen extends StatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  State<CustomerBookingsScreen> createState() => _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState extends State<CustomerBookingsScreen> {
  List<dynamic> bookings = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final currentUser = UserSession().currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final customerId = currentUser.id;
      final remoteBookings = await getCustomerBookings(customerId);
      if (mounted) {
        setState(() {
          bookings = remoteBookings;
          loading = false;
          errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          errorMessage = e.toString();
        });
      }
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Bookings")),
        body: Center(child: Text("Error: $errorMessage")),
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
                    title: Text(b["serviceType"] ?? "Unknown Service"),
                    subtitle: Text("₹${b["price"] ?? "N/A"}"),
                    trailing: Text(
                      b["status"] ?? "pending",
                      style: TextStyle(
                        color: getStatusColor(b["status"] ?? "pending"),
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
