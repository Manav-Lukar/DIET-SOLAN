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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Details'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff3498db),
                Color(0xff4a77f2),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff3498db),
              Color(0xff4a77f2),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              color:
                  Colors.white.withOpacity(0.6), // Semi-transparent white color
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  'Name: $studentName\nRoll No.: $rollNo\nCourse/Branch: $courseBranch\nCurrent Year: $currentYear',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ...academicDetails.entries.map((entry) {
              return Card(
                color: Colors.white
                    .withOpacity(0.6), // Semi-transparent white color
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    entry.value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
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
