import 'dart:convert';
import 'package:http/http.dart' as http;

/// Set via --dart-define=BASE_URL=https://your-render-service.onrender.com
String get baseUrl {
  return "https://fixit-pro-ypjk.onrender.com";
}

Uri apiUri(String path) => Uri.parse('$baseUrl$path');

String? authToken;

void setAuthToken(String? token) {
  authToken = token;
}

Map<String, String> get jsonHeaders {
  return {
    "Content-Type": "application/json",
    if (authToken != null && authToken!.isNotEmpty)
      "Authorization": "Bearer $authToken",
  };
}

Future<Map<String, dynamic>> registerUser(Map<String, dynamic> data) async {
  final res = await http.post(
    apiUri('/api/auth/register'),
    headers: jsonHeaders,
    body: jsonEncode(data),
  );

  if (res.statusCode != 201) {
    final body = jsonDecode(res.body);
    throw Exception(body['message'] ?? 'Registration failed');
  }

  return jsonDecode(res.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> loginUser({
  required String email,
  required String password,
  required String role,
}) async {
  final res = await http.post(
    apiUri('/api/auth/login'),
    headers: jsonHeaders,
    body: jsonEncode({"email": email, "password": password, "role": role}),
  );

  if (res.statusCode != 200) {
    final body = jsonDecode(res.body);
    throw Exception(body['message'] ?? 'Login failed');
  }

  return jsonDecode(res.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> getCurrentUser() async {
  final res = await http.get(apiUri('/api/users/me'), headers: jsonHeaders);

  if (res.statusCode != 200) {
    throw Exception('Failed to fetch profile: ${res.statusCode}');
  }

  return jsonDecode(res.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> updateCurrentUser(
  Map<String, dynamic> data,
) async {
  final res = await http.put(
    apiUri('/api/users/me'),
    headers: jsonHeaders,
    body: jsonEncode(data),
  );

  if (res.statusCode != 200) {
    final body = jsonDecode(res.body);
    throw Exception(body['message'] ?? 'Failed to update profile');
  }

  return jsonDecode(res.body) as Map<String, dynamic>;
}

Future<List<dynamic>> getMechanics({
  String? serviceName,
  String? state,
  String? city,
}) async {
  final params = <String, String>{};
  if (serviceName != null && serviceName.isNotEmpty) {
    params['serviceType'] = serviceName;
  }
  if (state != null && state.isNotEmpty) params['state'] = state;
  if (city != null && city.isNotEmpty) params['city'] = city;
  final query = params.isEmpty ? '' : '?${Uri(queryParameters: params).query}';
  final res = await http.get(apiUri('/api/mechanics$query'));

  if (res.statusCode != 200) {
    throw Exception('Failed to fetch mechanics: ${res.statusCode}');
  }

  return jsonDecode(res.body) as List<dynamic>;
}

Future<Map<String, dynamic>> upsertMechanic(Map<String, dynamic> data) async {
  final res = await http.post(
    apiUri('/api/mechanics'),
    headers: jsonHeaders,
    body: jsonEncode(data),
  );

  if (res.statusCode != 200 && res.statusCode != 201) {
    throw Exception('Failed to save mechanic: ${res.statusCode}');
  }

  return jsonDecode(res.body) as Map<String, dynamic>;
}

// ================== CREATE BOOKING ==================
Future<void> createBooking(Map<String, dynamic> data) async {
  try {
    final res = await http.post(
      Uri.parse("$baseUrl/api/bookings"),
      headers: jsonHeaders,
      body: jsonEncode(data),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create booking: ${res.statusCode}');
    }
  } catch (e) {
    rethrow;
  }
}

// ================== CUSTOMER BOOKINGS ==================
Future<List<dynamic>> getCustomerBookings(String userId) async {
  try {
    final res = await http.get(
      Uri.parse("$baseUrl/api/bookings/customer/$userId"),
      headers: jsonHeaders,
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch bookings: ${res.statusCode}');
    }

    return jsonDecode(res.body);
  } catch (e) {
    rethrow;
  }
}

// ================== MECHANIC BOOKINGS ==================
Future<List<dynamic>> getMechanicBookings(String mechanicId) async {
  try {
    final res = await http.get(
      Uri.parse("$baseUrl/api/bookings/mechanic/$mechanicId"),
      headers: jsonHeaders,
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch bookings: ${res.statusCode}');
    }

    return jsonDecode(res.body);
  } catch (e) {
    rethrow;
  }
}

// ================== UPDATE STATUS ==================
Future<Map<String, dynamic>> updateBookingStatus(
  String id,
  String status,
) async {
  try {
    final res = await http.put(
      Uri.parse("$baseUrl/api/bookings/$id"),
      headers: jsonHeaders,
      body: jsonEncode({"status": status}),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update booking: ${res.statusCode}');
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> verifyBookingCompletion(
  String id,
  String code,
) async {
  try {
    final res = await http.post(
      apiUri('/api/bookings/$id/verify-completion'),
      headers: jsonHeaders,
      body: jsonEncode({"code": code}),
    );

    if (res.statusCode != 200) {
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to verify completion');
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> rateMechanic(
  String bookingId,
  int rating,
  String? comment,
) async {
  final res = await http.post(
    apiUri('/api/bookings/$bookingId/rate-mechanic'),
    headers: jsonHeaders,
    body: jsonEncode({"rating": rating, "comment": comment}),
  );

  if (res.statusCode != 200) {
    throw Exception('Failed to rate mechanic: ${res.statusCode}');
  }

  return jsonDecode(res.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> rateCustomer(
  String bookingId,
  int rating,
  String? comment,
) async {
  final res = await http.post(
    apiUri('/api/bookings/$bookingId/rate-customer'),
    headers: jsonHeaders,
    body: jsonEncode({"rating": rating, "comment": comment}),
  );

  if (res.statusCode != 200) {
    throw Exception('Failed to rate customer: ${res.statusCode}');
  }

  return jsonDecode(res.body) as Map<String, dynamic>;
}
