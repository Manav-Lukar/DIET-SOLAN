import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateRemoveAttendancePage extends StatefulWidget {
  final String token;
  final List<dynamic> coursesTeaching;
  final List<dynamic> classesTeaching;

  const UpdateRemoveAttendancePage({
    Key? key,
    required this.token,
    required this.coursesTeaching,
    required this.classesTeaching,
  }) : super(key: key);

  @override
  _UpdateRemoveAttendancePageState createState() => _UpdateRemoveAttendancePageState();
}

class _UpdateRemoveAttendancePageState extends State<UpdateRemoveAttendancePage> {
  final _courseIdController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _yearController = TextEditingController();
  final _sectionController = TextEditingController();
  String _operation = 'Update'; // Default to 'Update'

  Future<void> _submit() async {
    final courseId = _courseIdController.text;
    final date = _dateController.text;
    final time = _timeController.text;
    final year = _yearController.text;
    final section = _sectionController.text;

    if (courseId.isEmpty || date.isEmpty || time.isEmpty || year.isEmpty || section.isEmpty) {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final url = _operation == 'Update'
        ? 'https://student-attendance-system-ckb1.onrender.com/api/attendance/update-attendance'
        : 'https://student-attendance-system-ckb1.onrender.com/api/attendance/remove-record';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'courseId': courseId,
          'date': date,
          'time': time,
          'year': year,
          'section': section,
        }),
      );

      // Print response details to the debug console
      print('Request URL: $url');
      print('Request body: ${jsonEncode({
        'courseId': courseId,
        'date': date,
        'time': time,
        'year': year,
        'section': section,
      })}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance $_operation successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to $_operation attendance')),
        );
      }
    } catch (e) {
      // Handle exceptions (network errors, etc.)
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update/Remove Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _operation,
              onChanged: (String? newValue) {
                setState(() {
                  _operation = newValue!;
                });
              },
              items: <String>['Update', 'Remove']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _courseIdController,
              decoration: const InputDecoration(labelText: 'Course ID'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: _yearController,
              decoration: const InputDecoration(labelText: 'Year'),
            ),
            TextField(
              controller: _sectionController,
              decoration: const InputDecoration(labelText: 'Section'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit $_operation'),
            ),
          ],
        ),
      ),
    );
  }
}
