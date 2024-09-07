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
  List<dynamic> attendanceData = [];
  List<Map<String, dynamic>> studentRecords = [];
  bool isLoading = true;
  String errorMessage = '';
  bool _isSubmitting = false;
  String _message = '';

  final _courseIdController = TextEditingController();
  final _timeController = TextEditingController();
  final _yearController = TextEditingController();
  final _sectionController = TextEditingController();
  final _enrollNoController = TextEditingController();
  String _status = 'P'; // Default to Present

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://student-attendance-system-ckb1.onrender.com/api/attendance/show-attendance-faculty/101/1/B'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          attendanceData = json.decode(response.body);
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load attendance data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching attendance data: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      'courseId': int.parse(_courseIdController.text),
      'time': _timeController.text,
      'year': int.parse(_yearController.text),
      'section': _sectionController.text,
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

      if (response.statusCode == 200) {
        setState(() {
          _message = 'Attendance recorded successfully!';

          // Add the submitted records to attendanceData for immediate table update
          for (var record in studentRecords) {
            attendanceData.add({
              'courseId': int.parse(_courseIdController.text),
              'enrollNo': record['enrollNo'],
              'date': DateTime.now().toString().split(' ')[0], // Use current date
              'status': record['status'],
            });
          }

          // Clear the form and student records after successful submission
          studentRecords.clear();
          _courseIdController.clear();
          _timeController.clear();
          _yearController.clear();
          _sectionController.clear();
          _status = 'P'; // Reset status to Present
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
    return _courseIdController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _yearController.text.isNotEmpty &&
        _sectionController.text.isNotEmpty &&
        studentRecords.isNotEmpty &&
        RegExp(r'^\d{2}:\d{2}\s*[AP]M$').hasMatch(_timeController.text);
  }

  void _addStudentRecord() {
    if (_enrollNoController.text.isNotEmpty) {
      setState(() {
        studentRecords.add({
          'enrollNo': int.parse(_enrollNoController.text),
          'status': _status,
        });
        _enrollNoController.clear();
        _status = 'P'; // Reset to Present after each entry
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'P':
        return Colors.green; // Present
      case 'A':
        return Colors.red; // Absent
      case 'L':
        return Colors.yellow; // Leave
      default:
        return Colors.grey; // Unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Records - ${widget.facultyName}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attendance Form
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _courseIdController,
                    decoration: const InputDecoration(labelText: 'Course ID'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(labelText: 'Time (HH:MM AM/PM)'),
                    keyboardType: TextInputType.datetime,
                  ),
                  TextField(
                    controller: _yearController,
                    decoration: const InputDecoration(labelText: 'Year'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _sectionController,
                    decoration: const InputDecoration(labelText: 'Section'),
                  ),
                  const SizedBox(height: 20),

                  // Add students section
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _enrollNoController,
                          decoration: const InputDecoration(labelText: 'Enroll No'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _status,
                        onChanged: (String? newValue) {
                          setState(() {
                            _status = newValue!;
                          });
                        },
                        items: <String>['P', 'A', 'L']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value == 'P'
                                ? 'Present'
                                : value == 'A'
                                    ? 'Absent'
                                    : 'Leave'),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _addStudentRecord,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Display added student records
                  if (studentRecords.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: studentRecords.length,
                      itemBuilder: (context, index) {
                        final student = studentRecords[index];
                        return ListTile(
                          title: Text('Enroll No: ${student['enrollNo']}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: _getStatusColor(student['status']),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              student['status'] == 'P'
                                  ? 'Present'
                                  : student['status'] == 'A'
                                      ? 'Absent'
                                      : 'Leave',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitAttendance,
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Submit Attendance'),
                  ),
                  if (_message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _message,
                        style: TextStyle(
                          color: _message.contains('successfully')
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Attendance Records
            if (!isLoading)
              Expanded(
                child: attendanceData.isEmpty
                    ? const Center(child: Text('No attendance records available.'))
                    : ListView.builder(
                        itemCount: attendanceData.length,
                        itemBuilder: (context, index) {
                          final record = attendanceData[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 2,
                            child: ListTile(
                              title: Text('Course ID: ${record['courseId']}'),
                              subtitle: Text('Enroll No: ${record['enrollNo']} - Date: ${record['date']} - Status: ${record['status']}'),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(record['status']),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  record['status'] == 'P'
                                      ? 'Present'
                                      : record['status'] == 'A'
                                          ? 'Absent'
                                          : 'Leave',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              )
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
