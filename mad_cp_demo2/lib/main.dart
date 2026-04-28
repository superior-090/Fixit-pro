import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/api_service.dart' as api;

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
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
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
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

// ==========================================================================
// MODELS
// ==========================================================================

enum UserRole { customer, mechanic }

/// User model with individual price for mechanics
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
  final String? state;
  final String? city;
  final int price;
  final double distance;
  final String? completionCode;

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
    this.state,
    this.city,
    this.price = 0,
    this.distance = 0.0,
    this.completionCode,
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
    String? state,
    String? city,
    int? price,
    double? distance,
    String? completionCode,
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
      state: state ?? this.state,
      city: city ?? this.city,
      price: price ?? this.price,
      distance: distance ?? this.distance,
      completionCode: completionCode ?? this.completionCode,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      role: (json['role'] ?? 'mechanic') == 'customer'
          ? UserRole.customer
          : UserRole.mechanic,
      serviceType: json['serviceType']?.toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      jobsCompleted: (json['jobsCompleted'] as num?)?.toInt() ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      profileImageUrl: json['profileImageUrl']?.toString(),
      address: json['address']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      price: (json['price'] as num?)?.toInt() ?? 0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      completionCode: json['completionCode']?.toString(),
    );
  }
}

/// Service model - no price at category level
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

/// All available services
class ServiceData {
  ServiceData._();
  static const List<ServiceModel> services = [
    ServiceModel(
      id: 'plumbing',
      name: 'Plumbing',
      description: 'Fix leaks, pipes, taps, and drainage issues',
      icon: Icons.plumbing,
      color: Color(0xFF1565C0),
    ),
    ServiceModel(
      id: 'electrician',
      name: 'Electrician',
      description: 'Wiring, switches, fans, and electrical repairs',
      icon: Icons.electrical_services,
      color: Color(0xFFFF8F00),
    ),
    ServiceModel(
      id: 'ac_repair',
      name: 'AC Repair',
      description: 'AC servicing, gas refill, and installation',
      icon: Icons.ac_unit,
      color: Color(0xFF00ACC1),
    ),
    ServiceModel(
      id: 'washing_machine',
      name: 'Washing Machine',
      description: 'Washing machine repair and servicing',
      icon: Icons.local_laundry_service,
      color: Color(0xFF7B1FA2),
    ),
    ServiceModel(
      id: 'car_bike',
      name: 'Car/Bike Mechanic',
      description: 'Vehicle repair, servicing, and maintenance',
      icon: Icons.directions_car,
      color: Color(0xFFE53935),
    ),
    ServiceModel(
      id: 'carpentry',
      name: 'Carpentry',
      description: 'Furniture repair, assembly, and woodwork',
      icon: Icons.carpenter,
      color: Color(0xFF6D4C41),
    ),
    ServiceModel(
      id: 'painting',
      name: 'Painting',
      description: 'Wall painting, waterproofing, and touch-ups',
      icon: Icons.format_paint,
      color: Color(0xFF43A047),
    ),
    ServiceModel(
      id: 'deep_cleaning',
      name: 'Deep Cleaning',
      description: 'Home deep cleaning and sanitization',
      icon: Icons.cleaning_services,
      color: Color(0xFF00897B),
    ),
    ServiceModel(
      id: 'daily_cleaning',
      name: 'Daily Cleaning',
      description: 'Daily home cleaning and maintenance',
      icon: Icons.home_outlined,
      color: Color(0xFF5C6BC0),
    ),
    ServiceModel(
      id: 'home_sanitization',
      name: 'Sanitization',
      description: 'Complete home sanitization and disinfection',
      icon: Icons.sanitizer,
      color: Color(0xFF26A69A),
    ),
    ServiceModel(
      id: 'pest_control',
      name: 'Pest Control',
      description: 'Cockroach, termite, mosquito pest treatment',
      icon: Icons.bug_report,
      color: Color(0xFFEF6C00),
    ),
    ServiceModel(
      id: 'water_purifier',
      name: 'Water Purifier',
      description: 'RO repair, filter change, and AMC service',
      icon: Icons.water_drop,
      color: Color(0xFF0288D1),
    ),
  ];

  static List<String> get serviceTypeNames =>
      services.map((s) => s.name).toList();
}

enum BookingStatus {
  pending,
  accepted,
  inProgress,
  verificationPending,
  completed,
  cancelled,
  rejected,
}

/// Booking model - price comes from the individual mechanic
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
  final String state;
  final String city;
  final BookingStatus status;
  final double price;
  final String? notes;
  final DateTime createdAt;
  final String? customerPhone;
  final String? mechanicPhone;

  /// When the job was actually completed
  final DateTime? completedAt;
  final int? customerRating;
  final String? customerRatingComment;
  final int? mechanicRating;
  final String? mechanicRatingComment;

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
    required this.state,
    required this.city,
    required this.status,
    required this.price,
    this.notes,
    required this.createdAt,
    this.customerPhone,
    this.mechanicPhone,
    this.completedAt,
    this.customerRating,
    this.customerRatingComment,
    this.mechanicRating,
    this.mechanicRatingComment,
  });

  BookingModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? mechanicId,
    String? mechanicName,
    String? serviceId,
    String? serviceName,
    DateTime? bookingDate,
    String? timeSlot,
    String? address,
    String? state,
    String? city,
    BookingStatus? status,
    double? price,
    String? notes,
    DateTime? createdAt,
    String? customerPhone,
    String? mechanicPhone,
    DateTime? completedAt,
    int? customerRating,
    String? customerRatingComment,
    int? mechanicRating,
    String? mechanicRatingComment,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      mechanicId: mechanicId ?? this.mechanicId,
      mechanicName: mechanicName ?? this.mechanicName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      bookingDate: bookingDate ?? this.bookingDate,
      timeSlot: timeSlot ?? this.timeSlot,
      address: address ?? this.address,
      state: state ?? this.state,
      city: city ?? this.city,
      status: status ?? this.status,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      customerPhone: customerPhone ?? this.customerPhone,
      mechanicPhone: mechanicPhone ?? this.mechanicPhone,
      completedAt: completedAt ?? this.completedAt,
      customerRating: customerRating ?? this.customerRating,
      customerRatingComment:
          customerRatingComment ?? this.customerRatingComment,
      mechanicRating: mechanicRating ?? this.mechanicRating,
      mechanicRatingComment:
          mechanicRatingComment ?? this.mechanicRatingComment,
    );
  }

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.verificationPending:
        return 'Awaiting Customer Code';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.rejected:
        return 'Rejected';
    }
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      customerId: (json['customerId'] ?? '').toString(),
      customerName: (json['customerName'] ?? '').toString(),
      mechanicId: (json['mechanicId'] ?? '').toString(),
      mechanicName: (json['mechanicName'] ?? '').toString(),
      serviceId: (json['serviceId'] ?? '').toString(),
      serviceName: (json['serviceName'] ?? json['serviceType'] ?? '')
          .toString(),
      bookingDate: _parseDate(json['bookingDate']),
      timeSlot: (json['timeSlot'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      status: _parseStatus(json['status']),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      notes: json['notes']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      customerPhone: json['customerPhone']?.toString(),
      mechanicPhone: json['mechanicPhone']?.toString(),
      completedAt: json['completedAt'] == null
          ? null
          : _parseDate(json['completedAt']),
      customerRating: (json['customerRating'] as num?)?.toInt(),
      customerRatingComment: json['customerRatingComment']?.toString(),
      mechanicRating: (json['mechanicRating'] as num?)?.toInt(),
      mechanicRatingComment: json['mechanicRatingComment']?.toString(),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  static BookingStatus _parseStatus(dynamic value) {
    switch (value?.toString()) {
      case 'accepted':
        return BookingStatus.accepted;
      case 'inProgress':
        return BookingStatus.inProgress;
      case 'verificationPending':
        return BookingStatus.verificationPending;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'rejected':
        return BookingStatus.rejected;
      default:
        return BookingStatus.pending;
    }
  }
}

// ==========================================================================`r`n// GLOBAL MANAGERS
// ==========================================================================

/// Manages all bookings app-wide
/// Earnings are CALCULATED dynamically from completed jobs, never hardcoded
class BookingManager {
  static final BookingManager _instance = BookingManager._internal();
  factory BookingManager() => _instance;
  BookingManager._internal();

  final List<BookingModel> _customerBookings = [];
  final List<BookingModel> _mechanicJobRequests = [];
  int _bookingCounter = 0;

  List<BookingModel> get customerBookings =>
      List.unmodifiable(_customerBookings);
  List<BookingModel> get mechanicJobRequests =>
      List.unmodifiable(_mechanicJobRequests);

  void addBooking(BookingModel booking) {
    _customerBookings.insert(0, booking);
    _mechanicJobRequests.insert(0, booking);
  }

  void setCustomerBookings(List<BookingModel> bookings) {
    _customerBookings
      ..clear()
      ..addAll(bookings);
  }

  void setMechanicJobRequests(List<BookingModel> bookings) {
    _mechanicJobRequests
      ..clear()
      ..addAll(bookings);
  }

  void upsertBooking(BookingModel booking) {
    final custIndex = _customerBookings.indexWhere((b) => b.id == booking.id);
    if (custIndex == -1) {
      _customerBookings.insert(0, booking);
    } else {
      _customerBookings[custIndex] = booking;
    }

    final mechIndex = _mechanicJobRequests.indexWhere(
      (b) => b.id == booking.id,
    );
    if (mechIndex == -1) {
      _mechanicJobRequests.insert(0, booking);
    } else {
      _mechanicJobRequests[mechIndex] = booking;
    }
  }

  String generateBookingId() {
    _bookingCounter++;
    return 'BK${DateTime.now().millisecondsSinceEpoch}_$_bookingCounter';
  }

  /// Update job status and track completion time
  void updateJobStatus(String bookingId, BookingStatus newStatus) {
    final now = DateTime.now();

    final mechIndex = _mechanicJobRequests.indexWhere((j) => j.id == bookingId);
    if (mechIndex != -1) {
      _mechanicJobRequests[mechIndex] = _mechanicJobRequests[mechIndex]
          .copyWith(
            status: newStatus,
            completedAt: newStatus == BookingStatus.completed ? now : null,
          );
    }

    final custIndex = _customerBookings.indexWhere((b) => b.id == bookingId);
    if (custIndex != -1) {
      _customerBookings[custIndex] = _customerBookings[custIndex].copyWith(
        status: newStatus,
        completedAt: newStatus == BookingStatus.completed ? now : null,
      );
    }
  }

  // =====================================================================
  // DYNAMIC EARNINGS CALCULATION
  // Only COMPLETED jobs count toward earnings. Never hardcoded.
  // =====================================================================

  /// Calculate earnings for today from completed jobs only
  int calculateTodayEarnings(String mechanicId) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId &&
          job.status == BookingStatus.completed &&
          job.completedAt != null &&
          job.completedAt!.isAfter(todayStart) &&
          job.completedAt!.isBefore(todayEnd)) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  /// Calculate earnings for this week from completed jobs only
  int calculateWeekEarnings(String mechanicId) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );

    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId &&
          job.status == BookingStatus.completed &&
          job.completedAt != null &&
          job.completedAt!.isAfter(weekStartDate)) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  /// Calculate earnings for this month from completed jobs only
  int calculateMonthEarnings(String mechanicId) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId &&
          job.status == BookingStatus.completed &&
          job.completedAt != null &&
          job.completedAt!.isAfter(monthStart)) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  /// Calculate total all-time earnings from completed jobs
  int calculateTotalEarnings(String mechanicId) {
    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId &&
          job.status == BookingStatus.completed) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  /// Count completed jobs today
  int countTodayCompletedJobs(String mechanicId) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return _mechanicJobRequests
        .where(
          (j) =>
              j.mechanicId == mechanicId &&
              j.status == BookingStatus.completed &&
              j.completedAt != null &&
              j.completedAt!.isAfter(todayStart) &&
              j.completedAt!.isBefore(todayEnd),
        )
        .length;
  }

  /// Get yesterday's earnings for comparison percentage
  int calculateYesterdayEarnings(String mechanicId) {
    final now = DateTime.now();
    final yesterdayStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 1));
    final yesterdayEnd = DateTime(now.year, now.month, now.day);

    int total = 0;
    for (final job in _mechanicJobRequests) {
      if (job.mechanicId == mechanicId &&
          job.status == BookingStatus.completed &&
          job.completedAt != null &&
          job.completedAt!.isAfter(yesterdayStart) &&
          job.completedAt!.isBefore(yesterdayEnd)) {
        total += job.price.toInt();
      }
    }
    return total;
  }

  /// Calculate percentage change from yesterday
  String getEarningsChangePercent(String mechanicId) {
    final today = calculateTodayEarnings(mechanicId);
    final yesterday = calculateYesterdayEarnings(mechanicId);
    if (yesterday == 0 && today == 0) return '0%';
    if (yesterday == 0) return '+100%';
    final change = ((today - yesterday) / yesterday * 100).round();
    return change >= 0 ? '+$change%' : '$change%';
  }
}

/// Holds the currently logged-in user
class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  UserModel? currentUser;
  String? token;

  /// Get the user's first name, or fallback
  String get displayName {
    if (currentUser == null) return 'User';
    final name = currentUser!.name.trim();
    if (name.isEmpty) return 'User';
    return name.split(' ').first;
  }

  String get fullName {
    if (currentUser == null) return 'User';
    final name = currentUser!.name.trim();
    if (name.isEmpty) return 'User';
    return name;
  }

  String get initials {
    if (currentUser == null) return 'U';
    final name = currentUser!.name.trim();
    if (name.isEmpty) return 'U';
    return name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join();
  }

  /// Get mechanic's rate from their profile, not hardcoded
  int get mechanicRate {
    return currentUser?.price ?? 0;
  }

  /// Get mechanic ID for earnings queries
  String get mechanicId {
    return currentUser?.id ?? '';
  }

  void logout() {
    currentUser = null;
    token = null;
    api.setAuthToken(null);
  }

  void login(UserModel user, String jwtToken) {
    currentUser = user;
    token = jwtToken;
    api.setAuthToken(jwtToken);
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
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(text, overflow: TextOverflow.ellipsis, maxLines: 1),
              ),
            ],
          );

    if (isOutlined) {
      return SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: 52,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppTheme.primaryColor,
            side: BorderSide(
              color: backgroundColor ?? AppTheme.primaryColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: buttonChild,
        ),
      );
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: buttonChild,
      ),
    );
  }
}

/// Service card - no price at category level
class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: service.color.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(service.icon, color: service.color, size: 26),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  service.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mechanic card - shows individual price
class MechanicCard extends StatelessWidget {
  final UserModel mechanic;
  final VoidCallback onBookPressed;

  const MechanicCard({
    super.key,
    required this.mechanic,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      mechanic.name
                          .split(' ')
                          .map((n) => n.isNotEmpty ? n[0] : '')
                          .take(2)
                          .join(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mechanic.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: mechanic.isAvailable
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 2,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: AppTheme.warningColor,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                mechanic.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.work_outline,
                                size: 13,
                                color: AppTheme.textLight,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${mechanic.jobsCompleted} jobs',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: AppTheme.textLight,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${mechanic.distance} km',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: AppTheme.dividerColor.withOpacity(0.6)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Price',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${mechanic.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.priceColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: mechanic.isAvailable ? onBookPressed : null,
                    icon: Icon(
                      mechanic.isAvailable
                          ? Icons.calendar_today_outlined
                          : Icons.block,
                      size: 16,
                    ),
                    label: Text(mechanic.isAvailable ? 'Book Now' : 'Busy'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mechanic.isAvailable
                          ? AppTheme.accentColor
                          : Colors.grey[300],
                      foregroundColor: mechanic.isAvailable
                          ? Colors.white
                          : Colors.grey[600],
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Booking card
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool showMechanicInfo;
  final bool showCustomerInfo;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;
  final VoidCallback? onVerifyCompletion;
  final VoidCallback? onRate;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    this.showMechanicInfo = true,
    this.showCustomerInfo = false,
    this.onAccept,
    this.onReject,
    this.onComplete,
    this.onVerifyCompletion,
    this.onRate,
    this.onTap,
  });

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppTheme.warningColor;
      case BookingStatus.accepted:
        return AppTheme.primaryColor;
      case BookingStatus.inProgress:
        return AppTheme.accentColor;
      case BookingStatus.verificationPending:
        return AppTheme.warningColor;
      case BookingStatus.completed:
        return AppTheme.successColor;
      case BookingStatus.cancelled:
        return AppTheme.errorColor;
      case BookingStatus.rejected:
        return AppTheme.errorColor;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.accepted:
        return Icons.check_circle_outline;
      case BookingStatus.inProgress:
        return Icons.engineering;
      case BookingStatus.verificationPending:
        return Icons.lock_clock;
      case BookingStatus.completed:
        return Icons.task_alt;
      case BookingStatus.cancelled:
        return Icons.cancel_outlined;
      case BookingStatus.rejected:
        return Icons.block;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(booking.status);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final d = booking.bookingDate;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.06),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.home_repair_service, color: statusColor, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      booking.serviceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(booking.status),
                          size: 12,
                          color: statusColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          booking.statusText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showMechanicInfo) ...[
                    _buildInfoRow(
                      Icons.person,
                      'Mechanic',
                      booking.mechanicName,
                    ),
                    if (booking.mechanicRating != null) ...[
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        Icons.star,
                        'Rating',
                        '${booking.mechanicRating}/5${_commentSuffix(booking.mechanicRatingComment)}',
                      ),
                    ],
                    const SizedBox(height: 6),
                  ],
                  if (showCustomerInfo) ...[
                    _buildInfoRow(
                      Icons.person,
                      'Customer',
                      booking.customerName,
                    ),
                    if (booking.customerRating != null) ...[
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        Icons.star,
                        'Rating',
                        '${booking.customerRating}/5${_commentSuffix(booking.customerRatingComment)}',
                      ),
                    ],
                    const SizedBox(height: 6),
                  ],
                  _buildInfoRow(Icons.calendar_today, 'Date', dateStr),
                  const SizedBox(height: 6),
                  _buildInfoRow(Icons.access_time, 'Time', booking.timeSlot),
                  const SizedBox(height: 6),
                  _buildInfoRow(Icons.location_on, 'Address', booking.address),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    Icons.location_city,
                    'City',
                    '${booking.city}, ${booking.state}',
                  ),
                  if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.note, 'Notes', booking.notes!),
                  ],
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '₹${booking.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.priceColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action buttons
            if (booking.status == BookingStatus.pending &&
                (onAccept != null || onReject != null))
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Row(
                  children: [
                    if (onReject != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReject,
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Reject'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.errorColor,
                            side: const BorderSide(color: AppTheme.errorColor),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    if (onAccept != null && onReject != null)
                      const SizedBox(width: 10),
                    if (onAccept != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onAccept,
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            // Complete button for accepted jobs
            if (booking.status == BookingStatus.accepted && onComplete != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onComplete,
                    icon: const Icon(Icons.task_alt, size: 18),
                    label: const Text('Mark as Completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.priceColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            if (booking.status == BookingStatus.verificationPending &&
                onVerifyCompletion != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onVerifyCompletion,
                    icon: const Icon(Icons.pin_outlined, size: 18),
                    label: const Text('Enter Completion Code'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warningColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            if (booking.status == BookingStatus.completed && onRate != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onRate,
                    icon: const Icon(Icons.star_outline, size: 18),
                    label: const Text('Rate'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _commentSuffix(String? comment) {
    if (comment == null || comment.trim().isEmpty) return '';
    return ' • ${comment.trim()}';
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppTheme.textLight),
        const SizedBox(width: 6),
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showRatingDialog({
  required BuildContext context,
  required String title,
  required Future<void> Function(int rating, String? comment) onSubmit,
}) async {
  final commentController = TextEditingController();
  var rating = 5;

  await showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final value = index + 1;
                return IconButton(
                  onPressed: () => setDialogState(() => rating = value),
                  icon: Icon(
                    value <= rating ? Icons.star : Icons.star_border,
                    color: AppTheme.warningColor,
                  ),
                );
              }),
            ),
            TextField(
              controller: commentController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Comment optional',
                prefixIcon: Icon(Icons.rate_review_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await onSubmit(
                rating,
                commentController.text.trim().isEmpty
                    ? null
                    : commentController.text.trim(),
              );
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ),
  );

  commentController.dispose();
}

// ==========================================================================
// AUTH SCREENS
// ==========================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.customer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          final result = await api.loginUser(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            role: _selectedRole == UserRole.customer ? 'customer' : 'mechanic',
          );
          final user = UserModel.fromJson(
            result['user'] as Map<String, dynamic>,
          );
          UserSession().login(user, result['token'] as String);

          if (!mounted) return;
          setState(() => _isLoading = false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => user.role == UserRole.customer
                  ? const CustomerHomeScreen()
                  : const MechanicHomeScreen(),
            ),
          );
        } catch (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_repair_service,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'FixIt Pro',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your trusted household services partner',
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildRoleTab(
                          'Customer',
                          Icons.person,
                          UserRole.customer,
                        ),
                      ),
                      Expanded(
                        child: _buildRoleTab(
                          'Mechanic',
                          Icons.engineering,
                          UserRole.mechanic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Please enter your email';
                          if (!v.contains('@'))
                            return 'Please enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.textLight,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Please enter your password';
                          if (v.length < 6)
                            return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Login',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                        icon: Icons.login,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab(String label, IconData icon, UserRole role) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _stateController = TextEditingController(text: 'Maharashtra');
  final _cityController = TextEditingController(text: 'Pune');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _priceController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.customer;
  String? _selectedServiceType;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == UserRole.mechanic && _selectedServiceType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your service type'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          final result = await api.registerUser({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'password': _passwordController.text,
            'role': _selectedRole == UserRole.customer
                ? 'customer'
                : 'mechanic',
            'state': _stateController.text.trim(),
            'city': _cityController.text.trim(),
            'serviceType': _selectedServiceType,
            'price': _selectedRole == UserRole.mechanic
                ? (int.tryParse(_priceController.text.trim()) ?? 0)
                : 0,
          });
          final newUser = UserModel.fromJson(
            result['user'] as Map<String, dynamic>,
          );
          UserSession().login(newUser, result['token'] as String);

          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          if (_selectedRole == UserRole.customer) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MechanicHomeScreen()),
            );
          }
        } catch (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Join FixIt Pro today',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildRoleOption(
                      'Customer',
                      Icons.person,
                      UserRole.customer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRoleOption(
                      'Mechanic',
                      Icons.engineering,
                      UserRole.mechanic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) => (v == null || v.trim().length < 10)
                    ? 'Enter valid phone'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stateController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'State',
                  prefixIcon: Icon(Icons.map_outlined),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter state' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter city' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Enter valid email'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.textLight,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.textLight,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (v) => (v != _passwordController.text)
                    ? 'Passwords do not match'
                    : null,
              ),
              const SizedBox(height: 16),
              if (_selectedRole == UserRole.mechanic) ...[
                DropdownButtonFormField<String>(
                  value: _selectedServiceType,
                  decoration: const InputDecoration(
                    labelText: 'Service Type',
                    prefixIcon: Icon(Icons.home_repair_service_outlined),
                  ),
                  items: ServiceData.serviceTypeNames
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedServiceType = v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Your Service Price (₹)',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  validator: (v) {
                    if (_selectedRole == UserRole.mechanic &&
                        (v == null ||
                            int.tryParse(v.trim()) == null ||
                            int.parse(v.trim()) <= 0))
                      return 'Enter valid price';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 8),
              CustomButton(
                text: 'Create Account',
                onPressed: _handleRegister,
                isLoading: _isLoading,
                icon: Icons.person_add,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String label, IconData icon, UserRole role) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textLight,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCustomerBookings();
  }

  Future<void> _loadCustomerBookings() async {
    final user = UserSession().currentUser;
    if (user == null) return;

    try {
      final remoteBookings = await api.getCustomerBookings(user.id);
      BookingManager().setCustomerBookings(
        remoteBookings
            .map(
              (booking) =>
                  BookingModel.fromJson(booking as Map<String, dynamic>),
            )
            .toList(),
      );
      if (mounted) setState(() {});
    } catch (_) {
      // The booking tab shows its own API error; keep home usable.
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePage(),
      const BookingHistoryScreen(),
      _buildProfilePage(),
    ];
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    final userName = UserSession().displayName;
    final bookings = BookingManager().customerBookings;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $userName 👋',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'What service do you need today?',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Our Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cols = constraints.maxWidth > 400 ? 4 : 3;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: ServiceData.services.length,
                    itemBuilder: (context, index) {
                      final service = ServiceData.services[index];
                      return ServiceCard(
                        service: service,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceListScreen(service: service),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Recent Bookings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (bookings.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 40),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 56,
                      color: AppTheme.textLight.withOpacity(0.4),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No bookings yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...bookings
                  .take(3)
                  .map(
                    (b) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: b.status == BookingStatus.completed
                                  ? AppTheme.successColor
                                  : b.status == BookingStatus.pending
                                  ? AppTheme.warningColor
                                  : AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.serviceName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${b.mechanicName} • ₹${b.price.toInt()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (b.status == BookingStatus.completed
                                          ? AppTheme.successColor
                                          : AppTheme.warningColor)
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              b.statusText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: b.status == BookingStatus.completed
                                    ? AppTheme.successColor
                                    : AppTheme.warningColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    final session = UserSession();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryColor, width: 3),
              ),
              child: Center(
                child: Text(
                  session.initials,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              session.fullName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              session.currentUser?.email ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              (session.currentUser?.phone.trim().isNotEmpty ?? false)
                  ? session.currentUser!.phone
                  : 'Phone not set',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${session.currentUser?.city ?? 'City not set'}, ${session.currentUser?.state ?? 'State not set'}',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            if (session.currentUser?.completionCode != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.warningColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pin_outlined,
                      color: AppTheme.warningColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Completion Code: ${session.currentUser!.completionCode}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final updated = await Navigator.push<UserModel>(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditProfileScreen(user: session.currentUser!),
                    ),
                  );
                  if (updated != null)
                    setState(() => UserSession().currentUser = updated);
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  UserSession().logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (r) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: AppTheme.errorColor),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.errorColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceListScreen extends StatefulWidget {
  final ServiceModel service;
  const ServiceListScreen({super.key, required this.service});
  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  String _sortBy = 'rating';
  bool _showOnlyAvailable = false;
  bool _isLoading = true;
  String? _errorMessage;
  List<UserModel> _mechanics = [];

  @override
  void initState() {
    super.initState();
    _loadMechanics();
  }

  Future<void> _loadMechanics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUser = UserSession().currentUser;
      final userState = currentUser?.state?.trim() ?? '';
      final userCity = currentUser?.city?.trim() ?? '';
      if (userState.isEmpty || userCity.isEmpty) {
        throw Exception('Please add state and city in your profile first.');
      }
      final data = await api.getMechanics(
        serviceName: widget.service.name,
        state: userState,
        city: userCity,
      );
      if (!mounted) return;
      setState(() {
        _mechanics = data
            .map((m) => UserModel.fromJson(m as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mechanics = [];
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  List<UserModel> get _filteredMechanics {
    List<UserModel> mechanics = List.from(_mechanics);
    if (_showOnlyAvailable)
      mechanics = mechanics.where((m) => m.isAvailable).toList();
    switch (_sortBy) {
      case 'rating':
        mechanics.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        mechanics.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        mechanics.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'distance':
        mechanics.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      default:
        break;
    }
    return mechanics;
  }

  @override
  Widget build(BuildContext context) {
    final mechanics = _filteredMechanics;
    final priceRange = _getPriceRange(mechanics);
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: Text(widget.service.name),
        actions: [
          IconButton(
            icon: Icon(
              _showOnlyAvailable ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            onPressed: () =>
                setState(() => _showOnlyAvailable = !_showOnlyAvailable),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.service.color.withOpacity(0.08),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.service.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget.service.icon,
                    color: widget.service.color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.service.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        widget.service.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (priceRange.isNotEmpty)
                        Text(
                          'Price range: $priceRange',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: widget.service.color,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Text(
                  '${mechanics.length} found',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (v) => setState(() => _sortBy = v),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'rating', child: Text('Rating')),
                    const PopupMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low→High'),
                    ),
                    const PopupMenuItem(
                      value: 'price_high',
                      child: Text('Price: High→Low'),
                    ),
                    const PopupMenuItem(
                      value: 'distance',
                      child: Text('Distance'),
                    ),
                  ],
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sort, size: 18, color: AppTheme.primaryColor),
                      SizedBox(width: 4),
                      Text(
                        'Sort',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? _MechanicsErrorState(
                    message: _errorMessage!,
                    onRetry: _loadMechanics,
                  )
                : mechanics.isEmpty
                ? const Center(
                    child: Text(
                      'No mechanics available',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: mechanics.length,
                    itemBuilder: (context, index) => MechanicCard(
                      mechanic: mechanics[index],
                      onBookPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingScreen(
                            service: widget.service,
                            mechanic: mechanics[index],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _getPriceRange(List<UserModel> mechanics) {
    if (mechanics.isEmpty) return '';
    final prices = mechanics.map((m) => m.price).toList()..sort();
    if (prices.first == prices.last) return '₹${prices.first}';
    return '₹${prices.first} - ₹${prices.last}';
  }
}

class _MechanicsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MechanicsErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 52,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 12),
            const Text(
              'Could not load mechanics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingScreen extends StatefulWidget {
  final ServiceModel service;
  final UserModel mechanic;
  const BookingScreen({
    super.key,
    required this.service,
    required this.mechanic,
  });
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTimeSlot;
  bool _isLoading = false;
  final List<String> _timeSlots = [
    '8-10 AM',
    '10-12 PM',
    '12-2 PM',
    '2-4 PM',
    '4-6 PM',
    '6-8 PM',
  ];

  int get platformFee => 29;
  int get totalPrice => widget.mechanic.price + platformFee;

  @override
  void initState() {
    super.initState();
    final user = UserSession().currentUser;
    _stateController.text = user?.state ?? '';
    _cityController.text = user?.city ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _confirmBooking() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a time slot'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () async {
      final session = UserSession();
      final booking = BookingModel(
        id: BookingManager().generateBookingId(),
        customerId: session.currentUser?.id ?? 'guest',
        customerName: session.fullName,
        mechanicId: widget.mechanic.id,
        mechanicName: widget.mechanic.name,
        serviceId: widget.service.id,
        serviceName: widget.service.name,
        bookingDate: _selectedDate,
        timeSlot: _selectedTimeSlot!,
        address: _addressController.text.trim(),
        state: _stateController.text.trim(),
        city: _cityController.text.trim(),
        status: BookingStatus.pending,
        price: totalPrice.toDouble(),
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        createdAt: DateTime.now(),
        customerPhone: session.currentUser?.phone,
        mechanicPhone: widget.mechanic.phone,
      );

      try {
        await api.createBooking({
          'id': booking.id,
          'customerId': booking.customerId,
          'customerName': booking.customerName,
          'customerPhone': booking.customerPhone,
          'mechanicId': booking.mechanicId,
          'mechanicName': booking.mechanicName,
          'mechanicPhone': booking.mechanicPhone,
          'serviceId': booking.serviceId,
          'serviceName': booking.serviceName,
          'serviceType': booking.serviceName,
          'bookingDate': booking.bookingDate.toIso8601String(),
          'timeSlot': booking.timeSlot,
          'address': booking.address,
          'state': booking.state,
          'city': booking.city,
          'status': 'pending',
          'price': booking.price,
          'notes': booking.notes,
          'createdAt': booking.createdAt.toIso8601String(),
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      if (!mounted) return;
      setState(() => _isLoading = false);
      BookingManager().addBooking(booking);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 50,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ₹$totalPrice',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.priceColor,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Done',
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dateStr =
        '${days[_selectedDate.weekday - 1]}, ${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(title: const Text('Book Service')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: widget.service.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            widget.service.icon,
                            color: widget.service.color,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.service.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'by ${widget.mechanic.name}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(height: 1, color: AppTheme.dividerColor),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Mechanic's Rate",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '₹${widget.mechanic.price}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.priceColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _sectionTitle('Select Date'),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppTheme.primaryColor,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          dateStr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.edit,
                        color: AppTheme.textLight,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _sectionTitle('Select Time Slot'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _timeSlots.map((slot) {
                    final sel = _selectedTimeSlot == slot;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTimeSlot = slot),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: sel ? AppTheme.primaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sel
                                ? AppTheme.primaryColor
                                : AppTheme.dividerColor,
                          ),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: sel ? Colors.white : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              _sectionTitle('Address'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter complete address',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter address' : null,
                ),
              ),
              const SizedBox(height: 20),
              _sectionTitle('Service Location'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Icons.map_outlined),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter state'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter city'
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _sectionTitle('Notes (Optional)'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Any instructions...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Icon(Icons.note_outlined),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.priceColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.priceColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${widget.mechanic.name}\'s charge',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        Text(
                          '₹${widget.mechanic.price}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Platform Fee',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '₹29',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '₹$totalPrice',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.priceColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  text: 'Confirm Booking • ₹$totalPrice',
                  onPressed: _confirmBooking,
                  isLoading: _isLoading,
                  icon: Icons.check_circle_outline,
                  backgroundColor: AppTheme.accentColor,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    ),
  );
}

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});
  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = ['All', 'Pending', 'Accepted', 'Completed'];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    final user = UserSession().currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
        _errorMessage = 'User not logged in';
      });
      return;
    }

    try {
      final remoteBookings = await api.getCustomerBookings(user.id);
      BookingManager().setCustomerBookings(
        remoteBookings
            .map(
              (booking) =>
                  BookingModel.fromJson(booking as Map<String, dynamic>),
            )
            .toList(),
      );
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _verifyCompletion(BookingModel booking) async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Completion'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(
            labelText: '4 digit completion code',
            prefixIcon: Icon(Icons.pin_outlined),
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (code == null || code.length != 4) return;

    try {
      final updated = await api.verifyBookingCompletion(booking.id, code);
      BookingManager().upsertBooking(BookingModel.fromJson(updated));
      if (mounted) setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  List<BookingModel> _filter(int i) {
    final b = BookingManager().customerBookings;
    switch (i) {
      case 1:
        return b
            .where(
              (x) =>
                  x.status == BookingStatus.pending ||
                  x.status == BookingStatus.verificationPending,
            )
            .toList();
      case 2:
        return b.where((x) => x.status == BookingStatus.accepted).toList();
      case 3:
        return b.where((x) => x.status == BookingStatus.completed).toList();
      default:
        return b;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'My Bookings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: _loadBookings,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.textSecondary,
              indicator: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4),
              tabs: _tabs.map((t) => Tab(text: t, height: 38)).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text('Error: $_errorMessage'))
                : RefreshIndicator(
                    onRefresh: _loadBookings,
                    child: TabBarView(
                      controller: _tabController,
                      children: List.generate(_tabs.length, (i) {
                        final list = _filter(i);
                        if (list.isEmpty) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 64,
                                        color: AppTheme.textLight.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'No bookings yet',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: list.length,
                          itemBuilder: (ctx, j) {
                            final booking = list[j];
                            return BookingCard(
                              booking: booking,
                              showMechanicInfo: true,
                              onVerifyCompletion:
                                  booking.status ==
                                      BookingStatus.verificationPending
                                  ? () => _verifyCompletion(booking)
                                  : null,
                              onRate:
                                  booking.status == BookingStatus.completed &&
                                      booking.mechanicRating == null
                                  ? () => showRatingDialog(
                                      context: context,
                                      title: 'Rate ${booking.mechanicName}',
                                      onSubmit: (rating, comment) async {
                                        await api.rateMechanic(
                                          booking.id,
                                          rating,
                                          comment,
                                        );
                                        await _loadBookings();
                                      },
                                    )
                                  : null,
                            );
                          },
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// MECHANIC SCREENS
// All earnings are DYNAMICALLY CALCULATED from completed jobs.
// Name comes from UserSession, never hardcoded.
// ==========================================================================

class MechanicHomeScreen extends StatefulWidget {
  const MechanicHomeScreen({super.key});
  @override
  State<MechanicHomeScreen> createState() => _MechanicHomeScreenState();
}

class _MechanicHomeScreenState extends State<MechanicHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMechanicBookings();
  }

  Future<void> _loadMechanicBookings() async {
    final user = UserSession().currentUser;
    if (user == null) return;

    try {
      final remoteBookings = await api.getMechanicBookings(user.id);
      BookingManager().setMechanicJobRequests(
        remoteBookings
            .map(
              (booking) =>
                  BookingModel.fromJson(booking as Map<String, dynamic>),
            )
            .toList(),
      );
      if (mounted) setState(() {});
    } catch (_) {
      // The jobs tab shows its own API error; keep dashboard usable.
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _MechanicDashboard(onNavigate: (i) => setState(() => _currentIndex = i)),
      const JobRequestsScreen(),
      const MechanicProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// The mechanic dashboard
/// FIX 1: Name comes from UserSession().displayName - NEVER hardcoded
/// FIX 2: Earnings are CALCULATED from completed jobs via BookingManager
class _MechanicDashboard extends StatelessWidget {
  final void Function(int) onNavigate;
  const _MechanicDashboard({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    // FIX: Get name from user session, not hardcoded
    final mechanicName = UserSession().displayName;
    final mechanic = UserSession().currentUser;
    final mechanicId = UserSession().mechanicId;
    final rate = UserSession().mechanicRate;
    final isAvailable = mechanic?.isAvailable ?? false;

    final jobRequests = BookingManager().mechanicJobRequests;
    final pendingJobs = jobRequests
        .where((j) => j.status == BookingStatus.pending)
        .length;
    final acceptedJobs = jobRequests
        .where((j) => j.status == BookingStatus.accepted)
        .length;
    final completedJobs = jobRequests
        .where((j) => j.status == BookingStatus.completed)
        .length;

    // FIX: All earnings DYNAMICALLY CALCULATED from completed jobs
    final todayEarnings = BookingManager().calculateTodayEarnings(mechanicId);
    final weekEarnings = BookingManager().calculateWeekEarnings(mechanicId);
    final monthEarnings = BookingManager().calculateMonthEarnings(mechanicId);
    final todayCompletedCount = BookingManager().countTodayCompletedJobs(
      mechanicId,
    );
    final earningsChangePercent = BookingManager().getEarningsChangePercent(
      mechanicId,
    );
    final isPositiveChange =
        earningsChangePercent.startsWith('+') || earningsChangePercent == '0%';

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Header with DYNAMIC name ----
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.primaryColor],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FIX: Dynamic name from UserSession, not "Rajesh"
                            Text(
                              mechanic != null
                                  ? 'Hello, $mechanicName 🔧'
                                  : 'Hello 👋',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isAvailable
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // FIX: Rate from mechanic profile, not hardcoded
                                Text(
                                  isAvailable
                                      ? 'Available • ₹$rate/service'
                                      : 'Not Available',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                              ),
                            ),
                            if (pendingJobs > 0)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.errorColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$pendingJobs',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _statCard('Pending', '$pendingJobs', Icons.schedule),
                      const SizedBox(width: 12),
                      _statCard(
                        'Accepted',
                        '$acceptedJobs',
                        Icons.check_circle_outline,
                      ),
                      const SizedBox(width: 12),
                      _statCard('Completed', '$completedJobs', Icons.task_alt),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ---- DYNAMIC Earnings Card ----
            // FIX: All values calculated from actual completed jobs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentColor, AppTheme.accentLight],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's Earnings",
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        // FIX: Dynamic percentage based on actual earnings comparison
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            earningsChangePercent,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isPositiveChange
                                  ? Colors.white
                                  : const Color(0xFFFFCDD2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // FIX: Dynamic earnings from completed jobs ONLY
                    Text(
                      todayEarnings > 0 ? '₹$todayEarnings' : '₹0',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // FIX: Dynamic completed count
                    Text(
                      '$todayCompletedCount jobs completed today',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(height: 1, color: Colors.white.withOpacity(0.3)),
                    const SizedBox(height: 12),
                    // FIX: Dynamic week and month earnings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'This Week',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹$weekEarnings',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'This Month',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹$monthEarnings',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Rate',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            // FIX: Rate from profile
                            Text(
                              '₹$rate',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick actions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _quickAction(
                    'View Jobs',
                    Icons.work_outline,
                    AppTheme.primaryColor,
                    () => onNavigate(1),
                  ),
                  const SizedBox(width: 12),
                  _quickAction(
                    'My Profile',
                    Icons.person_outline,
                    AppTheme.accentColor,
                    () => onNavigate(2),
                  ),
                  const SizedBox(width: 12),
                  _quickAction(
                    'Earnings',
                    Icons.account_balance_wallet_outlined,
                    AppTheme.successColor,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Total earnings: ₹${BookingManager().calculateTotalEarnings(mechanicId)}',
                          ),
                          backgroundColor: AppTheme.priceColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent activity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigate(1),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            if (jobRequests.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 40),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.work_off_outlined,
                      size: 56,
                      color: AppTheme.textLight.withOpacity(0.4),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No job requests yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Earnings will update when you complete jobs',
                      style: TextStyle(fontSize: 12, color: AppTheme.textLight),
                    ),
                  ],
                ),
              )
            else
              ...jobRequests.take(3).map((job) => _activityTile(job)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String count, IconData icon) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _quickAction(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _activityTile(BookingModel job) {
    final sc = job.status == BookingStatus.pending
        ? AppTheme.warningColor
        : job.status == BookingStatus.accepted
        ? AppTheme.primaryColor
        : job.status == BookingStatus.completed
        ? AppTheme.successColor
        : AppTheme.textLight;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: sc.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.home_repair_service, color: sc, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${job.serviceName} • ${job.timeSlot}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${job.price.toInt()}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.priceColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: sc.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  job.statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: sc,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Job requests screen with accept/reject AND complete functionality
class JobRequestsScreen extends StatefulWidget {
  const JobRequestsScreen({super.key});
  @override
  State<JobRequestsScreen> createState() => _JobRequestsScreenState();
}

class _JobRequestsScreenState extends State<JobRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = ['Pending', 'Accepted', 'Completed', 'All'];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadJobs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    final user = UserSession().currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
        _errorMessage = 'User not logged in';
      });
      return;
    }

    try {
      final remoteBookings = await api.getMechanicBookings(user.id);
      BookingManager().setMechanicJobRequests(
        remoteBookings
            .map(
              (booking) =>
                  BookingModel.fromJson(booking as Map<String, dynamic>),
            )
            .toList(),
      );
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = e.toString();
      });
    }
  }

  List<BookingModel> _filter(int i) {
    final jobs = BookingManager().mechanicJobRequests;
    switch (i) {
      case 0:
        return jobs.where((j) => j.status == BookingStatus.pending).toList();
      case 1:
        return jobs.where((j) => j.status == BookingStatus.accepted).toList();
      case 2:
        return jobs.where((j) => j.status == BookingStatus.completed).toList();
      default:
        return jobs;
    }
  }

  Future<void> _acceptJob(BookingModel job) async {
    final updated = await api.updateBookingStatus(job.id, 'accepted');
    setState(
      () => BookingManager().upsertBooking(BookingModel.fromJson(updated)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted job from ${job.customerName}'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _rejectJob(BookingModel job) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reject Job?'),
        content: Text('Reject job from ${job.customerName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updated = await api.updateBookingStatus(job.id, 'rejected');
              setState(
                () => BookingManager().upsertBooking(
                  BookingModel.fromJson(updated),
                ),
              );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  /// Mark job as completed - this updates earnings dynamically
  void _completeJob(BookingModel job) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Complete Job?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Mark job for ${job.customerName} as completed?'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.priceColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    color: AppTheme.priceColor,
                    size: 18,
                  ),
                  Text(
                    '₹${job.price.toInt()} will be added to your earnings',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.priceColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final updated = await api.updateBookingStatus(
                job.id,
                'completed',
              );
              setState(
                () => BookingManager().upsertBooking(
                  BookingModel.fromJson(updated),
                ),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Waiting for customer completion code'),
                  backgroundColor: AppTheme.priceColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.task_alt, size: 18),
            label: const Text('Complete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.priceColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Job Requests',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: _loadJobs,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${_filter(0).length} pending',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.textSecondary,
              indicator: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4),
              tabs: _tabs.map((t) => Tab(text: t, height: 38)).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text('Error: $_errorMessage'))
                : RefreshIndicator(
                    onRefresh: _loadJobs,
                    child: TabBarView(
                      controller: _tabController,
                      children: List.generate(_tabs.length, (i) {
                        final jobs = _filter(i);
                        if (jobs.isEmpty) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 64,
                                        color: AppTheme.textLight.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'No jobs found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: jobs.length,
                          itemBuilder: (ctx, j) {
                            final job = jobs[j];
                            return BookingCard(
                              booking: job,
                              showMechanicInfo: false,
                              showCustomerInfo: true,
                              onAccept: job.status == BookingStatus.pending
                                  ? () => _acceptJob(job)
                                  : null,
                              onReject: job.status == BookingStatus.pending
                                  ? () => _rejectJob(job)
                                  : null,
                              onComplete: job.status == BookingStatus.accepted
                                  ? () => _completeJob(job)
                                  : null,
                              onRate:
                                  job.status == BookingStatus.completed &&
                                      job.customerRating == null
                                  ? () => showRatingDialog(
                                      context: context,
                                      title: 'Rate ${job.customerName}',
                                      onSubmit: (rating, comment) async {
                                        await api.rateCustomer(
                                          job.id,
                                          rating,
                                          comment,
                                        );
                                        await _loadJobs();
                                      },
                                    )
                                  : null,
                            );
                          },
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Mechanic profile screen
class MechanicProfileScreen extends StatefulWidget {
  const MechanicProfileScreen({super.key});
  @override
  State<MechanicProfileScreen> createState() => _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends State<MechanicProfileScreen> {
  late UserModel _mechanic;

  @override
  void initState() {
    super.initState();
    _mechanic =
        UserSession().currentUser ??
        const UserModel(
          id: '',
          name: 'Mechanic',
          email: '',
          phone: '',
          role: UserRole.mechanic,
          serviceType: 'General',
          state: 'Maharashtra',
          city: 'Pune',
        );
  }

  void _toggleAvailability(bool v) {
    setState(() {
      _mechanic = _mechanic.copyWith(isAvailable: v);
      UserSession().currentUser = _mechanic;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(v ? 'You are now available' : 'You are now offline'),
        backgroundColor: v ? AppTheme.successColor : AppTheme.textSecondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalEarnings = BookingManager().calculateTotalEarnings(_mechanic.id);
    final monthEarnings = BookingManager().calculateMonthEarnings(_mechanic.id);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.primaryColor],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        UserSession().initials,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // FIX: Dynamic name
                  Text(
                    _mechanic.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _mechanic.serviceType ?? 'General',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // FIX: Dynamic rate
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Your Rate: ₹${_mechanic.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _stat('${_mechanic.rating}', 'Rating', Icons.star),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _stat(
                        '${_mechanic.jobsCompleted}',
                        'Jobs',
                        Icons.task_alt,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      // FIX: Dynamic total earnings
                      _stat('₹$totalEarnings', 'Earned', Icons.currency_rupee),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // FIX: Dynamic earnings summary card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.priceColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.priceColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.priceColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: AppTheme.priceColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Earnings Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '₹${BookingManager().calculateTodayEarnings(_mechanic.id)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.priceColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'This Month',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '₹$monthEarnings',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.priceColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Time',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '₹$totalEarnings',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.priceColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Only completed jobs are counted',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Availability toggle
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      (_mechanic.isAvailable
                              ? AppTheme.successColor
                              : AppTheme.errorColor)
                          .withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          (_mechanic.isAvailable
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _mechanic.isAvailable
                          ? Icons.toggle_on
                          : Icons.toggle_off,
                      color: _mechanic.isAvailable
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Availability',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          _mechanic.isAvailable
                              ? 'Visible to customers'
                              : 'Hidden',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _mechanic.isAvailable,
                    onChanged: _toggleAvailability,
                    activeColor: AppTheme.successColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  _detail(Icons.person_outline, 'Name', _mechanic.name),
                  _detail(Icons.email_outlined, 'Email', _mechanic.email),
                  _detail(Icons.phone_outlined, 'Phone', _mechanic.phone),
                  _detail(
                    Icons.location_city_outlined,
                    'Location',
                    '${_mechanic.city ?? 'Not set'}, ${_mechanic.state ?? 'Not set'}',
                  ),
                  _detail(
                    Icons.home_repair_service_outlined,
                    'Service',
                    _mechanic.serviceType ?? 'General',
                  ),
                  _detail(Icons.currency_rupee, 'Rate', '₹${_mechanic.price}'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                text: 'Edit Profile',
                icon: Icons.edit_outlined,
                onPressed: () async {
                  final updated = await Navigator.push<UserModel>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(user: _mechanic),
                    ),
                  );
                  if (updated != null) {
                    setState(() {
                      _mechanic = updated;
                      UserSession().currentUser = updated;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                text: 'Logout',
                isOutlined: true,
                backgroundColor: AppTheme.errorColor,
                textColor: AppTheme.errorColor,
                icon: Icons.logout,
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          UserSession().logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (r) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _stat(String v, String l, IconData i) => Column(
    children: [
      Row(
        children: [
          Icon(i, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            v,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
      const SizedBox(height: 2),
      Text(
        l,
        style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
      ),
    ],
  );

  Widget _detail(IconData i, String l, String v) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(
          i,
          color: l == 'Rate' ? AppTheme.priceColor : AppTheme.primaryColor,
          size: 22,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l,
                style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
              ),
              Text(
                v,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: l == 'Rate'
                      ? AppTheme.priceColor
                      : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _stateController;
  late final TextEditingController _cityController;
  late final TextEditingController _priceController;
  late String? _serviceType;
  bool _saving = false;

  bool get _isMechanic => widget.user.role == UserRole.mechanic;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _emailController = TextEditingController(text: widget.user.email);
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _stateController = TextEditingController(text: widget.user.state ?? '');
    _cityController = TextEditingController(text: widget.user.city ?? '');
    _priceController = TextEditingController(
      text: widget.user.price > 0 ? widget.user.price.toString() : '',
    );
    _serviceType = widget.user.serviceType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final updated = widget.user.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      state: _stateController.text.trim(),
      city: _cityController.text.trim(),
      serviceType: _isMechanic ? _serviceType : widget.user.serviceType,
      price: _isMechanic
          ? int.parse(_priceController.text.trim())
          : widget.user.price,
    );

    try {
      UserModel result = updated;
      if (_isMechanic) {
        final remote = await api.upsertMechanic({
          'id': updated.id,
          'name': updated.name,
          'email': updated.email,
          'phone': updated.phone,
          'serviceType': updated.serviceType,
          'state': updated.state,
          'city': updated.city,
          'address': updated.address,
          'price': updated.price,
          'isAvailable': updated.isAvailable,
        });
        result = UserModel.fromJson(remote);
      }
      UserSession().currentUser = result;
      if (!mounted) return;
      Navigator.pop(context, result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile update failed: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) => (v == null || v.trim().length < 10)
                    ? 'Enter a valid phone number'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter state'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter city' : null,
                    ),
                  ),
                ],
              ),
              if (_isMechanic) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _serviceType,
                  decoration: const InputDecoration(
                    labelText: 'Service Type',
                    prefixIcon: Icon(Icons.home_repair_service_outlined),
                  ),
                  items: ServiceData.serviceTypeNames
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => _serviceType = v),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Select a service' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Service Price',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  validator: (v) {
                    final price = int.tryParse(v?.trim() ?? '');
                    if (price == null || price <= 0)
                      return 'Enter a valid price';
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 28),
              CustomButton(
                text: 'Save Changes',
                icon: Icons.check_circle_outline,
                isLoading: _saving,
                onPressed: _saving ? () {} : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// APP ENTRY POINT
// ==========================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const HouseholdServicesApp());
}

class HouseholdServicesApp extends StatelessWidget {
  const HouseholdServicesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIt Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
