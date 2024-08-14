import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class ClassAttendancePage extends StatefulWidget {
  final String username;
  final String name;
  final String rollNo;
  final Map<String, dynamic> fineData;
  final List<dynamic> subjectsData;
  final String year;
  final String enrollNo;

  const ClassAttendancePage({
    super.key,
    required this.username,
    required this.name,
    required this.rollNo,
    required this.fineData,
    required this.subjectsData,
    required this.year,
    required this.enrollNo, required studentName, required String section, required Map<String, String> studentDetails,
  });

  @override
  _ClassAttendancePageState createState() => _ClassAttendancePageState();
}

class _ClassAttendancePageState extends State<ClassAttendancePage> {
  late Future<Map<String, Map<DateTime, String>>> _attendanceData;

  @override
  void initState() {
    super.initState();
    _attendanceData = fetchAttendanceData(widget.enrollNo);
  }

  Future<Map<String, Map<DateTime, String>>> fetchAttendanceData(String enrollNo) async {
    try {
      const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdHVkZW50SWQiOiI2NjdlYWRiNGQ2NTkzMmU3MDQ2Yzg4MTMiLCJlbnJvbGxObyI6MjkxLCJyb2xlIjoiU3R1ZGVudCIsImlhdCI6MTcyMjAwNDg1NSwiZXhwIjoxNzIyMDkxMjU1fQ.RQ5_DYDa2oS6NdvF7RK1qfm1RSH8v3vjxW3eT-SWoL8';

      final response = await http.get(
        Uri.parse('https://student-attendance-system-ckb1.onrender.com/api/attendance/show-attendance-student/$enrollNo'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          return {}; // Return an empty map if the data is empty
        }

        // Create a map of attendance data by course ID
        final Map<String, Map<DateTime, String>> attendanceData = {};
        final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

        for (var record in data) {
          final courseId = record['courseId'].toString();
          final List<dynamic> attendanceList = [record]; // Wrap record in a list for consistency

          final Map<DateTime, String> courseAttendance = {};
          for (var entry in attendanceList) {
            final dateString = entry['date'] ?? '';
            final DateTime date = dateFormat.parse(dateString);
            final status = entry['status'] ?? 'Unknown';
            courseAttendance[date] = status;
          }

          attendanceData['Course $courseId'] = courseAttendance;
        }

        return attendanceData;
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
      return {}; // Return an empty map in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Attendance'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffe6f7ff), // Deep blue for consistency
                Color(0xffe6f7ff), // Light blue for consistency
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _attendanceData = fetchAttendanceData(widget.enrollNo);
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffe6f7ff),
              Color(0xffcceeff),
            ],
          ),
        ),
        child: FutureBuilder<Map<String, Map<DateTime, String>>>(
          future: _attendanceData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No attendance data available.'));
            }

            final attendanceData = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: attendanceData.keys.map((courseName) {
                final courseAttendance = attendanceData[courseName]!;

                return Card(
                  color: Colors.white.withOpacity(0.8),
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ExpansionTile(
                    title: Text(
                      courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: courseAttendance.entries.map((entry) {
                      final formattedDate = DateFormat('dd/MM/yyyy').format(entry.key);
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        title: Text(
                          '$formattedDate: ${entry.value}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        leading: Icon(
                          entry.value == 'P' ? Icons.check_circle : Icons.cancel,
                          color: entry.value == 'P' ? Colors.green : Colors.red,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
