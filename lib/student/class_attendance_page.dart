import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ClassAttendancePage extends StatefulWidget {
  final String username;
  final String name;
  final String rollNo;
  final Map<String, dynamic> fineData;
  final List<dynamic> subjectsData;
  final String year;
  final String enrollNo;
  final String token;
  final String studentName;
  final String section;
  final Map studentDetails;

  const ClassAttendancePage({
    super.key,
    required this.username,
    required this.name,
    required this.rollNo,
    required this.fineData,
    required this.subjectsData,
    required this.year,
    required this.enrollNo,
    required this.token,
    required this.studentName,
    required this.section,
    required this.studentDetails,
  });

  @override
  _ClassAttendancePageState createState() => _ClassAttendancePageState();
}

class _ClassAttendancePageState extends State<ClassAttendancePage> {
  late Future<Map<String, Map<DateTime, Map<String, String>>>> _attendanceData;
  Map<String, double> _attendancePercentages = {};

  final Map<int, String> _courseData = {
    101: 'Education Technology',
    102: 'Psychology',
    103: 'Maths',
    104: 'Education 102\'',
    105: 'EVS',
    106: 'Hindi',
    107: 'Work Education',
    108: 'Physical Education',
    109: 'English',
    110: 'Fine Art',
    111: 'Music',
    112: 'Education103\'',
    201: 'Psychology',
    202: 'English',
    203: 'Maths',
    204: 'Hindi',
    205: 'Fine Arts',
    206: 'Music',
    207: 'Physical Education',
    208: 'Social Science',
    209: 'Education',
    210: 'Planning and Management',
    211: 'Science Education',
  };

  @override
  void initState() {
    super.initState();
    _attendanceData = fetchAttendanceData(widget.enrollNo);
  }

  Future<Map<String, Map<DateTime, Map<String, String>>>> fetchAttendanceData(String enrollNo) async {
    try {
      final String token = widget.token;

      final response = await http.get(
        Uri.parse('https://student-attendance-system-ckb1.onrender.com/api/attendance/show-attendance-student/$enrollNo?courseId=101'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          return {};
        }

        final Map<String, Map<DateTime, Map<String, String>>> attendanceData = {};
        final DateFormat dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');

        for (var record in data) {
          final String courseId = record['courseId'].toString();
          final DateTime date = dateFormat.parse(record['date']);
          final String status = record['status'] ?? 'Unknown';
          final String time = record['time'] ?? 'Unknown Time';

          final String courseName = _courseData[int.parse(courseId)] ?? 'Unknown Course';

          if (!attendanceData.containsKey(courseName)) {
            attendanceData[courseName] = {};
          }

          attendanceData[courseName]![date] = {
            'status': status,
            'time': time,
          };
        }

        calculateAttendancePercentages(attendanceData);

        return attendanceData;
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
      return {};
    }
  }

  void calculateAttendancePercentages(Map<String, Map<DateTime, Map<String, String>>> data) {
    final Map<String, double> percentages = {};

    data.forEach((courseName, attendanceRecords) {
      int totalDays = attendanceRecords.length;
      int presentDays = attendanceRecords.values.where((entry) => entry['status'] == 'P').length;

      double percentage = (totalDays > 0) ? (presentDays / totalDays) * 100 : 0.0;
      percentages[courseName] = percentage;
    });

    setState(() {
      _attendancePercentages = percentages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Attendance'),
        backgroundColor: const Color(0xFFE0F7FA), // Updated AppBar color
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
      backgroundColor: const Color(0xFFE0F7FA), // Updated background color
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, Map<DateTime, Map<String, String>>>>(
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
              children: attendanceData.keys.map((courseName) {
                final courseAttendance = attendanceData[courseName]!;

                return Card(
                  color: Colors.white,
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        _showDetailedAttendanceDialog(courseName, courseAttendance);
                      },
                      child: Text(
                        '${_attendancePercentages[courseName]?.toStringAsFixed(2) ?? '0.0'}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  void _showDetailedAttendanceDialog(String courseName, Map<DateTime, Map<String, String>> attendanceRecords) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            courseName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blueGrey,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[700],
                      ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final entry = attendanceRecords.entries.elementAt(index);
                      final formattedDate = DateFormat('dd/MM/yyyy').format(entry.key);
                      final time = entry.value['time'] ?? 'Unknown Time';
                      final status = entry.value['status'] ?? 'Unknown';

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6.0)],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              status == 'P' ? Icons.check_circle : Icons.cancel,
                              color: status == 'P' ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date: $formattedDate', style: const TextStyle(fontSize: 16)),
                                  Text('Time: $time', style: const TextStyle(fontSize: 16)),
                                  Text('Status: $status', style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
