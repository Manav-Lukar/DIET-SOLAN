import 'package:flutter/material.dart';
import 'FacultyPersonalInfoDialog.dart';
import 'faculty_attendance_page.dart';
import 'courses_teaching_page.dart';
import 'show_attendance_page.dart'; // Import the new page
import 'update_remove_attendance_page.dart'; // Import the new page

class FacultyHomePage extends StatelessWidget {
  final String username;
  final String token;
  final String email;
  final String facultyName;
  final List<dynamic> coursesTeaching;
  final List<dynamic> classesTeaching;
  final List<dynamic> notices;
  final Map<String, dynamic> facultyDetails; // Added facultyDetails parameter

  const FacultyHomePage({
    Key? key,
    required this.username,
    required this.token,
    required this.email,
    required this.facultyName,
    required this.coursesTeaching,
    required this.classesTeaching,
    required this.notices,
    required this.facultyDetails, // Added facultyDetails
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        title: Text(
          'Welcome $facultyName',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
                          // Filter out _id fields from classesTeaching
                          List<Map<String, dynamic>> filteredClasses = classesTeaching.map((classInfo) {
                            return {
                              'Year': classInfo['year'],
                              'Sections': classInfo['sections'].join(', '),
                            };
                          }).toList();

                          // Prepare faculty info excluding unnecessary fields like _id
                          final facultyInfo = {
                            'Name': facultyName,
                            'Email': email,
                            'Courses Teaching': coursesTeaching.join(', '),
                            'Classes Teaching': filteredClasses
                                .map((classInfo) => 'Year ${classInfo['Year']}, Sections: ${classInfo['Sections']}')
                                .join('; '),
                          };

                          return FacultyPersonalInfoDialog(
                            facultyInfo: facultyInfo,
                          );
                        },
                      ),
                    ),
                    buildTile(
                      context,
                      'Courses Teaching',
                      Icons.school,
                      Colors.orange,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoursesTeachingPage(
                            username: username,
                            token: token,
                            facultyName: facultyName,
                            coursesTeaching: coursesTeaching,
                            facultyDetails: facultyDetails, // Passing facultyDetails here
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
                          builder: (context) => FacultyAttendancePage(
                            facultyName: facultyName,
                            classesTeaching: classesTeaching,
                            token: token,
                            subjects: [], // Update this with actual subjects if available
                          ),
                        ),
                      ),
                    ),
                    buildTile(
                      context,
                      'View Attendance',
                      Icons.remove_red_eye,
                      Colors.green,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowAttendancePage(
                            token: token,
                            facultyName: facultyName,
                            classesTeaching: classesTeaching,
                            courseId: '', // You may pass actual course ID if available
                            year: '', // Pass actual year
                            section: '', // Pass actual section
                          ),
                        ),
                      ),
                    ),
                    buildTile(
                      context,
                      'Update/Remove Attendance',
                      Icons.edit,
                      Colors.blueAccent,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateRemoveAttendancePage(
                            token: token,
                            coursesTeaching: coursesTeaching,
                            classesTeaching: classesTeaching,
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
