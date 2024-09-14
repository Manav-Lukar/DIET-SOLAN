import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowAttendancePage extends StatefulWidget {
  final String token;
  final String facultyName;
  final String courseId;  // Add courseId
  final String year;      // Add year
  final String section;  // Add section

  const ShowAttendancePage({
    Key? key,
    required this.token,
    required this.facultyName,
    required this.courseId,  // Initialize courseId
    required this.year,      // Initialize year
    required this.section,  // Initialize section
  }) : super(key: key);

  @override
  _ShowAttendancePageState createState() => _ShowAttendancePageState();
}

class _ShowAttendancePageState extends State<ShowAttendancePage> {
  List<Map<String, dynamic>> attendanceRecords = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchAttendanceRecords();
  }

  Future<void> _fetchAttendanceRecords() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    final url = Uri.parse(
        'https://student-attendance-system-ckb1.onrender.com/api/show-attendance-faculty/${widget.courseId}/${widget.year}/${widget.section}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      // Print the status code and response body for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          attendanceRecords = List<Map<String, dynamic>>.from(data);
          _message = attendanceRecords.isEmpty
              ? 'No attendance records found.'
              : 'Attendance records loaded successfully.';
        });
      } else {
        setState(() {
          _message = 'Failed to load attendance records. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Error loading attendance records: ${e.toString()}');
      setState(() {
        _message = 'Error loading attendance records: ${e.toString()}';
      });
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
        title: Text('Attendance Records - ${widget.facultyName}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : attendanceRecords.isEmpty
                ? Center(child: Text(_message))
                : ListView.builder(
                    itemCount: attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final record = attendanceRecords[index];
                      return ListTile(
                        title: Text('Enroll No: ${record['enrollNo']}'),
                        subtitle: Text('Status: ${record['status']}'),
                        trailing: Text('Date: ${record['date']}'),
                      );
                    },
                  ),
      ),
    );
  }
}
