import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class BookingService {
  Future<bool> createBooking(int userId, String service, String date, String time) async {
    final url = Uri.parse('${AuthService.baseUrl}/booking/create');
    
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "service_type": service,
          "booking_date": date,
          "booking_time": time,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Error Create Booking: $e");
      return false;
    }
  }

  Future<List<dynamic>> getHistory(int userId) async {
    final url = Uri.parse('${AuthService.baseUrl}/booking/list/$userId');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      }
      return [];
    } catch (e) {
      print("Error Get History: $e");
      return [];
    }
  }
}