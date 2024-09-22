import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseService {
  final String token;

  CourseService(this.token);

  Future<void> fetchCourses() async {
    final url = Uri.parse('https://student-attendance-system-ckb1.onrender.com/api/course/show-courses');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Print response details
      print('Request URL: $url');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Fetched courses: $data');
      } else {
        print('Failed to fetch courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
