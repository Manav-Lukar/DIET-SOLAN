import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FacultyAttendancePage extends StatefulWidget {
  final String token;
  final String facultyName;
  final List<String> subjects;

  const FacultyAttendancePage({
    super.key,
    required this.token,
    required this.facultyName,
    required this.subjects,
  });

  @override
  _FacultyAttendancePageState createState() => _FacultyAttendancePageState();
}

class _FacultyAttendancePageState extends State<FacultyAttendancePage> {
  List<Map<String, dynamic>> studentRecords = [];
  bool _isSubmitting = false;
  String _message = '';

  final _timeController = TextEditingController();
  final _studentsEnrollController = TextEditingController();

  String _status = 'P'; // Default to Present
  int? _selectedCourseId;
  int? _selectedYear;
  String? _selectedSection;

  final List<Map<String, dynamic>> _courses = [
    { 'id': 101, 'name': 'Education Technology' },
    { 'id': 102, 'name': 'Psychology' },
    { 'id': 103, 'name': 'Maths' },
    { 'id': 104, 'name': 'Education 102' },
    { 'id': 105, 'name': 'EVS' },
    { 'id': 106, 'name': 'Hindi' },
    { 'id': 107, 'name': 'Work Education' },
    { 'id': 108, 'name': 'Physical Education' },
    { 'id': 109, 'name': 'English' },
    { 'id': 110, 'name': 'Fine Art' },
    { 'id': 111, 'name': 'Music' },
    { 'id': 112, 'name': 'Education103' },
    { 'id': 201, 'name': 'Psychology' },
    { 'id': 202, 'name': 'English' },
    { 'id': 203, 'name': 'Maths' },
    { 'id': 204, 'name': 'Hindi' },
    { 'id': 205, 'name': 'Fine Arts' },
    { 'id': 206, 'name': 'Music' },
    { 'id': 207, 'name': 'Physical Education' },
    { 'id': 208, 'name': 'Social Science' },
    { 'id': 209, 'name': 'Education' },
    { 'id': 210, 'name': 'Planning and Management' },
    { 'id': 211, 'name': 'Science Education' },
  ];

  @override
  void dispose() {
    _timeController.dispose();
    _studentsEnrollController.dispose();
    super.dispose();
  }

  Future<void> _submitAttendance() async {
    if (!_validateInputs()) {
      setState(() {
        _message = 'Please fill out all fields correctly.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = '';
    });

    final Map<String, dynamic> data = {
      'courseId': _selectedCourseId,
      'time': _timeController.text,
      'year': _selectedYear,
      'section': _selectedSection,
      'attendanceRecords': studentRecords,
    };

    try {
      final response = await http.post(
        Uri.parse('https://student-attendance-system-ckb1.onrender.com/api/attendance/record-new'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _message = 'Attendance recorded successfully!';
          studentRecords.clear();
          _resetForm();
        });
      } else {
        setState(() {
          _message = 'Failed to record attendance. Status code: ${response.statusCode}, Error: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error recording attendance: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  bool _validateInputs() {
    return _selectedCourseId != null &&
        _timeController.text.isNotEmpty &&
        _selectedYear != null &&
        _selectedSection != null &&
        studentRecords.isNotEmpty;
  }

  void _addStudentRecords() {
    final enrollments = _studentsEnrollController.text.split(',').map((e) => e.trim()).toList();

    if (enrollments.isNotEmpty) {
      setState(() {
        studentRecords.addAll(enrollments.map((enrollment) {
          return {
            'enrollNo': int.parse(enrollment),
            'status': _status,
          };
        }).toList());
        _studentsEnrollController.clear();
      });
    } else {
      setState(() {
        _message = "Enrollments cannot be empty.";
      });
    }
  }

  void _resetForm() {
    _timeController.clear();
    _studentsEnrollController.clear();
    _status = 'P';
    _selectedCourseId = null;
    _selectedYear = null;
    _selectedSection = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Management'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Attendance Form'),

              // Dropdown for selecting course
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<int>(
                  value: _selectedCourseId,
                  hint: Text('Select Course'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _courses.map((course) {
                    return DropdownMenuItem<int>(
                      value: course['id'],
                      child: Text(course['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCourseId = value;
                    });
                  },
                ),
              ),

              _buildTextField(_timeController, 'Time (HH:MM AM/PM)', TextInputType.datetime),

              // Dropdown for selecting year
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<int>(
                  value: _selectedYear,
                  hint: Text('Select Year'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [1, 2].map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text('Year $year'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                    });
                  },
                ),
              ),

              // Dropdown for selecting section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedSection,
                  hint: Text('Select Section'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['A', 'B'].map((section) {
                    return DropdownMenuItem<String>(
                      value: section,
                      child: Text('Section $section'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSection = value;
                    });
                  },
                ),
              ),

              SizedBox(height: 16),

              _buildSectionTitle('Add Student Records'),
              _buildTextField(_studentsEnrollController, 'Enter Enroll No (comma separated)', TextInputType.text),

              // Dropdown for selecting status
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'P', child: Text('Present')),
                    DropdownMenuItem(value: 'A', child: Text('Absent')),
                    DropdownMenuItem(value: 'L', child: Text('Leave')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
              ),

              SizedBox(height: 8),

              ElevatedButton(
                onPressed: _addStudentRecords,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text('Add Records'),
              ),

              SizedBox(height: 16),

              if (studentRecords.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Added Records'),
                    ...studentRecords.map((record) {
                      return ListTile(
                        title: Text('Enroll No: ${record['enrollNo']}'),
                        subtitle: Text('Status: ${record['status'] == 'P' ? 'Present' : record['status'] == 'A' ? 'Absent' : 'Leave'}'),
                      );
                    }).toList(),
                  ],
                ),

              SizedBox(height: 16),

              _isSubmitting
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitAttendance,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text('Submit Attendance'),
                    ),

              SizedBox(height: 16),

              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('success') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal[900], // Dark Teal color for title
        ),
      ),
    );
  }
}
