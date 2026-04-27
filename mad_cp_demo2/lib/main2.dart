import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/mechanic_bookings_screen.dart';
import 'screens/customer_bookings_screen.dart';
const String baseUrl = "http://10.0.2.2:5000";
// ==========================================================================
// THEME
// ==========================================================================

class AppTheme {
  AppTheme._();
  static const Color primaryColor = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color accentColor = Color(0xFFFF8F00);
  static const Color accentLight = Color(0xFFFFA726);
  static const Color scaffoldBackground = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color priceColor = Color(0xFF059669);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: cardBackground,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: dividerColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: dividerColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: errorColor)),
        hintStyle: const TextStyle(color: textLight, fontSize: 14),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      dividerTheme: const DividerThemeData(
          color: dividerColor, thickness: 1, space: 1),
    );
  }
}

// ==========================================================================
// MODELS
// ==========================================================================

enum UserRole { customer, mechanic }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? serviceType;
  final double rating;
  final int jobsCompleted;
  final bool isAvailable;
  final String? profileImageUrl;
  final String? address;
  final int price;
  final double distance;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.serviceType,
    this.rating = 0.0,
    this.jobsCompleted = 0,
    this.isAvailable = true,
    this.profileImageUrl,
    this.address,
    this.price = 0,
    this.distance = 0.0,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? serviceType,
    double? rating,
    int? jobsCompleted,
    bool? isAvailable,
    String? profileImageUrl,
    String? address,
    int? price,
    double? distance,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      serviceType: serviceType ?? this.serviceType,
      rating: rating ?? this.rating,
      jobsCompleted: jobsCompleted ?? this.jobsCompleted,
      isAvailable: isAvailable ?? this.isAvailable,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      address: address ?? this.address,
      price: price ?? this.price,
      distance: distance ?? this.distance,
    );
  }
}

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class ServiceData {
  ServiceData._();
  static const List<ServiceModel> services = [
    ServiceModel(id: 'plumbing', name: 'Plumbing', description: 'Fix leaks, pipes, taps, and drainage issues', icon: Icons.plumbing, color: Color(0xFF1565C0)),
    ServiceModel(id: 'electrician', name: 'Electrician', description: 'Wiring, switches, fans, and electrical repairs', icon: Icons.electrical_services, color: Color(0xFFFF8F00)),
    ServiceModel(id: 'ac_repair', name: 'AC Repair', description: 'AC servicing, gas refill, and installation', icon: Icons.ac_unit, color: Color(0xFF00ACC1)),
    ServiceModel(id: 'washing_machine', name: 'Washing Machine', description: 'Washing machine repair and servicing', icon: Icons.local_laundry_service, color: Color(0xFF7B1FA2)),
    ServiceModel(id: 'car_bike', name: 'Car/Bike Mechanic', description: 'Vehicle repair, servicing, and maintenance', icon: Icons.directions_car, color: Color(0xFFE53935)),
    ServiceModel(id: 'carpentry', name: 'Carpentry', description: 'Furniture repair, assembly, and woodwork', icon: Icons.carpenter, color: Color(0xFF6D4C41)),
    ServiceModel(id: 'painting', name: 'Painting', description: 'Wall painting, waterproofing, and touch-ups', icon: Icons.format_paint, color: Color(0xFF43A047)),
    ServiceModel(id: 'deep_cleaning', name: 'Deep Cleaning', description: 'Home deep cleaning and sanitization', icon: Icons.cleaning_services, color: Color(0xFF00897B)),
    ServiceModel(id: 'daily_cleaning', name: 'Daily Cleaning', description: 'Daily home cleaning and maintenance', icon: Icons.home_outlined, color: Color(0xFF5C6BC0)),
    ServiceModel(id: 'home_sanitization', name: 'Sanitization', description: 'Complete home sanitization and disinfection', icon: Icons.sanitizer, color: Color(0xFF26A69A)),
    ServiceModel(id: 'pest_control', name: 'Pest Control', description: 'Cockroach, termite, mosquito pest treatment', icon: Icons.bug_report, color: Color(0xFFEF6C00)),
    ServiceModel(id: 'water_purifier', name: 'Water Purifier', description: 'RO repair, filter change, and AMC service', icon: Icons.water_drop, color: Color(0xFF0288D1)),
  ];
  static List<String> get serviceTypeNames => services.map((s) => s.name).toList();
}

enum BookingStatus { pending, accepted, inProgress, completed, cancelled, rejected }

class BookingModel {
  final String id;
  final String customerId;
  final String customerName;
  final String mechanicId;
  final String mechanicName;
  final String serviceId;
  final String serviceName;
  final DateTime bookingDate;
  final String timeSlot;
  final String address;
  final BookingStatus status;
  final double price;
  final String? notes;
  final DateTime createdAt;
  final String? customerPhone;
  final String? mechanicPhone;
  final DateTime? completedAt;

  const BookingModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.mechanicId,
    required this.mechanicName,
    required this.serviceId,
    required this.serviceName,
    required this.bookingDate,
    required this.timeSlot,
    required this.address,
    required this.status,
    required this.price,
    this.notes,
    required this.createdAt,
    this.customerPhone,
    this.mechanicPhone,
    this.completedAt,
  });

  BookingModel copyWith({
    String? id, String? customerId, String? customerName,
    String? mechanicId, String? mechanicName, String? serviceId,
    String? serviceName, DateTime? bookingDate, String? timeSlot,
    String? address, BookingStatus? status, double? price,
    String? notes, DateTime? createdAt, String? customerPhone,
    String? mechanicPhone, DateTime? completedAt,
  }) {
    return BookingModel(
      id: id ?? this.id, customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      mechanicId: mechanicId ?? this.mechanicId,
      mechanicName: mechanicName ?? this.mechanicName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      bookingDate: bookingDate ?? this.bookingDate,
      timeSlot: timeSlot ?? this.timeSlot, address: address ?? this.address,
      status: status ?? this.status, price: price ?? this.price,
      notes: notes ?? this.notes, createdAt: createdAt ?? this.createdAt,
      customerPhone: customerPhone ?? this.customerPhone,
      mechanicPhone: mechanicPhone ?? this.mechanicPhone,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  String get statusText {
    switch (status) {
      case BookingStatus.pending: return 'Pending';
      case BookingStatus.accepted: return 'Accepted';
      case BookingStatus.inProgress: return 'In Progress';
      case BookingStatus.completed: return 'Completed';
      case BookingStatus.cancelled: return 'Cancelled';
      case BookingStatus.rejected: return 'Rejected';
    }
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customerId": customerId,
      "customerName": customerName,
      "mechanicId": mechanicId,
      "mechanicName": mechanicName,
      "serviceId": serviceId,
      "serviceName": serviceName,
      "price": price,
      "status": status.index,
      "bookingDate": bookingDate.toIso8601String(),
      "timeSlot": timeSlot,
      "address": address,
      "createdAt": createdAt.toIso8601String(),
    };
  }
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json["id"],
      customerId: json["customerId"],
      customerName: json["customerName"],
      mechanicId: json["mechanicId"],
      mechanicName: json["mechanicName"],
      serviceId: json["serviceId"],
      serviceName: json["serviceName"],
      price: (json["price"] as num).toDouble(),
      status: BookingStatus.values[json["status"]],
      bookingDate: DateTime.parse(json["bookingDate"]),
      timeSlot: json["timeSlot"],
      address: json["address"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}

// ==========================================================================
// DUMMY DATA — NO hardcoded names used in UI anywhere
// These are only for mechanic list data, never for greeting text
// ==========================================================================

class DummyData {
  DummyData._();

  static const List<UserModel> mechanics = [
    UserModel(id: 'm1', name: 'Rajesh Kumar', email: 'rajesh@example.com', phone: '+91 9876543210', role: UserRole.mechanic, serviceType: 'Plumbing', rating: 4.8, jobsCompleted: 156, isAvailable: true, price: 299, distance: 1.2),
    UserModel(id: 'm5', name: 'Deepak Patel', email: 'deepak@example.com', phone: '+91 9876543214', role: UserRole.mechanic, serviceType: 'Plumbing', rating: 4.3, jobsCompleted: 67, isAvailable: true, price: 249, distance: 4.1),
    UserModel(id: 'm15', name: 'Harish Chandra', email: 'harish@example.com', phone: '+91 9876543224', role: UserRole.mechanic, serviceType: 'Plumbing', rating: 4.5, jobsCompleted: 134, isAvailable: true, price: 350, distance: 2.7),
    UserModel(id: 'm2', name: 'Amit Sharma', email: 'amit@example.com', phone: '+91 9876543211', role: UserRole.mechanic, serviceType: 'Electrician', rating: 4.6, jobsCompleted: 203, isAvailable: true, price: 250, distance: 2.5),
    UserModel(id: 'm6', name: 'Manoj Tiwari', email: 'manoj@example.com', phone: '+91 9876543215', role: UserRole.mechanic, serviceType: 'Electrician', rating: 4.5, jobsCompleted: 145, isAvailable: true, price: 320, distance: 1.9),
    UserModel(id: 'm16', name: 'Vishal Pandey', email: 'vishal@example.com', phone: '+91 9876543225', role: UserRole.mechanic, serviceType: 'Electrician', rating: 4.2, jobsCompleted: 89, isAvailable: false, price: 199, distance: 5.3),
    UserModel(id: 'm3', name: 'Sunil Verma', email: 'sunil@example.com', phone: '+91 9876543212', role: UserRole.mechanic, serviceType: 'AC Repair', rating: 4.9, jobsCompleted: 89, isAvailable: true, price: 499, distance: 3.8),
    UserModel(id: 'm17', name: 'Prakash Rao', email: 'prakash@example.com', phone: '+91 9876543226', role: UserRole.mechanic, serviceType: 'AC Repair', rating: 4.4, jobsCompleted: 156, isAvailable: true, price: 599, distance: 1.4),
    UserModel(id: 'm7', name: 'Ravi Yadav', email: 'ravi@example.com', phone: '+91 9876543216', role: UserRole.mechanic, serviceType: 'Washing Machine', rating: 4.4, jobsCompleted: 98, isAvailable: true, price: 399, distance: 5.2),
    UserModel(id: 'm18', name: 'Dinesh Rawat', email: 'dinesh@example.com', phone: '+91 9876543227', role: UserRole.mechanic, serviceType: 'Washing Machine', rating: 4.6, jobsCompleted: 201, isAvailable: true, price: 450, distance: 2.1),
    UserModel(id: 'm4', name: 'Vikram Singh', email: 'vikram@example.com', phone: '+91 9876543213', role: UserRole.mechanic, serviceType: 'Car/Bike Mechanic', rating: 4.7, jobsCompleted: 312, isAvailable: false, price: 599, distance: 0.8),
    UserModel(id: 'm19', name: 'Ajay Thakur', email: 'ajay@example.com', phone: '+91 9876543228', role: UserRole.mechanic, serviceType: 'Car/Bike Mechanic', rating: 4.3, jobsCompleted: 178, isAvailable: true, price: 499, distance: 3.5),
    UserModel(id: 'm8', name: 'Arun Gupta', email: 'arun@example.com', phone: '+91 9876543217', role: UserRole.mechanic, serviceType: 'Carpentry', rating: 4.7, jobsCompleted: 178, isAvailable: true, price: 349, distance: 2.3),
    UserModel(id: 'm20', name: 'Bharat Negi', email: 'bharat@example.com', phone: '+91 9876543229', role: UserRole.mechanic, serviceType: 'Carpentry', rating: 4.1, jobsCompleted: 56, isAvailable: true, price: 275, distance: 4.8),
    UserModel(id: 'm9', name: 'Kiran Joshi', email: 'kiran@example.com', phone: '+91 9876543218', role: UserRole.mechanic, serviceType: 'Painting', rating: 4.6, jobsCompleted: 112, isAvailable: false, price: 799, distance: 3.1),
    UserModel(id: 'm21', name: 'Mohan Lal', email: 'mohan@example.com', phone: '+91 9876543230', role: UserRole.mechanic, serviceType: 'Painting', rating: 4.8, jobsCompleted: 245, isAvailable: true, price: 650, distance: 1.6),
    UserModel(id: 'm10', name: 'Sanjay Mishra', email: 'sanjay@example.com', phone: '+91 9876543219', role: UserRole.mechanic, serviceType: 'Deep Cleaning', rating: 4.8, jobsCompleted: 234, isAvailable: true, price: 999, distance: 6.0),
    UserModel(id: 'm22', name: 'Rohan Mehta', email: 'rohan@example.com', phone: '+91 9876543231', role: UserRole.mechanic, serviceType: 'Deep Cleaning', rating: 4.5, jobsCompleted: 167, isAvailable: true, price: 849, distance: 2.9),
    UserModel(id: 'm11', name: 'Pradeep Nair', email: 'pradeep@example.com', phone: '+91 9876543220', role: UserRole.mechanic, serviceType: 'Daily Cleaning', rating: 4.5, jobsCompleted: 320, isAvailable: true, price: 199, distance: 1.5),
    UserModel(id: 'm23', name: 'Suresh Babu', email: 'suresh@example.com', phone: '+91 9876543232', role: UserRole.mechanic, serviceType: 'Daily Cleaning', rating: 4.3, jobsCompleted: 412, isAvailable: true, price: 149, distance: 0.9),
    UserModel(id: 'm12', name: 'Ramesh Iyer', email: 'ramesh@example.com', phone: '+91 9876543221', role: UserRole.mechanic, serviceType: 'Sanitization', rating: 4.7, jobsCompleted: 88, isAvailable: true, price: 1299, distance: 2.8),
    UserModel(id: 'm24', name: 'Kishore Reddy', email: 'kishore@example.com', phone: '+91 9876543233', role: UserRole.mechanic, serviceType: 'Sanitization', rating: 4.4, jobsCompleted: 134, isAvailable: true, price: 1099, distance: 4.2),
    UserModel(id: 'm13', name: 'Gopal Das', email: 'gopal@example.com', phone: '+91 9876543222', role: UserRole.mechanic, serviceType: 'Pest Control', rating: 4.6, jobsCompleted: 195, isAvailable: true, price: 899, distance: 3.4),
    UserModel(id: 'm25', name: 'Naveen Kumar', email: 'naveen@example.com', phone: '+91 9876543234', role: UserRole.mechanic, serviceType: 'Pest Control', rating: 4.8, jobsCompleted: 278, isAvailable: true, price: 749, distance: 1.8),
    UserModel(id: 'm14', name: 'Nitin Saxena', email: 'nitin@example.com', phone: '+91 9876543223', role: UserRole.mechanic, serviceType: 'Water Purifier', rating: 4.4, jobsCompleted: 76, isAvailable: true, price: 349, distance: 4.6),
    UserModel(id: 'm26', name: 'Tarun Bhatia', email: 'tarun@example.com', phone: '+91 9876543235', role: UserRole.mechanic, serviceType: 'Water Purifier', rating: 4.6, jobsCompleted: 112, isAvailable: true, price: 299, distance: 2.0),
  ];

  static List<UserModel> getMechanicsByService(String serviceName) {
    return mechanics.where((m) => m.serviceType?.toLowerCase() == serviceName.toLowerCase()).toList();
  }

  static String getPriceRange(String serviceName) {
    final mechs = getMechanicsByService(serviceName);
    if (mechs.isEmpty) return '';
    final prices = mechs.map((m) => m.price).toList()..sort();
    if (prices.first == prices.last) return '₹${prices.first}';
    return '₹${prices.first} - ₹${prices.last}';
  }
}

// ==========================================================================
// GLOBAL MANAGERS
// ==========================================================================

class BookingManager {
  static final BookingManager _instance = BookingManager._internal();
  factory BookingManager() => _instance;
  BookingManager._internal();

  final List<BookingModel> _customerBookings = [];
  final List<BookingModel> _mechanicJobRequests = [];
  int _bookingCounter = 0;

  List<BookingModel> get customerBookings => List.unmodifiable(_customerBookings);
  List<BookingModel> get mechanicJobRequests => List.unmodifiable(_mechanicJobRequests);

  Future<void> saveBookings() async {
    final prefs = await SharedPreferences.getInstance();

    final data = _customerBookings.map((b) => b.toJson()).toList();

    await prefs.setString('bookings', jsonEncode(data));
  }
  Future<void> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('bookings');

    if (data != null) {
      final List decoded = jsonDecode(data);

      _customerBookings.clear();
      _mechanicJobRequests.clear();

      final bookings = decoded
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();

      _customerBookings.addAll(bookings);
      _mechanicJobRequests.addAll(bookings);
    }
  }

  Future<void> addBooking(BookingModel booking) async {
    _customerBookings.add(booking);
    _mechanicJobRequests.add(booking);

    await saveBookings(); // 🔥 IMPORTANT
  }

  String generateBookingId() {
    _bookingCounter++;
    return 'BK${DateTime.now().millisecondsSinceEpoch}_$_bookingCounter';
  }

  void updateJobStatus(String bookingId, BookingStatus newStatus) {
    final now = DateTime.now();
    final mechIndex = _mechanicJobRequests.indexWhere((j) => j.id == bookingId);
    if (mechIndex != -1) {
      _mechanicJobRequests[mechIndex] = _mechanicJobRequests[mechIndex].copyWith(
          status: newStatus, completedAt: newStatus == BookingStatus.completed ? now : null);
    }
    final custIndex = _customerBookings.indexWhere((b) => b.id == bookingId);
    if (custIndex != -1) {
      _customerBookings[custIndex] = _customerBookings[custIndex].copyWith(
          status: newStatus, completedAt: newStatus == BookingStatus.completed ? now : null);
    }
  }

  int calculateTodayEarnings(String mechanicId) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId && job.status == BookingStatus.completed &&
          job.completedAt != null && job.completedAt!.isAfter(todayStart) && job.completedAt!.isBefore(todayEnd)) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  int calculateWeekEarnings(String mechanicId) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId && job.status == BookingStatus.completed &&
          job.completedAt != null && job.completedAt!.isAfter(weekStartDate)) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  int calculateMonthEarnings(String mechanicId) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId && job.status == BookingStatus.completed &&
          job.completedAt != null && job.completedAt!.isAfter(monthStart)) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  int calculateTotalEarnings(String mechanicId) {
    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId && job.status == BookingStatus.completed) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  int countTodayCompletedJobs(String mechanicId) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return _mechanicJobRequests.where((j) => j.mechanicId == mechanicId && j.status == BookingStatus.completed &&
        j.completedAt != null && j.completedAt!.isAfter(todayStart) && j.completedAt!.isBefore(todayEnd)).length;
  }

  int calculateYesterdayEarnings(String mechanicId) {
    final now = DateTime.now();
    final yesterdayStart = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
    final yesterdayEnd = DateTime(now.year, now.month, now.day);
    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId && job.status == BookingStatus.completed &&
          job.completedAt != null && job.completedAt!.isAfter(yesterdayStart) && job.completedAt!.isBefore(yesterdayEnd)) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  String getEarningsChangePercent(String mechanicId) {
    final today = calculateTodayEarnings(mechanicId);
    final yesterday = calculateYesterdayEarnings(mechanicId);
    if (yesterday == 0 && today == 0) return '0%';
    if (yesterday == 0) return '+100%';
    final change = ((today - yesterday) / yesterday * 100).round();
    return change >= 0 ? '+$change%' : '$change%';
  }
}

// ==========================================================================
// USER SESSION — The SINGLE source of truth for the current user's name
// No hardcoded names anywhere. All greeting text derives from here.
// ==========================================================================

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  /// The currently logged-in user. null = nobody logged in.
  UserModel? currentUser;

  /// Returns the user's first name or empty string if nobody is logged in.
  /// NEVER returns a hardcoded fallback name like "Rajesh".
  String get displayName {
    if (currentUser == null) return '';
    final name = currentUser!.name.trim();
    if (name.isEmpty) return '';
    return name.split(' ').first;
  }

  /// Returns full name or empty string
  String get fullName {
    if (currentUser == null) return '';
    final name = currentUser!.name.trim();
    if (name.isEmpty) return '';
    return name;
  }

  /// Returns initials for avatar, or empty
  String get initials {
    if (currentUser == null) return '';
    final name = currentUser!.name.trim();
    if (name.isEmpty) return '';
    return name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join();
  }

  int get mechanicRate => currentUser?.price ?? 0;
  String get mechanicId => currentUser?.id ?? '';

  /// Builds the greeting string dynamically.
  /// If name is empty/null: "Hello 👋"
  /// If name exists: "Hello, Amit 🔧"
  String buildGreeting({bool isMechanic = false}) {
    final name = displayName;
    if (name.isEmpty) {
      return 'Hello 👋';
    }
    return isMechanic ? 'Hello, $name 🔧' : 'Hello, $name 👋';
  }

  void logout() {
    currentUser = null;
  }
}

// ==========================================================================
// REUSABLE WIDGETS
// ==========================================================================

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key, required this.text, required this.onPressed,
    this.isLoading = false, this.isOutlined = false, this.isFullWidth = true,
    this.icon, this.backgroundColor, this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
        : Row(mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
      if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
      Flexible(child: Text(text, overflow: TextOverflow.ellipsis, maxLines: 1)),
    ]);

    if (isOutlined) {
      return SizedBox(width: isFullWidth ? double.infinity : null, height: 52,
          child: OutlinedButton(onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(foregroundColor: textColor ?? AppTheme.primaryColor,
                  side: BorderSide(color: backgroundColor ?? AppTheme.primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: child));
    }
    return SizedBox(width: isFullWidth ? double.infinity : null, height: 52,
        child: ElevatedButton(onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: backgroundColor ?? AppTheme.primaryColor,
                foregroundColor: textColor ?? Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2),
            child: child));
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;
  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
        child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: service.color.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 3))]),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: service.color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                      child: Icon(service.icon, color: service.color, size: 26)),
                  const SizedBox(height: 8),
                  Flexible(child: Text(service.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary, height: 1.2))),
                ]))));
  }
}

class MechanicCard extends StatelessWidget {
  final UserModel mechanic;
  final VoidCallback onBookPressed;
  const MechanicCard({super.key, required this.mechanic, required this.onBookPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
        child: Padding(padding: const EdgeInsets.all(14),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(children: [
                Container(width: 52, height: 52, decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                    child: Center(child: Text(mechanic.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primaryColor)))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(mechanic.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
                    Container(width: 9, height: 9, decoration: BoxDecoration(
                        color: mechanic.isAvailable ? AppTheme.successColor : AppTheme.errorColor, shape: BoxShape.circle)),
                  ]),
                  const SizedBox(height: 4),
                  Wrap(spacing: 8, runSpacing: 2, children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star, size: 14, color: AppTheme.warningColor), const SizedBox(width: 2),
                      Text(mechanic.rating.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))]),
                    Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.work_outline, size: 13, color: AppTheme.textLight), const SizedBox(width: 2),
                      Text('${mechanic.jobsCompleted} jobs', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))]),
                    Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textLight), const SizedBox(width: 2),
                      Text('${mechanic.distance} km', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))]),
                  ]),
                ])),
              ]),
              const SizedBox(height: 12),
              Container(height: 1, color: AppTheme.dividerColor.withOpacity(0.6)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Service Price', style: TextStyle(fontSize: 10, color: AppTheme.textLight, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text('₹${mechanic.price}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.priceColor)),
                ]),
                SizedBox(height: 40, child: ElevatedButton.icon(
                    onPressed: mechanic.isAvailable ? onBookPressed : null,
                    icon: Icon(mechanic.isAvailable ? Icons.calendar_today_outlined : Icons.block, size: 16),
                    label: Text(mechanic.isAvailable ? 'Book Now' : 'Busy'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: mechanic.isAvailable ? AppTheme.accentColor : Colors.grey[300],
                        foregroundColor: mechanic.isAvailable ? Colors.white : Colors.grey[600],
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0))),
              ]),
            ])));
  }
}

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool showMechanicInfo;
  final bool showCustomerInfo;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;

  const BookingCard({super.key, required this.booking, this.showMechanicInfo = true, this.showCustomerInfo = false,
    this.onAccept, this.onReject, this.onComplete});

  Color _statusColor(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending: return AppTheme.warningColor;
      case BookingStatus.accepted: return AppTheme.primaryColor;
      case BookingStatus.inProgress: return AppTheme.accentColor;
      case BookingStatus.completed: return AppTheme.successColor;
      case BookingStatus.cancelled: case BookingStatus.rejected: return AppTheme.errorColor;
    }
  }

  IconData _statusIcon(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending: return Icons.schedule;
      case BookingStatus.accepted: return Icons.check_circle_outline;
      case BookingStatus.inProgress: return Icons.engineering;
      case BookingStatus.completed: return Icons.task_alt;
      case BookingStatus.cancelled: return Icons.cancel_outlined;
      case BookingStatus.rejected: return Icons.block;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor(booking.status);
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final d = booking.bookingDate;
    final dateStr = '${d.day.toString().padLeft(2,'0')} ${months[d.month-1]} ${d.year}';

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: sc.withOpacity(0.3)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: sc.withOpacity(0.06),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
              child: Row(children: [
                Icon(Icons.home_repair_service, color: sc, size: 18), const SizedBox(width: 6),
                Expanded(child: Text(booking.serviceName, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)
                )),
                const SizedBox(height: 4),

                Text(
                  "Time: ${booking.timeSlot}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: sc.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(_statusIcon(booking.status), size: 12, color: sc), const SizedBox(width: 3),
                      Text(booking.statusText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: sc)),
                    ])),
              ])),
          Padding(padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                if (showMechanicInfo) ...[_infoRow(Icons.person, 'Mechanic', booking.mechanicName), const SizedBox(height: 6)],
                if (showCustomerInfo) ...[_infoRow(Icons.person, 'Customer', booking.customerName), const SizedBox(height: 6)],
                _infoRow(Icons.calendar_today, 'Date', dateStr), const SizedBox(height: 6),
                _infoRow(Icons.access_time, 'Time', booking.timeSlot), const SizedBox(height: 6),
                _infoRow(Icons.location_on, 'Address', booking.address),
                if (booking.notes != null && booking.notes!.isNotEmpty) ...[const SizedBox(height: 6), _infoRow(Icons.note, 'Notes', booking.notes!)],
                const Divider(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Total', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textSecondary)),
                  Text('₹${booking.price.toInt()}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.priceColor)),
                ]),
              ])),
          if (booking.status == BookingStatus.pending && (onAccept != null || onReject != null))
            Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Row(children: [
                  if (onReject != null) Expanded(child: OutlinedButton.icon(onPressed: onReject, icon: const Icon(Icons.close, size: 16), label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppTheme.errorColor, side: const BorderSide(color: AppTheme.errorColor),
                          padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
                  if (onAccept != null && onReject != null) const SizedBox(width: 10),
                  if (onAccept != null) Expanded(child: ElevatedButton.icon(onPressed: onAccept, icon: const Icon(Icons.check, size: 16), label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successColor, foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
                ])),
          if (booking.status == BookingStatus.accepted && onComplete != null)
            Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: onComplete,
                    icon: const Icon(Icons.task_alt, size: 18), label: const Text('Mark as Completed'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.priceColor, foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))))),
        ]));
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 14, color: AppTheme.textLight), const SizedBox(width: 6),
      SizedBox(width: 58, child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textLight))),
      Expanded(child: Text(value, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
    ]);
  }
}

// ==========================================================================
// AUTH SCREENS
// ==========================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  UserRole _role = UserRole.customer;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
    _animCtrl.forward();
  }

  @override
  void dispose() { _emailController.dispose(); _passwordController.dispose(); _animCtrl.dispose(); super.dispose(); }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      print("FULL RESPONSE: $data");
      setState(() => _loading = false);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("role", data["role"].toString());
        await prefs.setString("role", data["role"].toString());
        // SAVE USER IN SESSION
        UserSession().currentUser = UserModel(
          id: data["id"]?.toString() ?? "",
          name: data["name"]?.toString() ?? "",
          email: data["email"]?.toString() ?? "",
          phone: data["phone"]?.toString() ?? "",
          role: (data["role"] ?? "") == "mechanic"
              ? UserRole.mechanic
              : UserRole.customer,
          serviceType: data["serviceType"]?.toString() ?? "",
          price: data["price"] ?? 0,
        );

        // NAVIGATION (AUTO BASED ON ROLE)
        if (data["role"] == "mechanic") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MechanicBookingsScreen(),),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["msg"] ?? "Login failed")),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.scaffoldBackground,
        body: SafeArea(
            child: FadeTransition(opacity: _fadeAnim,
                child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      const SizedBox(height: 60),
                      Container(width: 90, height: 90,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [AppTheme.primaryColor, AppTheme.primaryLight]),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))]),
                          child: const Icon(Icons.home_repair_service, color: Colors.white, size: 45)),
                      const SizedBox(height: 24),
                      const Text('FixIt Pro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      const SizedBox(height: 6),
                      const Text('Your trusted household services partner', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                      const SizedBox(height: 40),
                      Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
                          padding: const EdgeInsets.all(4),
                          child: Row(children: [
                            Expanded(child: _roleTab('Customer', Icons.person, UserRole.customer)),
                            Expanded(child: _roleTab('Mechanic', Icons.engineering, UserRole.mechanic)),
                          ])),
                      const SizedBox(height: 32),
                      Form(key: _formKey, child: Column(children: [
                        TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                            validator: (v) => (v == null || v.isEmpty || !v.contains('@')) ? 'Enter valid email' : null),
                        const SizedBox(height: 16),
                        TextFormField(controller: _passwordController, obscureText: _obscure,
                            decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppTheme.textLight),
                                    onPressed: () => setState(() => _obscure = !_obscure))),
                            validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null),
                        const SizedBox(height: 32),
                        CustomButton(text: 'Login', onPressed: _login, isLoading: _loading, icon: Icons.login),
                      ])),
                      const SizedBox(height: 24),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Text("Don't have an account? ", style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                        GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                            child: const Text('Register', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600, fontSize: 14))),
                      ]),
                      const SizedBox(height: 40),
                    ])))));
  }

  Widget _roleTab(String label, IconData icon, UserRole role) {
    final sel = _role == role;
    return GestureDetector(onTap: () => setState(() => _role = role),
        child: AnimatedContainer(duration: const Duration(milliseconds: 250), padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: sel ? AppTheme.primaryColor : Colors.transparent, borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 20, color: sel ? Colors.white : AppTheme.textSecondary), const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: sel ? Colors.white : AppTheme.textSecondary)),
            ])));
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  bool _obscure1 = true, _obscure2 = true, _loading = false;
  UserRole _role = UserRole.customer;
  String? _serviceType;

  @override
  void dispose() { _nameCtrl.dispose(); _phoneCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); _confirmCtrl.dispose(); _priceCtrl.dispose(); super.dispose(); }


  void _register() async {
      if (!_formKey.currentState!.validate()) return;

      if (_role == UserRole.mechanic && _serviceType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select service type')),
        );
        return;
      }

      setState(() => _loading = true);

      try {
        final response = await http.post(
          Uri.parse("$baseUrl/api/auth/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": _nameCtrl.text.trim(),
            "email": _emailCtrl.text.trim(),
            "phone": _phoneCtrl.text.trim(),
            "password": _passCtrl.text.trim(),
            "role": _role == UserRole.mechanic ? "mechanic" : "customer",
            "serviceType": _serviceType,
            "price": int.tryParse(_priceCtrl.text.trim()) ?? 0,
          }),
        );

        final data = jsonDecode(response.body);

        setState(() => _loading = false);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registered successfully")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["msg"] ?? "Register failed")),
          );
        }
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error")),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.scaffoldBackground,
        appBar: AppBar(title: const Text('Create Account'), backgroundColor: Colors.transparent, foregroundColor: AppTheme.textPrimary, elevation: 0),
        body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              const Text('Join FixIt Pro today', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: _roleOption('Customer', Icons.person, UserRole.customer)),
                const SizedBox(width: 12),
                Expanded(child: _roleOption('Mechanic', Icons.engineering, UserRole.mechanic)),
              ]),
              const SizedBox(height: 24),
              TextFormField(controller: _nameCtrl, textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _phoneCtrl, keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined)),
                  validator: (v) => (v == null || v.trim().length < 10) ? 'Enter valid phone' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _passCtrl, obscureText: _obscure1,
                  decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility, color: AppTheme.textLight),
                          onPressed: () => setState(() => _obscure1 = !_obscure1))),
                  validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _confirmCtrl, obscureText: _obscure2,
                  decoration: InputDecoration(labelText: 'Confirm Password', prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility, color: AppTheme.textLight),
                          onPressed: () => setState(() => _obscure2 = !_obscure2))),
                  validator: (v) => (v != _passCtrl.text) ? 'Passwords do not match' : null),
              const SizedBox(height: 16),
              if (_role == UserRole.mechanic) ...[
                DropdownButtonFormField<String>(value: _serviceType,
                    decoration: const InputDecoration(labelText: 'Service Type', prefixIcon: Icon(Icons.home_repair_service_outlined)),
                    items: ServiceData.serviceTypeNames.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setState(() => _serviceType = v)),
                const SizedBox(height: 16),
                TextFormField(controller: _priceCtrl, keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Your Service Price (₹)', prefixIcon: Icon(Icons.currency_rupee)),
                    validator: (v) => (_role == UserRole.mechanic && (v == null || int.tryParse(v.trim()) == null || int.parse(v.trim()) <= 0)) ? 'Enter valid price' : null),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 8),
              CustomButton(text: 'Create Account', onPressed: _register, isLoading: _loading, icon: Icons.person_add),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Already have an account? ', style: TextStyle(color: AppTheme.textSecondary)),
                GestureDetector(onTap: () => Navigator.pop(context),
                    child: const Text('Login', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 40),
            ]))));
  }

  Widget _roleOption(String label, IconData icon, UserRole role) {
    final sel = _role == role;
    return GestureDetector(onTap: () => setState(() => _role = role),
        child: AnimatedContainer(duration: const Duration(milliseconds: 250), padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: sel ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: sel ? AppTheme.primaryColor : AppTheme.dividerColor, width: sel ? 2 : 1)),
            child: Column(children: [
              Icon(icon, size: 32, color: sel ? AppTheme.primaryColor : AppTheme.textLight), const SizedBox(height: 6),
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: sel ? AppTheme.primaryColor : AppTheme.textSecondary)),
            ])));
  }
}

// ==========================================================================
// CUSTOMER SCREENS
// ==========================================================================

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});
  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.scaffoldBackground,
        body: _idx == 0
            ? _homePage()
            : _idx == 1
            ? const BookingHistoryScreen()
            : _profilePage(),
        bottomNavigationBar: BottomNavigationBar(currentIndex: _idx, onTap: (i) => setState(() => _idx = i), items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ]));
  }

  Widget _homePage() {
    // Dynamic greeting from UserSession — never hardcoded
    final greeting = UserSession().buildGreeting(isMechanic: false);
    final user = UserSession().currentUser;

    if (user == null) {
      return const Center(child: Text("Loading..."));
    }

    final userId = user.id;

    final bookings = BookingManager()
        .customerBookings
        .where((b) => b.customerId == userId)
        .toList();

    return SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.primaryLight]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // DYNAMIC greeting — shows "Hello 👋" if no name, "Hello, Amit 👋" if logged in
            Text(greeting, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            const Text('What service do you need today?', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ])),
      const SizedBox(height: 24),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Our Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
      const SizedBox(height: 12),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 400 ? 4 : 3;
            return GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.9),
                itemCount: ServiceData.services.length,
                itemBuilder: (ctx, i) => ServiceCard(service: ServiceData.services[i], onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceListScreen(service: ServiceData.services[i])))));
          })),
      const SizedBox(height: 28),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Recent Bookings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
      const SizedBox(height: 12),
      if (bookings.isEmpty)
        Container(margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.symmetric(vertical: 40), width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Icon(Icons.calendar_today_outlined, size: 56, color: AppTheme.textLight.withOpacity(0.4)),
              const SizedBox(height: 12),
              const Text('No bookings yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            ]))
      else ...bookings.take(3).map((b) {
        final sc = b.status == BookingStatus.completed ? AppTheme.successColor : b.status == BookingStatus.pending ? AppTheme.warningColor : AppTheme.primaryColor;
        return Container(margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(width: 4, height: 40, decoration: BoxDecoration(color: sc, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.serviceName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text('${b.mechanicName} • ₹${b.price.toInt()}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: sc.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(b.statusText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: sc))),
            ]));
      }),
      const SizedBox(height: 30),
    ])));
  }

  Widget _profilePage() {
    final s = UserSession();
    final displayInitials = s.initials.isNotEmpty ? s.initials : '?';
    final displayName = s.fullName.isNotEmpty ? s.fullName : 'Guest User';

    return SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
      const SizedBox(height: 20),
      Container(width: 100, height: 100, decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle,
          border: Border.all(color: AppTheme.primaryColor, width: 3)),
          child: Center(child: Text(displayInitials, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppTheme.primaryColor)))),
      const SizedBox(height: 16),
      Text(displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      const SizedBox(height: 32),
      SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () { UserSession().logout(); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false); },
          icon: const Icon(Icons.logout, color: AppTheme.errorColor),
          label: const Text('Logout', style: TextStyle(color: AppTheme.errorColor)),
          style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.errorColor), padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
    ])));
  }
}

class ServiceListScreen extends StatefulWidget {
  final ServiceModel service;
  const ServiceListScreen({super.key, required this.service});
  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  String _sort = 'rating';
  bool _availOnly = false;
  List<UserModel> mechanics = [];
  bool isLoading = true;

  Future<void> loadMechanics() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/mechanics"),
    );

    final data = jsonDecode(response.body);

    mechanics = (data as List).map((m) {
      return UserModel(
        id: m["_id"].toString(),
        name: m["name"] ?? "",
        email: m["email"] ?? "",
        phone: m["phone"] ?? "",
        role: UserRole.mechanic,
        serviceType: m["serviceType"] ?? "",
        price: m["price"] ?? 0,

        // TEMP FIX (since backend doesn’t send these)
        rating: 4.5,
        distance: 2.0,
        isAvailable: true,
      );
    }).toList();

    setState(() {
      isLoading = false;
    });
  }

  List<UserModel> get _filtered {
    // ✅ FILTER BY SERVICE TYPE
    var list = mechanics.where((m) =>
    (m.serviceType ?? "").trim().toLowerCase() ==
        widget.service.name.trim().toLowerCase()
    ).toList();

    // fallback (optional)

    if (_availOnly) {
      list = list.where((m) => m.isAvailable).toList();
    }

    switch (_sort) {
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'distance':
        list.sort((a, b) => a.distance.compareTo(b.distance));
        break;
    }

    return list;
  }
  @override
  void initState() {
    super.initState();
    loadMechanics(); // ✅ THIS WAS MISSING
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final mechs = _filtered;
    return Scaffold(backgroundColor: AppTheme.scaffoldBackground,
        appBar: AppBar(title: Text(widget.service.name), actions: [
          IconButton(icon: Icon(_availOnly ? Icons.filter_alt : Icons.filter_alt_outlined),
              onPressed: () => setState(() => _availOnly = !_availOnly))]),
        body: Column(children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: widget.service.color.withOpacity(0.08)),
              child: Row(children: [
                Container(width: 50, height: 50, decoration: BoxDecoration(color: widget.service.color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                    child: Icon(widget.service.icon, color: widget.service.color, size: 26)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.service.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  Text(widget.service.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ])),
              ])),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(children: [
                Text('${mechs.length} found', style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                const Spacer(),
                PopupMenuButton<String>(onSelected: (v) => setState(() => _sort = v),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'rating', child: Text('Rating')),
                      const PopupMenuItem(value: 'price_low', child: Text('Price ↑')),
                      const PopupMenuItem(value: 'price_high', child: Text('Price ↓')),
                      const PopupMenuItem(value: 'distance', child: Text('Distance')),
                    ],
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.sort, size: 18, color: AppTheme.primaryColor), SizedBox(width: 4),
                      Text('Sort', style: TextStyle(fontSize: 13, color: AppTheme.primaryColor, fontWeight: FontWeight.w500))])),
              ])),
          Expanded(child: mechs.isEmpty
              ? const Center(child: Text('No mechanics available', style: TextStyle(color: AppTheme.textSecondary)))
              : ListView.builder(padding: const EdgeInsets.only(bottom: 20), itemCount: mechs.length,
              itemBuilder: (ctx, i) => MechanicCard(mechanic: mechs[i], onBookPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 10, minute: 0),
                );

                if (pickedTime == null) return;

                // 🔥 STEP 2: VALIDATE TIME (10 AM - 10 PM)
                final totalMinutes = pickedTime.hour * 60 + pickedTime.minute;

                if (totalMinutes < 600 || totalMinutes > 1320) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Select time between 10 AM and 10 PM")),
                  );
                  return;
                }

                // 🔥 STEP 3: CHECK SLOT ALREADY BOOKED
                final isTaken = BookingManager()
                    .customerBookings
                    .any((b) =>
                b.mechanicId == mechs[i].id &&
                    b.timeSlot == pickedTime.format(context));

                if (isTaken) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("This time slot is already booked")),
                  );
                  return;
                }
                final user = UserSession().currentUser!;

                BookingManager().addBooking(
                  BookingModel(
                    id: BookingManager().generateBookingId(),
                    customerId: user.id,
                    customerName: user.name,
                    mechanicId: mechs[i].id,
                    mechanicName: mechs[i].name,
                    serviceId: widget.service.id,
                    serviceName: widget.service.name,
                    bookingDate: DateTime.now(),
                    timeSlot: pickedTime.format(context),
                    address: "Default Address",
                    status: BookingStatus.pending,
                    price: mechs[i].price.toDouble(),
                    createdAt: DateTime.now(),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Booking Created")),
                );
              },
              ))),
        ]));
  }
}

class BookingScreen extends StatefulWidget {
  final ServiceModel service;
  final UserModel mechanic;
  const BookingScreen({super.key, required this.service, required this.mechanic});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addrCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  String? _slot;
  bool _loading = false;
  final _slots = ['8-10 AM', '10-12 PM', '12-2 PM', '2-4 PM', '4-6 PM', '6-8 PM'];
  int get _fee => 29;
  int get _total => widget.mechanic.price + _fee;

  @override
  void dispose() { _addrCtrl.dispose(); _notesCtrl.dispose(); super.dispose(); }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    if (_slot == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select time slot'), backgroundColor: AppTheme.errorColor)); return; }
    setState(() => _loading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _loading = false);
      final s = UserSession();
      BookingManager().addBooking(BookingModel(
          id: BookingManager().generateBookingId(), customerId: s.currentUser?.id ?? 'guest',
          customerName: s.fullName.isNotEmpty ? s.fullName : 'Guest',
          mechanicId: widget.mechanic.id, mechanicName: widget.mechanic.name,
          serviceId: widget.service.id, serviceName: widget.service.name,
          bookingDate: _date, timeSlot: _slot!, address: _addrCtrl.text.trim(),
          status: BookingStatus.pending, price: _total.toDouble(),
          notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
          createdAt: DateTime.now(), customerPhone: s.currentUser?.phone, mechanicPhone: widget.mechanic.phone));
      showDialog(context: context, barrierDismissible: false,
          builder: (ctx) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 80, height: 80, decoration: BoxDecoration(color: AppTheme.successColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle, color: AppTheme.successColor, size: 50)),
                const SizedBox(height: 20),
                const Text('Booking Confirmed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Total: ₹$_total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.priceColor)),
                const SizedBox(height: 24),
                CustomButton(text: 'Done', onPressed: () { Navigator.pop(ctx); Navigator.pop(context); Navigator.pop(context); }),
              ])));
    });
  }

  @override
  Widget build(BuildContext context) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final ds = '${days[_date.weekday-1]}, ${_date.day} ${months[_date.month-1]} ${_date.year}';

    return Scaffold(backgroundColor: AppTheme.scaffoldBackground, appBar: AppBar(title: const Text('Book Service')),
        body: SingleChildScrollView(child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                Row(children: [
                  Container(width: 50, height: 50, decoration: BoxDecoration(color: widget.service.color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                      child: Icon(widget.service.icon, color: widget.service.color, size: 26)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.service.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Text('by ${widget.mechanic.name}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  ])),
                ]),
                const SizedBox(height: 10), Container(height: 1, color: AppTheme.dividerColor), const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text("Mechanic's Rate", style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  Text('₹${widget.mechanic.price}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.priceColor)),
                ]),
              ])),
          _sec('Select Date'),
          GestureDetector(onTap: () async {
            final p = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
            if (p != null) setState(() => _date = p);
          }, child: Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.dividerColor)),
              child: Row(children: [const Icon(Icons.calendar_today, color: AppTheme.primaryColor, size: 22), const SizedBox(width: 12),
                Expanded(child: Text(ds, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))), const Icon(Icons.edit, color: AppTheme.textLight, size: 18)]))),
          const SizedBox(height: 20),
          _sec('Select Time Slot'),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(spacing: 10, runSpacing: 10, children: _slots.map((sl) {
                final sel = _slot == sl;
                return GestureDetector(onTap: () => setState(() => _slot = sl),
                    child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(color: sel ? AppTheme.primaryColor : Colors.white, borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: sel ? AppTheme.primaryColor : AppTheme.dividerColor)),
                        child: Text(sl, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: sel ? Colors.white : AppTheme.textPrimary))));
              }).toList())),
          const SizedBox(height: 20),
          _sec('Address'),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(controller: _addrCtrl, maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Enter complete address', prefixIcon: Padding(padding: EdgeInsets.only(bottom: 40), child: Icon(Icons.location_on_outlined))),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter address' : null)),
          const SizedBox(height: 20),
          _sec('Notes (Optional)'),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(controller: _notesCtrl, maxLines: 2,
                  decoration: const InputDecoration(hintText: 'Any instructions...', prefixIcon: Padding(padding: EdgeInsets.only(bottom: 20), child: Icon(Icons.note_outlined))))),
          const SizedBox(height: 24),
          Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.priceColor.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.priceColor.withOpacity(0.2))),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Flexible(child: Text('${widget.mechanic.name}\'s charge', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
                  Text('₹${widget.mechanic.price}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ]),
                const SizedBox(height: 8),
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Platform Fee', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  Text('₹29', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ]),
                const Divider(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text('₹$_total', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.priceColor)),
                ]),
              ])),
          const SizedBox(height: 24),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(text: 'Confirm Booking • ₹$_total', onPressed: _confirm, isLoading: _loading,
                  icon: Icons.check_circle_outline, backgroundColor: AppTheme.accentColor)),
          const SizedBox(height: 32),
        ]))));
  }

  Widget _sec(String t) => Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)));
}

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});
  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tc;
  final _tabs = ['All', 'Pending', 'Accepted', 'Completed'];
  @override
  void initState() { super.initState(); _tc = TabController(length: _tabs.length, vsync: this); }
  @override
  void dispose() { _tc.dispose(); super.dispose(); }

  List<BookingModel> _filter(int i) {
    final user = UserSession().currentUser;

    if (user == null) return [];

    final b = BookingManager()
        .customerBookings
        .where((x) => x.customerId == user.id)
        .toList();
    switch (i) { case 1: return b.where((x) => x.status == BookingStatus.pending).toList();
      case 2: return b.where((x) => x.status == BookingStatus.accepted).toList();
      case 3: return b.where((x) => x.status == BookingStatus.completed).toList(); default: return b; }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Text('My Bookings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: TabBar(controller: _tc, labelColor: Colors.white, unselectedLabelColor: AppTheme.textSecondary,
              indicator: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(10)),
              indicatorSize: TabBarIndicatorSize.tab, dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4), tabs: _tabs.map((t) => Tab(text: t, height: 38)).toList())),
      const SizedBox(height: 12),
      Expanded(child: TabBarView(controller: _tc, children: List.generate(_tabs.length, (i) {
        final list = _filter(i);
        if (list.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppTheme.textLight.withOpacity(0.5)), const SizedBox(height: 12),
          const Text('No bookings yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))]));
        return ListView.builder(padding: const EdgeInsets.only(bottom: 20), itemCount: list.length,
            itemBuilder: (ctx, j) => BookingCard(booking: list[j], showMechanicInfo: true));
      }))),
    ]));
  }
}

// ==========================================================================
// MECHANIC SCREENS
// ALL greeting text is DYNAMIC via UserSession().buildGreeting()
// ALL earnings are CALCULATED from completed jobs
// ZERO hardcoded names anywhere
// ==========================================================================

class MechanicHomeScreen extends StatefulWidget {
  const MechanicHomeScreen({super.key});
  @override
  State<MechanicHomeScreen> createState() => _MechanicHomeScreenState();
}

class _MechanicHomeScreenState extends State<MechanicHomeScreen> {
  int _idx = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [_Dashboard(onNav: (i) => setState(() => _idx = i)), const JobRequestsScreen(), const MechanicProfileScreen()];
    return Scaffold(backgroundColor: AppTheme.scaffoldBackground,
        body: IndexedStack(index: _idx, children: pages),
        bottomNavigationBar: BottomNavigationBar(currentIndex: _idx, onTap: (i) => setState(() => _idx = i), items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), activeIcon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ]));
  }
}

/// MECHANIC DASHBOARD — completely dynamic
/// Greeting: UserSession().buildGreeting() — shows "Hello 👋" if no name, "Hello, Amit 🔧" otherwise
/// Earnings: calculated from BookingManager completed jobs
/// Rate: from UserSession().mechanicRate
class _Dashboard extends StatelessWidget {
  final void Function(int) onNav;
  const _Dashboard({required this.onNav});

  @override
  Widget build(BuildContext context) {
    // ====== ALL DYNAMIC — NO HARDCODED VALUES ======
    final session = UserSession();
    final mechanic = session.currentUser;
    final mechanicId = session.mechanicId;
    final rate = session.mechanicRate;
    final isAvailable = mechanic?.isAvailable ?? false;

    // Dynamic greeting — NEVER shows hardcoded "Rajesh"
    final greeting = session.buildGreeting(isMechanic: true);

    // Dynamic availability text with rate from profile
    final availText = isAvailable ? 'Available • ₹$rate/service' : 'Not Available';

    final currentUser = UserSession().currentUser;

    if (currentUser == null) return const SizedBox();

    final jobs = BookingManager()
        .mechanicJobRequests
        .where((b) => b.mechanicId == currentUser.id)
        .toList();
    final pending = jobs.where((j) => j.status == BookingStatus.pending).length;
    final accepted = jobs.where((j) => j.status == BookingStatus.accepted).length;
    final completed = jobs.where((j) => j.status == BookingStatus.completed).length;

    // Dynamic earnings — calculated from completed jobs ONLY
    final todayEarnings = BookingManager().calculateTodayEarnings(mechanicId);
    final weekEarnings = BookingManager().calculateWeekEarnings(mechanicId);
    final monthEarnings = BookingManager().calculateMonthEarnings(mechanicId);
    final todayJobs = BookingManager().countTodayCompletedJobs(mechanicId);
    final changePercent = BookingManager().getEarningsChangePercent(mechanicId);
    final isPositive = changePercent.startsWith('+') || changePercent == '0%';

    return SafeArea(child: SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppTheme.primaryDark, AppTheme.primaryColor]),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // ====== DYNAMIC GREETING ======
                    // Uses UserSession().buildGreeting() which returns:
                    // "Hello 👋" if no user/empty name
                    // "Hello, Amit 🔧" if logged in with name "Amit"
                    Text(greeting, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(
                          color: isAvailable ? AppTheme.successColor : AppTheme.errorColor, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      // Dynamic availability with rate from mechanic profile
                      Text(availText, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                    ]),
                  ])),
                  Container(width: 44, height: 44,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      child: Stack(children: [
                        const Center(child: Icon(Icons.notifications_outlined, color: Colors.white)),
                        if (pending > 0) Positioned(top: 6, right: 6, child: Container(width: 18, height: 18,
                            decoration: const BoxDecoration(color: AppTheme.errorColor, shape: BoxShape.circle),
                            child: Center(child: Text('$pending', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))))),
                      ])),
                ]),
                const SizedBox(height: 24),
                Row(children: [
                  _stat('Pending', '$pending', Icons.schedule),
                  const SizedBox(width: 12),
                  _stat('Accepted', '$accepted', Icons.check_circle_outline),
                  const SizedBox(width: 12),
                  _stat('Completed', '$completed', Icons.task_alt),
                ]),
              ])),
          const SizedBox(height: 24),

          // ====== DYNAMIC EARNINGS CARD ======
          // All values come from BookingManager calculations, never hardcoded
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(width: double.infinity, padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppTheme.accentColor, AppTheme.accentLight]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppTheme.accentColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6))]),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text("Today's Earnings", style: TextStyle(fontSize: 14, color: Colors.white70)),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                          child: Text(changePercent, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                              color: isPositive ? Colors.white : const Color(0xFFFFCDD2)))),
                    ]),
                    const SizedBox(height: 8),
                    // Dynamic today earnings — ₹0 when no completed jobs
                    Text('₹$todayEarnings', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('$todayJobs jobs completed today', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9))),
                    const SizedBox(height: 12),
                    Container(height: 1, color: Colors.white.withOpacity(0.3)),
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('This Week', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7))),
                        const SizedBox(height: 2),
                        Text('₹$weekEarnings', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      ]),
                      Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('This Month', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7))),
                        const SizedBox(height: 2),
                        Text('₹$monthEarnings', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      ]),
                      Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Your Rate', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7))),
                        const SizedBox(height: 2),
                        Text('₹$rate', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      ]),
                    ]),
                  ]))),
          const SizedBox(height: 24),

          const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
          const SizedBox(height: 12),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                _qAction('View Jobs', Icons.work_outline, AppTheme.primaryColor, () => onNav(1)),
                const SizedBox(width: 12),
                _qAction('My Profile', Icons.person_outline, AppTheme.accentColor, () => onNav(2)),
                const SizedBox(width: 12),
                _qAction('Earnings', Icons.account_balance_wallet_outlined, AppTheme.successColor, () {
                  final total = BookingManager().calculateTotalEarnings(mechanicId);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Total earnings: ₹$total'), backgroundColor: AppTheme.priceColor));
                }),
              ])),
          const SizedBox(height: 24),

          Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                TextButton(onPressed: () => onNav(1), child: const Text('View All')),
              ])),
          const SizedBox(height: 8),

          if (jobs.isEmpty)
            Container(margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.symmetric(vertical: 40), width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  Icon(Icons.work_off_outlined, size: 56, color: AppTheme.textLight.withOpacity(0.4)),
                  const SizedBox(height: 12),
                  const Text('No job requests yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                  const SizedBox(height: 4),
                  const Text('Earnings update when you complete jobs', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
                ]))
          else ...jobs.take(3).map((job) {
            final sc = job.status == BookingStatus.pending ? AppTheme.warningColor
                : job.status == BookingStatus.accepted ? AppTheme.primaryColor
                : job.status == BookingStatus.completed ? AppTheme.successColor : AppTheme.textLight;
            return Container(margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: sc.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.home_repair_service, color: sc, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(job.customerName, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    Text('${job.serviceName} • ${job.timeSlot}', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('₹${job.price.toInt()}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.priceColor)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: sc.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(job.statusText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: sc))),
                  ]),
                ]));
          }),
          const SizedBox(height: 24),
        ])));
  }

  Widget _stat(String l, String c, IconData i) => Expanded(
      child: Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Icon(i, color: Colors.white, size: 22), const SizedBox(height: 6),
            Text(c, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 2),
            Text(l, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8))),
          ])));

  Widget _qAction(String l, IconData i, Color c, VoidCallback onTap) => Expanded(
      child: GestureDetector(onTap: onTap,
          child: Container(padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Column(children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(i, color: c, size: 22)),
                const SizedBox(height: 8),
                Text(l, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              ]))));
}

class JobRequestsScreen extends StatefulWidget {
  const JobRequestsScreen({super.key});
  @override
  State<JobRequestsScreen> createState() => _JobRequestsScreenState();
}

class _JobRequestsScreenState extends State<JobRequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tc;
  final _tabs = ['Pending', 'Accepted', 'Completed', 'All'];
  @override
  void initState() { super.initState(); _tc = TabController(length: _tabs.length, vsync: this); }
  @override
  void dispose() { _tc.dispose(); super.dispose(); }

  List<BookingModel> _filter(int i) {
    final mechanic = UserSession().currentUser;

    if (mechanic == null) return [];

    final j = BookingManager()
        .mechanicJobRequests
        .where((b) => b.mechanicId == mechanic.id)
        .toList();
    switch (i) { case 0: return j.where((x) => x.status == BookingStatus.pending).toList();
      case 1: return j.where((x) => x.status == BookingStatus.accepted).toList();
      case 2: return j.where((x) => x.status == BookingStatus.completed).toList(); default: return j; }
  }

  void _accept(BookingModel j) {
    setState(() => BookingManager().updateJobStatus(j.id, BookingStatus.accepted));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Accepted job from ${j.customerName}'),
        backgroundColor: AppTheme.successColor, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }

  void _reject(BookingModel j) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reject?'), content: Text('Reject ${j.customerName}\'s job?'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () { setState(() => BookingManager().updateJobStatus(j.id, BookingStatus.rejected)); Navigator.pop(ctx); },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor), child: const Text('Reject'))]));
  }

  void _complete(BookingModel j) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Complete Job?'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Mark ${j.customerName}\'s job as completed?'),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.priceColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.currency_rupee, color: AppTheme.priceColor, size: 18),
                Text('₹${j.price.toInt()} added to earnings', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.priceColor)),
              ])),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton.icon(onPressed: () {
            setState(() => BookingManager().updateJobStatus(j.id, BookingStatus.completed));
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Completed! ₹${j.price.toInt()} earned'),
                backgroundColor: AppTheme.priceColor, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          }, icon: const Icon(Icons.task_alt, size: 18), label: const Text('Complete'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.priceColor))]));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Text('Job Requests', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('${_filter(0).length} pending', style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary))),
      const SizedBox(height: 16),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: TabBar(controller: _tc, labelColor: Colors.white, unselectedLabelColor: AppTheme.textSecondary,
              indicator: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(10)),
              indicatorSize: TabBarIndicatorSize.tab, dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4), tabs: _tabs.map((t) => Tab(text: t, height: 38)).toList())),
      const SizedBox(height: 12),
      Expanded(child: TabBarView(controller: _tc, children: List.generate(_tabs.length, (i) {
        final list = _filter(i);
        if (list.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppTheme.textLight.withOpacity(0.5)), const SizedBox(height: 12),
          const Text('No jobs found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))]));
        return ListView.builder(padding: const EdgeInsets.only(bottom: 20), itemCount: list.length,
            itemBuilder: (ctx, j) {
              final job = list[j];
              return BookingCard(booking: job, showMechanicInfo: false, showCustomerInfo: true,
                  onAccept: job.status == BookingStatus.pending ? () => _accept(job) : null,
                  onReject: job.status == BookingStatus.pending ? () => _reject(job) : null,
                  onComplete: job.status == BookingStatus.accepted ? () => _complete(job) : null);
            });
      }))),
    ]));
  }
}

class MechanicProfileScreen extends StatefulWidget {
  const MechanicProfileScreen({super.key});
  @override
  State<MechanicProfileScreen> createState() => _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends State<MechanicProfileScreen> {
  late UserModel _mech;

  @override
  void initState() {
    super.initState();
    // Get from session — if null, create a blank one (never hardcode a name)
    _mech = UserSession().currentUser ?? const UserModel(
        id: '', name: '', email: '', phone: '', role: UserRole.mechanic);
  }

  void _toggle(bool v) {
    setState(() { _mech = _mech.copyWith(isAvailable: v); UserSession().currentUser = _mech; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(v ? 'You are now available' : 'You are now offline'),
        backgroundColor: v ? AppTheme.successColor : AppTheme.textSecondary,
        behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }

  @override
  Widget build(BuildContext context) {
    final totalEarnings = BookingManager().calculateTotalEarnings(_mech.id);
    final monthEarnings = BookingManager().calculateMonthEarnings(_mech.id);
    final todayEarnings = BookingManager().calculateTodayEarnings(_mech.id);

    // Dynamic initials — empty if no name
    final initials = UserSession().initials;
    final displayInitials = initials.isNotEmpty ? initials : '?';
    // Dynamic name — never hardcoded
    final displayName = _mech.name.trim().isNotEmpty ? _mech.name : 'Mechanic';

    return SafeArea(child: SingleChildScrollView(child: Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primaryDark, AppTheme.primaryColor]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32))),
          child: Column(children: [
            Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3)),
                child: Center(child: Text(displayInitials, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)))),
            const SizedBox(height: 16),
            // Dynamic name from session
            Text(displayName, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: Text(_mech.serviceType ?? 'General', style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500))),
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                child: Text('Your Rate: ₹${_mech.price}', style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _pStat('${_mech.rating}', 'Rating', Icons.star),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              _pStat('${_mech.jobsCompleted}', 'Jobs', Icons.task_alt),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              _pStat('₹$totalEarnings', 'Earned', Icons.currency_rupee),
            ]),
          ])),
      const SizedBox(height: 20),

      // Dynamic earnings summary
      Container(margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.priceColor.withOpacity(0.08), borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.priceColor.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.priceColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.account_balance_wallet, color: AppTheme.priceColor, size: 22)),
              const SizedBox(width: 12),
              const Text('Earnings Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 12),
            _earningsRow('Today', '₹$todayEarnings'),
            const SizedBox(height: 6),
            _earningsRow('This Month', '₹$monthEarnings'),
            const SizedBox(height: 6),
            _earningsRow('All Time', '₹$totalEarnings'),
            const SizedBox(height: 8),
            const Text('Only completed jobs are counted', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.textLight)),
          ])),
      const SizedBox(height: 20),

      // Availability toggle
      Container(margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (_mech.isAvailable ? AppTheme.successColor : AppTheme.errorColor).withOpacity(0.3))),
          child: Row(children: [
            Container(width: 48, height: 48,
                decoration: BoxDecoration(color: (_mech.isAvailable ? AppTheme.successColor : AppTheme.errorColor).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(_mech.isAvailable ? Icons.toggle_on : Icons.toggle_off,
                    color: _mech.isAvailable ? AppTheme.successColor : AppTheme.errorColor, size: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Availability', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(_mech.isAvailable ? 'Visible to customers' : 'Hidden', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ])),
            Switch(value: _mech.isAvailable, onChanged: _toggle, activeColor: AppTheme.successColor),
          ])),
      const SizedBox(height: 20),

      // Profile details
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Profile Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _detail(Icons.person_outline, 'Name', displayName),
            _detail(Icons.email_outlined, 'Email', _mech.email.isNotEmpty ? _mech.email : 'Not set'),
            _detail(Icons.phone_outlined, 'Phone', _mech.phone.isNotEmpty ? _mech.phone : 'Not set'),
            _detail(Icons.home_repair_service_outlined, 'Service', _mech.serviceType ?? 'General'),
            _detail(Icons.currency_rupee, 'Rate', '₹${_mech.price}'),
          ])),
      const SizedBox(height: 24),

      Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomButton(text: 'Logout', isOutlined: true, backgroundColor: AppTheme.errorColor,
              textColor: AppTheme.errorColor, icon: Icons.logout,
              onPressed: () => showDialog(context: context, builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Logout?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    ElevatedButton(onPressed: () { UserSession().logout();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false); },
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor), child: const Text('Logout'))])))),
      const SizedBox(height: 32),
    ])));
  }

  Widget _pStat(String v, String l, IconData i) => Column(children: [
    Row(children: [Icon(i, color: Colors.white, size: 16), const SizedBox(width: 4),
      Text(v, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))]),
    const SizedBox(height: 2),
    Text(l, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)))]);

  Widget _earningsRow(String l, String v) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(l, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
    Text(v, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.priceColor))]);

  Widget _detail(IconData i, String l, String v) => Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(i, color: l == 'Rate' ? AppTheme.priceColor : AppTheme.primaryColor, size: 22), const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l, style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
          Text(v, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: l == 'Rate' ? AppTheme.priceColor : AppTheme.textPrimary)),
        ]))]));
}

// ==========================================================================
// APP ENTRY POINT
// ==========================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BookingManager().loadBookings();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(const HouseholdServicesApp());
}

class HouseholdServicesApp extends StatelessWidget {
  const HouseholdServicesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'FixIt Pro', debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, home: const SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString("role");

    await Future.delayed(const Duration(seconds: 2));

    if (role != null) {
      if (role == "mechanic") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MechanicHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}