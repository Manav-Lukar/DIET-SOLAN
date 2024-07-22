import 'package:flutter/material.dart';

class FacultyInfoDialog extends StatelessWidget {
  final Map<String, dynamic> facultyInfo;
  final Map<String, dynamic> studentInfo;
  final String username;

  const FacultyInfoDialog({
    Key? key,
    required this.facultyInfo,
    required this.studentInfo,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal Information'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Name: ${facultyInfo['Name'] ?? 'Not Available'}'),
            const SizedBox(height: 10),
            Text('Email: ${facultyInfo['Email'] ?? 'Not Available'}'),
            const SizedBox(height: 10),
            Text('Courses Teaching: ${facultyInfo['CoursesTeaching']?.join(', ') ?? 'Not Available'}'),
            const SizedBox(height: 10),
            Text('Classes Teaching: ${_formatClassesTeaching(facultyInfo['ClassesTeaching'])}'),
            const SizedBox(height: 10),
            Text('Role: ${facultyInfo['Role'] ?? 'Not Available'}'),
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
      final sections = (classInfo['sections'] as List<dynamic>?)?.join(', ');
      return 'Year $year: Sections $sections';
    }).join('\n');
  }
}
