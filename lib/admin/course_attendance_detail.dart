import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CourseAttendanceDetail extends StatefulWidget {
  final String studentName;
  final String enrollNo;
  final String courseId;
  final String courseName;

  const CourseAttendanceDetail({
    Key? key,
    required this.studentName,
    required this.enrollNo,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  _CourseAttendanceDetailState createState() => _CourseAttendanceDetailState();
}

class _CourseAttendanceDetailState extends State<CourseAttendanceDetail> {
  List<Map<String, dynamic>> attendanceRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourseAttendance();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchCourseAttendance() async {
    final token = await _getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://attendance-management-system-jdbc.onrender.com/api/attendance/course-attendance/${widget.enrollNo}/${widget.courseId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          attendanceRecords = List<Map<String, dynamic>>.from(data.map((record) => {
            'date': record['date'].toString().split('T')[0],
            'status': record['status'],
          }));
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseName} Attendance'),
        backgroundColor: const Color(0xFFE0F7FA),
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {
                final record = attendanceRecords[index];
                final isPresent = record['status'] == 'present';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      isPresent ? Icons.check_circle : Icons.cancel,
                      color: isPresent ? Colors.green : Colors.red,
                    ),
                    title: Text(record['date']),
                    trailing: Text(
                      record['status'].toUpperCase(),
                      style: TextStyle(
                        color: isPresent ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}