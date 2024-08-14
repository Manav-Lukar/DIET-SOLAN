import 'dart:convert';  // Import for JSON handling

class UserSession {
  static String? _token;
  static List<int>? _courses;
  static List<Map<String, dynamic>>? _classesTeaching; // For Faculty

  static void saveUserDetails(String responseBody, String role) {
    var parsedResponse = json.decode(responseBody);

    print('Parsed Response: $parsedResponse'); // Debugging: Check the entire response structure

    switch (role) {
      case 'Student':
        // Check if the key 'studentDetails' exists and has the required fields
        if (parsedResponse.containsKey('studentDetails') &&
            parsedResponse['studentDetails'] != null) {
          _token = parsedResponse['studentDetails']['token'];
          _courses = List<int>.from(parsedResponse['studentDetails']['courses'] ?? []);
        } else {
          print('Error: No studentDetails found in the response.');
        }
        break;

      case 'Parent':
        // Assuming 'parentsDetails' should have the same fields as 'studentDetails' (e.g., token and courses)
        if (parsedResponse.containsKey('parentsDetails') &&
            parsedResponse['parentsDetails'] != null) {
          _token = parsedResponse['parentsDetails']['token'];
          _courses = List<int>.from(parsedResponse['parentsDetails']['courses'] ?? []);
        } else {
          print('Error: No parentsDetails found in the response.');
        }
        break;

      case 'Faculty':
        if (parsedResponse.containsKey('facultyDetails') &&
            parsedResponse['facultyDetails'] != null) {
          _token = parsedResponse['facultyDetails']['token'];
          _classesTeaching = List<Map<String, dynamic>>.from(parsedResponse['facultyDetails']['classesTeaching'] ?? []);
        } else {
          print('Error: No facultyDetails found in the response.');
        }
        break;

      default:
        throw Exception("Unknown role: $role");
    }

    // Print statements for debugging
    print('Role: $role');
    print('Token: $_token');
    if (_courses != null) {
      print('Courses: $_courses');
    } else {
      print('Courses: Not available or empty.');
    }
    if (_classesTeaching != null) {
      print('Classes Teaching: $_classesTeaching');
    } else {
      print('Classes Teaching: Not available or empty.');
    }
  }

  static String? get token => _token;
  static List<int>? get courses => _courses;
  static List<Map<String, dynamic>>? get classesTeaching => _classesTeaching;
}
