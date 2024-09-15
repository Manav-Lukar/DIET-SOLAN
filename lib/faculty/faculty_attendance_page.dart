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
  int? _selectedCourseId;
  int? _selectedYear;
  String? _selectedSection;

  final List<Map<String, dynamic>> _courses = [
    {'id': 101, 'name': 'Education Technology'},
    {'id': 102, 'name': 'Psychology'},
    // Add other courses here...
  ];

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

Future<void> _fetchStudentList() async {
  if (_selectedCourseId == null || _selectedYear == null || _selectedSection == null) {
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
    // Debugging prints
    print('Selected Course ID: $_selectedCourseId');
    print('Selected Year: $_selectedYear');
    print('Selected Section: $_selectedSection');

    // Build the API URL with the selected parameters
    final url = Uri.parse(
      'https://student-attendance-system-ckb1.onrender.com/api/student/get-students/${_selectedYear}/${_selectedSection}/${_selectedCourseId}',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    // Print API response status and body for debugging
    print('API Response Status Code: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> students = json.decode(response.body);

      // Check if students list is empty
      if (students.isEmpty) {
        setState(() {
          _message = 'No students found for the selected course, year, and section.';
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

              // Dropdown for selecting course
              _buildCourseDropdown(),

              // TextField for time
              _buildTextField(_timeController, 'Time (HH:MM AM/PM)', TextInputType.datetime),

              // Dropdown for selecting year
              _buildYearDropdown(),

              // Dropdown for selecting section
              _buildSectionDropdown(),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchStudentList,
                child: Text('Fetch Student List'),
              ),

              if (studentRecords.isNotEmpty) ...[
                SizedBox(height: 16),
                _buildSectionTitle('Mark Attendance'),

                // Displaying each student with attendance options
                _buildStudentAttendanceList(),
              ],

              SizedBox(height: 16),

              _isSubmitting
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitAttendance,
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

  Widget _buildCourseDropdown() {
    return Padding(
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
    );
  }

  Widget _buildYearDropdown() {
    return Padding(
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
    );
  }

  Widget _buildSectionDropdown() {
    return Padding(
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
    );
  }

  Widget _buildStudentAttendanceList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: studentRecords.length,
      itemBuilder: (context, index) {
        final student = studentRecords[index];

        return ListTile(
          title: Text('${student['name']} (Enroll No: ${student['enrollNo']})'),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttendanceOption(
                  index, 'P', 'P', student['status'] == 'P'),
              _buildAttendanceOption(
                  index, 'A', 'A', student['status'] == 'A'),
              _buildAttendanceOption(
                  index, 'L', 'L', student['status'] == 'L'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceOption(
      int index, String value, String label, bool isSelected) {
    return Expanded(
      child: RadioListTile<String>(
        title: Text(label),
        value: value,
        groupValue: studentRecords[index]['status'],
        onChanged: (newValue) {
          setState(() {
            studentRecords[index]['status'] = newValue;
          });
        },
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
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
