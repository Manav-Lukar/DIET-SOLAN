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
    required this.subjects, required List classesTeaching,
  });

  @override
  _FacultyAttendancePageState createState() => _FacultyAttendancePageState();
}

class _FacultyAttendancePageState extends State<FacultyAttendancePage> {
  List<Map<String, dynamic>> studentRecords = [];
  bool _isSubmitting = false;
  String _message = '';

  final _timeController = TextEditingController();
  int? _selectedCourseId;
  int? _selectedYear;
  String? _selectedSection;

  final List<Map<String, dynamic>> _courses = [
    {'id': 101, 'name': 'Education Technology'},
    {'id': 102, 'name': 'Psychology'},
    {'id': 103, 'name': 'Maths'},
    {'id': 104, 'name': 'Education 102\''},
    {'id': 105, 'name': 'EVS'},
    {'id': 106, 'name': 'Hindi'},
    {'id': 107, 'name': 'Work Education'},
    {'id': 108, 'name': 'Physical Education'},
    {'id': 109, 'name': 'English'},
    {'id': 110, 'name': 'Fine Art'},
    {'id': 111, 'name': 'Music'},
    {'id': 112, 'name': 'Education103\''},
    {'id': 201, 'name': 'Psychology'},
    {'id': 202, 'name': 'English'},
    {'id': 203, 'name': 'Maths'},
    {'id': 204, 'name': 'Hindi'},
    {'id': 205, 'name': 'Fine Arts'},
    {'id': 206, 'name': 'Music'},
    {'id': 207, 'name': 'Physical Education'},
    {'id': 208, 'name': 'Social Science'},
    {'id': 209, 'name': 'Education'},
    {'id': 210, 'name': 'Planning and Management'},
    {'id': 211, 'name': 'Science Education'},
  ];

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _fetchStudentList() async {
    if (_selectedCourseId == null ||
        _selectedYear == null ||
        _selectedSection == null) {
      setState(() {
        _message = 'Please select all required fields.';
      });
      return;
    }

    setState(() {
      _message = '';
      studentRecords = []; // Clear previous records
    });

    try {
      final url = Uri.parse(
        'https://student-attendance-system-ckb1.onrender.com/api/student/get-students/${_selectedYear}/${_selectedSection}/${_selectedCourseId}',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> students = json.decode(response.body);

        if (students.isEmpty) {
          setState(() {
            _message =
                'No students found for the selected course, year, and section.';
          });
        } else {
          setState(() {
            studentRecords = students.map((student) {
              return {
                'enrollNo': student['enrollNo'],
                'name': '${student['fName']} ${student['lName']}',
                'status': 'P', // Default status to 'Present'
              };
            }).toList();
          });
        }
      } else {
        setState(() {
          _message = 'Failed to fetch students. Error: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error fetching students: ${e.toString()}';
      });
    }
  }

  Future<void> _submitAttendance() async {
    if (studentRecords.isEmpty) {
      setState(() {
        _message = 'No student records to submit.';
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
        Uri.parse(
            'https://student-attendance-system-ckb1.onrender.com/api/attendance/record-new'),
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
          _message =
              'Failed to record attendance. Status code: ${response.statusCode}, Error: ${response.body}';
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

  void _resetForm() {
    _timeController.clear();
    _selectedCourseId = null;
    _selectedYear = null;
    _selectedSection = null;
  }

  List<Map<String, dynamic>> _getFilteredCourses() {
    if (_selectedYear == 1) {
      return _courses.where((course) => course['id'] < 200).toList();
    } else if (_selectedYear == 2) {
      return _courses.where((course) => course['id'] >= 200).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Management'),
        backgroundColor: Colors.teal[50],
      ),
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Attendance Form'),
              _buildYearDropdown(),
              _buildSectionDropdown(),
              _buildCourseDropdown(),
              _buildTextField(_timeController, 'Time (HH:MM AM/PM)',
                  TextInputType.datetime),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchStudentList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child:
                    Text('Fetch Student List', style: TextStyle(fontSize: 16)),
              ),
              if (studentRecords.isNotEmpty) ...[
                SizedBox(height: 16),
                _buildSectionTitle('Mark Attendance'),
                _buildStudentAttendanceList(),
              ],
              SizedBox(height: 16),
              _isSubmitting
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitAttendance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      child: Text('Submit Attendance',
                          style: TextStyle(fontSize: 16)),
                    ),
              SizedBox(height: 16),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('success')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: _selectedCourseId,
        hint: Text('Select Course'),
        decoration: _inputDecoration(),
        items: _getFilteredCourses().map((course) {
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
    );
  }

  Widget _buildYearDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: _selectedYear,
        hint: Text('Select Year'),
        decoration: _inputDecoration(),
        items: [1, 2].map((year) {
          return DropdownMenuItem<int>(
            value: year,
            child: Text('Year $year'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedYear = value;
            _selectedCourseId =
                null; // Reset course selection when year changes
          });
        },
      ),
    );
  }

  Widget _buildSectionDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedSection,
        hint: Text('Select Section'),
        decoration: _inputDecoration(),
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration().copyWith(labelText: label),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStudentAttendanceList() {
    return Column(
      children: studentRecords.map((student) {
        return ListTile(
          title: Text(student['name']),
          subtitle: Text('Enrollment No: ${student['enrollNo']}'),
          trailing: DropdownButton<String>(
            value: student['status'],
            items: ['P', 'A', 'L'].map((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(
                  status == 'P'
                      ? 'Present'
                      : status == 'A'
                          ? 'Absent'
                          : 'Leave',
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                student['status'] = value!;
              });
            },
          ),
        );
      }).toList(),
    );
  }
}
