import 'package:flutter/material.dart';

class FacultyInfoDialog extends StatelessWidget {
  final Map<String, dynamic> facultyInfo;
  final Map<String, dynamic> studentInfo;
  final String username;

  const FacultyInfoDialog({
    super.key,
    required this.facultyInfo,
    required this.studentInfo,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal Information'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ListTile(
              title: const Text('Name'),
              subtitle: Text(facultyInfo['Name'] ?? 'Not Available'),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(facultyInfo['Email'] ?? 'Not Available'),
            ),
            ListTile(
              title: const Text('Courses Teaching'),
              subtitle: Text(_formatClassesTeaching(facultyInfo['CoursesTeaching'])),
            ),
            ListTile(
              title: const Text('Student Name'),
              subtitle: Text(studentInfo['Name'] ?? 'Not Available'),
            ),
            ListTile(
              title: const Text('Student Roll Number'),
              subtitle: Text(studentInfo['RollNumber'] ?? 'Not Available'),
            ),
            ListTile(
              title: const Text('Student Year'),
              subtitle: Text(studentInfo['Year'] ?? 'Not Available'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  String _formatClassesTeaching(List<dynamic>? classesTeaching) {
    if (classesTeaching == null || classesTeaching.isEmpty) {
      return 'Not Available';
    }

    return classesTeaching.map((classInfo) {
      final year = classInfo['year'];
      final sections = (classInfo['sections'] as List<dynamic>?)?.join(', ') ?? 'No Sections';
      return 'Year $year: Sections $sections';
    }).join('\n');
  }
}
