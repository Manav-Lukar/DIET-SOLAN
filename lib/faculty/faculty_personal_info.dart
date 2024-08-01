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
              subtitle: Text((facultyInfo['CoursesTeaching'] as List<dynamic>?)?.join(', ') ?? 'Not Available'),
            ),
            ListTile(
              title: const Text('Classes Teaching'),
              subtitle: Text(_formatClassesTeaching(facultyInfo['ClassesTeaching'])),
            ),
            ListTile(
              title: const Text('Role'),
              subtitle: Text(facultyInfo['Role'] ?? 'Not Available'),
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
      final sections = (classInfo['sections'] as List<dynamic>?)?.join(', ');
      return 'Year $year: Sections $sections';
    }).join('\n');
  }
}
