import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AcademicDetailsPage extends StatefulWidget {
  final String username;
  final Map<String, dynamic> studentDetails;
  final String studentName;
  final String rollNo;
  final String token;
  final List<int> subjectsData;

  const AcademicDetailsPage({
    super.key,
    required this.username,
    required this.studentDetails,
    required this.studentName,
    required this.rollNo,
    required this.token,
    required this.subjectsData,
  });

  @override
  _AcademicDetailsPageState createState() => _AcademicDetailsPageState();
}

class _AcademicDetailsPageState extends State<AcademicDetailsPage> {
  List<String> _courses = [];
  final String coursesApiUrl = 'https://attendance-management-system-jdbc.onrender.com/api/course/show-courses';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCourses();
    });
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _courses = []; // Reset the list while loading
    });

    final token = widget.token;

    if (token.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No token found')),
        );
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(coursesApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Print debug information
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');
      print('API Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          final List<String> courseNames = data.map((course) {
            return course['courseName']?.toString() ?? 'Unknown Course';
          }).toList();

          setState(() {
            _courses = courseNames;
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Unexpected response format: ${data.toString()}')),
            );
          });
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch courses: ${response.reasonPhrase}')),
          );
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.studentDetails['fName'] ?? 'N/A';
    final String rollNo = widget.studentDetails['rollNo']?.toString() ?? 'N/A';
    final String year = widget.studentDetails['year']?.toString() ?? 'N/A';
    final String section = widget.studentDetails['section'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffe6f7ff),
                Color(0xffcceeff),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffe6f7ff),
              Color(0xffcceeff),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.9),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Roll No.: $rollNo',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Year: $year',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Section: $section',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Courses:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            ..._courses.isEmpty
                ? [const Text(
                    'No courses available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  )]
                : _courses.map((course) {
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        title: Text(
                          course,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        leading: Icon(Icons.school, color: Colors.blue.shade300),
                      ),
                    );
                  }).toList(),
          ],
        ),
      ),
    );
  }
}
