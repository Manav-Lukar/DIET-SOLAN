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
    required List classesTeaching,
  });

  @override
  _FacultyAttendancePageState createState() => _FacultyAttendancePageState();
}

class _FacultyAttendancePageState extends State<FacultyAttendancePage> {
  List<Map<String, dynamic>> studentRecords = [];
  bool _isSubmitting = false;
  String _message = '';

  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
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
    _dateController.dispose();
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
      studentRecords = [];
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
      debugPrint('GET Response Status: ${response.statusCode}');
      debugPrint('GET Response Body: ${response.body}');

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
                'rollNo': student['rollNo'],

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
  if (studentRecords.isEmpty || _dateController.text.isEmpty) {
    setState(() {
      _message = 'Please fill in all required fields.';
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
    'date': _dateController.text,
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

    debugPrint('Response Status: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    // Handle successful response
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _message = 'Attendance recorded successfully!';
        studentRecords.clear();
        _resetForm();
      });
    } else if (response.statusCode == 409) {
      // Handle attendance already exists case (assuming 409 status for conflict)
      setState(() {
        _message = 'Attendance already exists for the selected date and section.';
      });
    } else {
      // Handle other server-side errors
      setState(() {
        _message = 'Failed to record attendance. Please try again later.';
      });
    }
  } catch (e) {
    // Handle specific errors (e.g., network issues, timeout)
    if (e.toString().contains('SocketException')) {
      setState(() {
        _message = 'Network error. Please check your internet connection.';
      });
    } else {
      setState(() {
        _message = 'Error occurred: ${e.toString()}';
      });
    }
  } finally {
    setState(() {
      _isSubmitting = false;
    });
  }
}

void _resetForm() {
  _timeController.clear();
  _dateController.clear();
  _selectedCourseId = null;
  _selectedYear = null;
  _selectedSection = null;
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
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
        title: const Text('Attendance Management'),
        backgroundColor: const Color(0xFFE0F7FA), // Change top bar color
      ),
      backgroundColor: const Color(0xFFE0F7FA), // Change background color
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
              _buildDateField(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchStudentList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child:
                    const Text('Fetch Student List', style: TextStyle(fontSize: 16)),
              ),
              if (studentRecords.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionTitle('Mark Attendance'),
                _buildStudentAttendanceList(),
              ],
              const SizedBox(height: 16),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitAttendance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      child: const Text('Submit Attendance',
                          style: TextStyle(fontSize: 16)),
                    ),
              const SizedBox(height: 16),
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // More rounded corners
        borderSide: const BorderSide(color: Colors.grey),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(10),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _dateController,
        readOnly: true,
        decoration: _inputDecoration().copyWith(
          labelText: 'Date',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: _inputDecoration().copyWith(
          labelText: label,
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: _selectedYear,
        items: List.generate(2, (index) => index + 1)
            .map((year) => DropdownMenuItem(
                  value: year,
                  child: Text('Year $year'),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedYear = value;
            _selectedSection = null; // Reset section when year changes
            _selectedCourseId = null; // Reset course when year changes
          });
        },
        decoration: _inputDecoration().copyWith(labelText: 'Select Year'),
      ),
    );
  }

  Widget _buildSectionDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedSection,
        items: ['A', 'B']
            .map((section) => DropdownMenuItem(
                  value: section,
                  child: Text('Section $section'),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedSection = value;
            _selectedCourseId = null; // Reset course when section changes
          });
        },
        decoration: _inputDecoration().copyWith(labelText: 'Select Section'),
      ),
    );
  }

  Widget _buildCourseDropdown() {
    final filteredCourses = _getFilteredCourses();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: _selectedCourseId,
        items: filteredCourses
            .map<DropdownMenuItem<int>>((course) => DropdownMenuItem<int>(
                  value: course['id'] as int,
                  child: Text(course['name']),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedCourseId = value;
          });
        },
        decoration: _inputDecoration().copyWith(labelText: 'Select Course'),
      ),
    );
  }

  Widget _buildStudentAttendanceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text('Roll No',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
                child: Text('Name',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
                child: Text('Status',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 8), // Add some space between headings and the list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: studentRecords.length,
          itemBuilder: (context, index) {
            final student = studentRecords[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('${student['rollNo']}')),
                Expanded(child: Text(student['name'])),
                DropdownButton<String>(
                  value: student['status'],
                  items: [
                    const DropdownMenuItem(value: 'P', child: Text('Present')),
                    const DropdownMenuItem(value: 'A', child: Text('Absent')),
                    const DropdownMenuItem(value: 'L', child: Text('Leave')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      student['status'] = value!;
                    });
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
