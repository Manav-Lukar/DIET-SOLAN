import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoursesTeachingPage extends StatefulWidget {
  final String facultyName;
  final String token;

  const CoursesTeachingPage({
    super.key,
    required this.facultyName,
    required this.token,
  });

  @override
  _CoursesTeachingPageState createState() => _CoursesTeachingPageState();
}

class _CoursesTeachingPageState extends State<CoursesTeachingPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> coursesTeaching = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCoursesTeaching(); // Fetch courses on initial load
  }

  Future<void> fetchCoursesTeaching() async {
    setState(() {
      isLoading = true;
      errorMessage = ''; // Clear any previous error messages
    });

    final url = Uri.https(
      'student-attendance-system-ckb1.onrender.com/api/course/show-courses-faculty',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Use the token passed to this page
          'Content-Type': 'application/json',
        },
      );

      // Print the raw response body to the debug console
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        print('API Response: $data');

        setState(() {
          coursesTeaching = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to load courses. Status code: ${response.statusCode}');
        setState(() {
          errorMessage = 'Failed to load courses. Please try again later.';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.facultyName} - Courses Teaching'),
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : coursesTeaching.isEmpty
                  ? const Center(child: Text('No courses available.'))
                  : ListView.builder(
                      itemCount: coursesTeaching.length,
                      itemBuilder: (context, index) {
                        final course = coursesTeaching[index];
                        return ListTile(
                          title: Text(course['courseName'] ?? 'Unnamed Course'),
                          subtitle: Text('Code: ${course['courseId'] ?? 'N/A'}, Year: ${course['year'] ?? 'N/A'}'),
                        );
                      },
                    ),
    );
  }
}
