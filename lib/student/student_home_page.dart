import 'package:flutter/material.dart';
import 'package:diet_portal/student/class_attendance_page.dart';
import 'package:diet_portal/student/academic_details_page.dart';
import 'package:diet_portal/student/student_personal_info.dart';

class StudentHomePage extends StatelessWidget {
  final String username;
  final List<int> subjectsData;
  final Map<String, dynamic> studentDetails;
  final String studentName;
  final String rollNo;
  final String section;
  final String token;
  final String year;

  const StudentHomePage({
    super.key,
    required this.username,
    required this.subjectsData,
    required this.studentDetails,
    required this.studentName,
    required this.rollNo,
    required this.section,
    required this.token,
    required this.year,
    required List notices,
    required String role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        title: Text(
          'Welcome, ${studentDetails['fName']}',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFE0F2F1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    buildTile(
                      context,
                      'Personal Info',
                      Icons.person,
                      Colors.blue,
                      () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PersonalInfoDialog(
                            studentInfo: {
                              // 'ID': studentDetails['id'].toString(),
                              'Enroll No':
                                  studentDetails['enrollNo'].toString(),
                              'Roll No': studentDetails['rollNo'].toString(),
                              'Name':
                                  '${studentDetails['fName']} ${studentDetails['lName']}',
                              'Year': studentDetails['year'].toString(),
                              'Section': studentDetails['section'] ?? '',
                              'DOB': studentDetails['dob'] ?? '',
                              'Email': studentDetails['email'] ?? '',
                              'Father Name': studentDetails['fatherName'] ?? '',
                              'Mother Name': studentDetails['motherName'] ?? '',
                            },
                            username: username,
                            facultyInfo: const {},
                            role: '',
                            info: const {},
                            parentsDetails: const {},
                            parentInfo: {},
                          );
                        },
                      ),
                    ),
                    buildTile(
                      context,
                      'Academic Details',
                      Icons.school,
                      Colors.orange,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AcademicDetailsPage(
                            username: username,
                            subjectsData: subjectsData,
                            studentDetails: studentDetails,
                            studentName: studentName,
                            rollNo: rollNo,
                            // subjects: const [],
                            token: token,
                          ),
                        ),
                      ),
                    ),
                    buildTile(
                      context,
                      'Class Attendance',
                      Icons.assignment,
                      Colors.red,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassAttendancePage(
                            enrollNo: studentDetails['enrollNo'].toString(),
                            username: username,
                            name: studentName,
                            rollNo: rollNo,
                            fineData: const {},
                            subjectsData: subjectsData,
                            year: year,
                            studentName: studentName,
                            section: section,
                            studentDetails: const {},
                            token: token,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
