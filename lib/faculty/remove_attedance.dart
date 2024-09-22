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
  bool _isLoading = false;

  Future<void> _submit() async {
    final courseId = int.tryParse(_courseIdController.text);
    final date = _dateController.text;
    final time = _timeController.text;
    final year = int.tryParse(_yearController.text);
    final section = _sectionController.text;

    if (courseId == null || date.isEmpty || time.isEmpty || year == null || section.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    final url = 'https://student-attendance-system-ckb1.onrender.com/api/attendance/remove-record';

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.delete(
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

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance removal successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove attendance')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remove Attendance'),
        backgroundColor: const Color(0xFFE0F7FA),
      ),
      backgroundColor: const Color(0xFFE0F7FA), // Set background color directly on Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_courseIdController, 'Course ID (int)', TextInputType.number),
              _buildTextField(_dateController, 'Date (YYYY-MM-DD)'),
              _buildTextField(_timeController, 'Time'),
              _buildTextField(_yearController, 'Year (int)', TextInputType.number),
              _buildTextField(_sectionController, 'Section'),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Removal'),
              ),
              const SizedBox(height: 30.0), // Extra spacing to ensure proper layout
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white, // Text field background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
