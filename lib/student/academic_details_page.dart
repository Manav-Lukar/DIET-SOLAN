import 'package:flutter/material.dart';

class AcademicDetailsPage extends StatelessWidget {
  final String username;
  final List<int> subjectsData;
  final Map<String, dynamic> studentDetails;
  final String studentName;
  final List<String> subjects;
  final String rollNo;

  const AcademicDetailsPage({
    super.key,
    required this.username,
    required this.subjectsData,
    required this.studentDetails,
    required this.studentName,
    required this.subjects,
    required this.rollNo,
  });

  @override
  Widget build(BuildContext context) {
    // Extract details from the API response
    final String name = studentDetails['fName'] ?? 'N/A';
    final String rollNo = studentDetails['rollNo']?.toString() ?? 'N/A';
    final String year = studentDetails['year']?.toString() ?? 'N/A';
    final String section = studentDetails['section'] ?? 'N/A';

    // Define a mapping from course ID to course name
    final Map<int, String> courseMapping = {
      101: 'Mathematics',
      102: 'Physics',
      103: 'Chemistry',
      104: 'Biology',
      105: 'English',
      106: 'History',
      107: 'Geography',
      108: 'Computer Science',
      109: 'Statistics',
      110: 'Economics',
      111: 'Philosophy',
      112: 'Political Science',
      // Add other mappings as necessary
    };

    // Get the courses from the response and map course IDs to course names
    final List<int> courseIds = List<int>.from(studentDetails['courses'] ?? []);
    final List<String> courses = courseIds.map((courseId) {
      return courseMapping[courseId] ?? 'Unknown Course'; // Fallback if ID is not mapped
    }).toList();

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
            ...courses.map((course) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
            }),
          ],
        ),
      ),
    );
  }
}
