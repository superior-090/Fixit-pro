import 'package:flutter/material.dart';

import '../main.dart';
import '../services/api_service.dart';

class MechanicBookingsScreen extends StatefulWidget {
  const MechanicBookingsScreen({super.key});

  @override
  State<MechanicBookingsScreen> createState() => _MechanicBookingsScreenState();
}

class _MechanicBookingsScreenState extends State<MechanicBookingsScreen> {
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

      final mechanicId = currentUser.id;
      final remoteBookings = await getMechanicBookings(mechanicId);
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

  Future<void> updateStatus(String id, String status) async {
    try {
      await updateBookingStatus(id, status);
      await fetchBookings();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
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
      appBar: AppBar(
        title: const Text("My Bookings"),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MechanicHomeScreen()),
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
                    title: Text(b["serviceType"] ?? "Unknown Service"),
                    subtitle: Text(
                      "₹${b["price"]} • ${b["status"] ?? "pending"}",
                    ),
                    trailing: b["status"] == "pending"
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () =>
                                    updateStatus(b["_id"], "accepted"),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
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
