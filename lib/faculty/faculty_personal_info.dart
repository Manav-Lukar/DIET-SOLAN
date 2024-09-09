import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacultyInfoDialog extends StatefulWidget {
  final String username;

  const FacultyInfoDialog({
    Key? key,
    required this.username, required Map<String, Object> facultyInfo,
  }) : super(key: key);

  @override
  _FacultyInfoDialogState createState() => _FacultyInfoDialogState();
}

class _FacultyInfoDialogState extends State<FacultyInfoDialog> {
  Map<String, dynamic> facultyInfo = {};

  @override
  void initState() {
    super.initState();
    _loadSavedInfo();
  }

  Future<void> _loadSavedInfo() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      facultyInfo = {
        'Name': prefs.getString('$prefs') ?? 'Not Available',
        'Email': prefs.getString('facultyEmail') ?? 'Not Available',
        'CoursesTeaching': prefs.getStringList('coursesTeaching') ?? ['Not Available'],
      };
    });
  }

  Future<void> _saveInfo() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('facultyName', facultyInfo['Name'] ?? '');
    await prefs.setString('facultyEmail', facultyInfo['Email'] ?? '');
    await prefs.setStringList('coursesTeaching', (facultyInfo['CoursesTeaching'] as List<String>) ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal Information'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ListTile(
              title: const Text('Faculty Name'),
              subtitle: Text(facultyInfo['Name'] ?? 'Not Available'),
            ),
            ListTile(
              title: const Text('Faculty Email'),
              subtitle: Text(facultyInfo['Email'] ?? 'Not Available'),
            ),
            ListTile(
              title: const Text('Courses Teaching'),
              subtitle: Text(_formatCoursesTeaching(facultyInfo['CoursesTeaching'])),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            _saveInfo();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  String _formatCoursesTeaching(List<dynamic>? coursesTeaching) {
    if (coursesTeaching == null || coursesTeaching.isEmpty) {
      return 'Not Available';
    }

    return coursesTeaching.map((course) => course.toString()).join(', ');
  }
}
