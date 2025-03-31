import 'dart:convert';
import 'package:diet_portal/admin/student_attendance_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowAllAttendancePage extends StatefulWidget {
  final String facultyName;

  const ShowAllAttendancePage({
    Key? key,
    required this.facultyName,
    String? year,
    String? section,
    String? courseId,
  }) : super(key: key);

  @override
  _ShowAllAttendancePageState createState() => _ShowAllAttendancePageState();
}

class _ShowAllAttendancePageState extends State<ShowAllAttendancePage> {
  String? _selectedYear;
  String? _selectedSection;
  String? _selectedCourseId; // To store selected course ID
  List<Map<String, dynamic>> attendanceRecords = [];
  List<dynamic> courses = []; // To store fetched courses
  bool _isLoading = false;
  String _message = '';

  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses(); // Fetch courses when the page initializes
  }

  
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchCourses() async {
    final url = Uri.parse(
        'https://attendance-management-system-jdbc.onrender.com/api/course/show-courses');

    setState(() {
      _isLoading = true;
    });

    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          courses = data; // Store the fetched courses
        });
      } else {
        setState(() {
          _message = 'Failed to load courses. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error loading courses: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAttendanceRecords() async {
    final year = _selectedYear;
    final section = _selectedSection;

    if (_selectedCourseId == null || year == null || section == null) {
      setState(() {
        _message = 'Please fill in all fields.';
      });
      return;
    }

    final url = Uri.parse(
        'https://attendance-management-system-jdbc.onrender.com/api/attendance/show-attendance-faculty/$_selectedCourseId/$year/$section');

    setState(() {
      _isLoading = true;
      _message = '';
    });

    
    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('GET Response Status: ${response.statusCode}');
      debugPrint('GET Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          attendanceRecords = data.map((record) {
            final date = record['date']?.split('T')?.first ?? 'No Date';
            return {
              'enrollNo': record['enrollNo'],
              'rollNo': record['rollNo'], // Added roll number
              'name': record['studentName'] ?? 'Unknown', // Add student name
              'status': record['status'],
              'date': date,
            };
          }).toList();
          filteredRecords = List.from(attendanceRecords); // Initialize filtered records
          _message = attendanceRecords.isEmpty
              ? 'No attendance records found.'
              : 'Attendance records loaded successfully.';
        });
      } else {
        setState(() {
          _message =
              'Failed to load attendance records. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error loading attendance records: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateAndDownloadPdf(
      List<Map<String, dynamic>> records) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Attendance Records', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Enroll No', 'Roll No', 'Status', 'Date'], // Added Roll No header
                data: records
                    .map((record) => [
                          record['enrollNo'].toString(),
                          record['rollNo'].toString(), // Added roll number
                          record['status'],
                          record['date'],
                        ])
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _filterRecords(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRecords = List.from(attendanceRecords);
      } else {
        filteredRecords = attendanceRecords.where((record) {
          final enrollNo = record['enrollNo'].toString().toLowerCase();
          final rollNo = record['rollNo'].toString().toLowerCase();
          return enrollNo.contains(query.toLowerCase()) ||
              rollNo.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Attendance Records'),
        backgroundColor: const Color(0xFFE0F7FA),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              if (attendanceRecords.isNotEmpty) {
                _generateAndDownloadPdf(attendanceRecords);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No records to download.')),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Enroll No or Roll No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: const Icon(Icons.search),
              ),
              onChanged: _filterRecords,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCourseDropdown(),
                  const SizedBox(height: 16.0),
                  _buildDropdown('Select Year', ['1', '2'], (value) {
                    setState(() {
                      _selectedYear = value;
                    });
                  }),
                  const SizedBox(height: 16.0),
                  _buildDropdown('Select Section', ['A', 'B'], (value) {
                    setState(() {
                      _selectedSection = value;
                    });
                  }),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _fetchAttendanceRecords,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Show Attendance'),
                  ),
                  const SizedBox(height: 16.0),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredRecords.isEmpty
                          ? Center(child: Text(_message))
                          : Expanded(
                              child: ListView.builder(
                                itemCount: filteredRecords.length,
                                itemBuilder: (context, index) {
                                  final record = filteredRecords[index];
                                  return Card(
                                    elevation: 3,
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.teal[50],
                                        child: Text(
                                          '${record['rollNo']}',
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      title: Text('Enroll No: ${record['enrollNo']}'),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Status: ${record['status']}'),
                                          Text('Date: ${record['date']}'),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StudentAttendanceDetail(
                                              studentName: record['name'] ?? 'Student',
                                              enrollNo: record['enrollNo'].toString(),
                                              year: _selectedYear ?? '1',
                                              section: _selectedSection ?? 'A',
                                            ),
                                          ),
                                        );
                                      },
                                      trailing: const Icon(Icons.check_circle,
                                          color: Colors.green),
                                    ),
                                  );
                                },
                              ),
                            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCourseId,
      hint: const Text('Select Course'),
      items: courses.map((course) {
        return DropdownMenuItem<String>(
          value: course['courseId'].toString(),
          child: Text(course['courseName']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCourseId = value; // Store selected course ID
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: label == 'Select Year' ? _selectedYear : _selectedSection,
      items: items
          .map((value) => DropdownMenuItem(value: value, child: Text(value)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
