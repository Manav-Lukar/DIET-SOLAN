import 'package:flutter/material.dart';
import 'package:diet_portal/student/FeeDetailsPage.dart';
import 'package:diet_portal/student/academic_details_page.dart';
import 'package:diet_portal/student/class_attendance_page.dart';
import 'package:diet_portal/student/student_personal_info.dart';

class ParentHomePage extends StatelessWidget {
  final String parentName;
  final String studentName;
  final String rollNo;
  final String year;
  final String section;

  const ParentHomePage({
    Key? key,
    required this.parentName,
    required this.studentName,
    required this.rollNo,
    required this.year,
    required this.section,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 225, 244, 248),
        title: Text(
          'Welcome, $parentName',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
            _buildNoticesSection(),
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
                    buildTile(context, 'Personal Info', Icons.person, Colors.blue),
                    buildTile(context, 'Fee Details', Icons.account_balance, Colors.green),
                    buildTile(context, 'Academic Details', Icons.school, Colors.orange),
                    buildTile(context, 'Class Attendance', Icons.assignment, Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPersonalInfoDialog(context);
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.account_circle, color: Colors.white),
        tooltip: 'View Personal Info',
      ),
    );
  }

  void _showPersonalInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PersonalInfoDialog(
          studentInfo: {
            'Name': studentName,
            'Roll No': rollNo,
            'Year': year,
            'Section': section,
            'Student Name': studentName,
            'Parent Name': parentName,
          },
          username: '',
          facultyInfo: {}, role: '', info: {},
        );
      },
    );
  }

  Widget _buildNoticesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Notices',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.blue),
                  onPressed: () {
                    // Handle refresh button press
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Sample notices (can be fetched from an API if needed)
            ...[
              'Notice 1: School reopens next week.',
              'Notice 2: Parent-teacher meeting scheduled.',
            ].map((notice) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notifications, size: 16, color: Colors.black54),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      '• $notice',
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget buildTile(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Personal Info':
            _showPersonalInfoDialog(context);
            break;
          case 'Fee Details':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeeDetailsPage(
                  username: '',
                  studentDetails: {
                    'Name': studentName,
                    'Roll No': rollNo,
                  },
                  studentName: studentName, rollNo: '',
                ),
              ),
            );
            break;
          case 'Academic Details':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AcademicDetailsPage(
                  username: '',
                  subjectsData: [], // Update as needed
                  studentDetails: {
                    'Name': studentName,
                    'Roll No': rollNo,
                  },
                  studentName: studentName,
                  subjects: [], rollNo: '', // Update as needed
                ),
              ),
            );
            break;
          case 'Class Attendance':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassAttendancePage(
                  enrollNo: rollNo,
                  username: '',
                  name: studentName,
                  rollNo: rollNo,
                  fineData: const {}, // Update as needed
                  subjectsData: [], // Update as needed
                  year: year,
                  studentName: studentName, section: '',
                ),
              ),
            );
            break;
          default:
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
