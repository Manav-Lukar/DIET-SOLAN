import 'package:diet_portal/admin/course_attendance_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StudentAttendanceDetail extends StatefulWidget {
  final String studentName;
  final String enrollNo;
  final String year;
  final String section;

  const StudentAttendanceDetail({
    Key? key,
    required this.studentName,
    required this.enrollNo,
    required this.year,
    required this.section,
  }) : super(key: key);

  @override
  _StudentAttendanceDetailState createState() => _StudentAttendanceDetailState();
}

class _StudentAttendanceDetailState extends State<StudentAttendanceDetail> {
  List<Map<String, dynamic>> courseAttendance = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudentCourseAttendance();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchStudentCourseAttendance() async {
    final token = await _getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://attendance-management-system-jdbc.onrender.com/api/attendance/student-attendance/${widget.enrollNo}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          courseAttendance = List<Map<String, dynamic>>.from(data['courses'].map((course) {
            final totalClasses = course['totalClasses'] ?? 0;
            final attendedClasses = course['attendedClasses'] ?? 0;
            final percentage = totalClasses > 0 
                ? (attendedClasses / totalClasses * 100).toStringAsFixed(2)
                : '0';
            
            return {
              'courseId': course['courseId'],
              'courseName': course['courseName'],
              'percentage': percentage,
              'totalClasses': totalClasses,
              'attendedClasses': attendedClasses,
            };
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

  void _showCourseAttendanceDetails(Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseAttendanceDetail(
          studentName: widget.studentName,
          enrollNo: widget.enrollNo,
          courseId: course['courseId'],
          courseName: course['courseName'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.studentName}\'s Attendance'),
        backgroundColor: const Color(0xFFE0F7FA),
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: courseAttendance.length,
              itemBuilder: (context, index) {
                final course = courseAttendance[index];
                final percentage = double.parse(course['percentage']);
                
                return GestureDetector(
                  onTap: () => _showCourseAttendanceDetails(course),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            course['courseName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  percentage >= 75 ? Colors.green : Colors.red,
                                ),
                              ),
                              Text(
                                '${course['percentage']}%',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${course['attendedClasses']}/${course['totalClasses']} classes',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}