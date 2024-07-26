import 'package:flutter/material.dart';

class AcademicDetailsPage extends StatelessWidget {
  final String studentName = 'Manav Lukar';
  final String rollNo = '211291';
  final String courseBranch = 'B.Ed. / Computer Science';
  final String currentYear = '2nd Year';

  final Map<String, String> academicDetails = {
    'Mathematics': 'Dr. A. Kumar',
    'Physics': 'Dr. S. Sharma',
    'Chemistry': 'Dr. R. Mehta',
    'Biology': 'Dr. P. Singh',
    'English': 'Ms. N. Gupta',
    'History': 'Mr. M. Verma',
    'Geography': 'Ms. R. Joshi',
  };

  // Constructor
  AcademicDetailsPage({super.key, required String username, required List subjectsData, required Map<String, dynamic> studentDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffe6f7ff), // Deep blue for consistency
                Color(0xffe6f7ff), // Light blue for consistency
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 6,
                offset: Offset(0, 2), // Shadow position
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
              Color(0xffe6f7ff), // Light blue gradient for a fresh look
              Color(0xffcceeff), // Slightly darker blue for contrast
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              color: Colors.white.withOpacity(0.8), // Semi-transparent white color
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  'Name: $studentName\nRoll No.: $rollNo\nCourse/Branch: $courseBranch\nCurrent Year: $currentYear',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),
            ...academicDetails.entries.map((entry) {
              return Card(
                color: Colors.white.withOpacity(0.8), // Semi-transparent white color
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  subtitle: Text(
                    entry.value,
                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
