import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateRemoveAttendancePage extends StatefulWidget {
  final String token;

  const UpdateRemoveAttendancePage(
      {Key? key, required this.token, required List coursesTeaching, required List classesTeaching})
      : super(key: key);

  @override
  _UpdateRemoveAttendancePageState createState() =>
      _UpdateRemoveAttendancePageState();
}

class _UpdateRemoveAttendancePageState
    extends State<UpdateRemoveAttendancePage> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _yearController = TextEditingController();
  final _sectionController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _courses = [
       {"courseId": 101, "courseName": "Education Technology", "year": 1},
    {"courseId": 102, "courseName": "Psychology", "year": 1},
    {"courseId": 103, "courseName": "Maths", "year": 1},
    {"courseId": 104, "courseName": "Education 102", "year": 1},
    {"courseId": 105, "courseName": "EVS", "year": 1},
    {"courseId": 106, "courseName": "Hindi", "year": 1},
    {"courseId": 107, "courseName": "Work Education", "year": 1},
    {"courseId": 108, "courseName": "Physical Education", "year": 1},
    {"courseId": 109, "courseName": "English", "year": 1},
    {"courseId": 110, "courseName": "Fine Art", "year": 1},
    {"courseId": 111, "courseName": "Music", "year": 1},
    {"courseId": 112, "courseName": "Education103", "year": 1},
    {"courseId": 201, "courseName": "Psychology", "year": 2},
    {"courseId": 202, "courseName": "English", "year": 2},
    {"courseId": 203, "courseName": "Maths", "year": 2},
    {"courseId": 204, "courseName": "Hindi", "year": 2},
    {"courseId": 205, "courseName": "Fine Arts", "year": 2},
    {"courseId": 206, "courseName": "Music", "year": 2},
    {"courseId": 207, "courseName": "Physical Education", "year": 2},
    {"courseId": 208, "courseName": "Social Science", "year": 2},
    {"courseId": 209, "courseName": "Education", "year": 2},
    {"courseId": 210, "courseName": "Planning and Management", "year": 2},
    {"courseId": 211, "courseName": "Science Education", "year": 2},
  ];

  Map<String, dynamic>? _selectedCourse;

  Future<void> _submit() async {
    final courseId = _selectedCourse?['courseId'];
    final date = _dateController.text;
    final time = _timeController.text;
    final year = int.tryParse(_yearController.text);
    final section = _sectionController.text;

    if (courseId == null ||
        date.isEmpty ||
        time.isEmpty ||
        year == null ||
        section.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    final url = 'https://attendance-management-system-jdbc.onrender.com/api/attendance/remove-record';

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
      backgroundColor: const Color(0xFFE0F7FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remove Attendance Record',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              _buildCourseDropdown(),
              const SizedBox(height: 10),
              _buildTextField(_dateController, 'Date (YYYY-MM-DD)'),
              const SizedBox(height: 10),
              _buildTextField(_timeController, 'Time'),
              const SizedBox(height: 10),
              _buildTextField(_yearController, 'Year ', TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(_sectionController, 'Section'),
              const SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Color for button
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 30.0),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Removal'),
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDropdown() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: DropdownButtonFormField<Map<String, dynamic>>(
          value: _selectedCourse,
          hint: const Text('Select Course'),
          items: _courses
              .map<DropdownMenuItem<Map<String, dynamic>>>(
                (course) => DropdownMenuItem<Map<String, dynamic>>(
                  value: course,
                  child: Text('${course['courseName']} (Year ${course['year']})'),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCourse = value;
            });
          },
          decoration: const InputDecoration.collapsed(hintText: ''),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
