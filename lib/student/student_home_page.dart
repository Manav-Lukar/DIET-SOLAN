import 'package:diet_portal/student/FeeDetailsPage.dart';
import 'package:flutter/material.dart';
import 'class_attendance_page.dart';
import 'academic_details_page.dart';
import 'exam_schedule_page.dart';
import 'exam_marks_page.dart';
import 'student_personal_info.dart';

class StudentHomePage extends StatelessWidget {
  final String username;
  final List<String> notices;
  final List<dynamic> subjectsData;
  final Map<String, dynamic> studentDetails;

  const StudentHomePage({
    Key? key,
    required this.username,
    required this.notices,
    required this.subjectsData,
    required this.studentDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 225, 244, 248),
        title: Text(
          'Welcome, ${studentDetails['fName']}',
          style: const TextStyle(color: Colors.black),
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
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    buildTile(context, 'Personal Info', Icons.person),
                    buildTile(context, 'Fee Details', Icons.account_balance),
                    buildTile(context, 'Academic Details', Icons.school),
                    buildTile(context, 'Exam Schedule', Icons.schedule),
                    buildTile(context, 'Class Attendance', Icons.assignment),
                    buildTile(context, 'Exam Marks', Icons.assessment),
                  ].map((Widget tile) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: tile,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Personal Info':
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PersonalInfoDialog(
                  studentInfo: {
                    'ID': studentDetails['id'].toString(),
                    'Enroll No': studentDetails['enrollNo'].toString(),
                    'Roll No': studentDetails['rollNo'].toString(),
                    'Name': '${studentDetails['fName']} ${studentDetails['lName']}',
                    'Year': studentDetails['year'].toString(),
                    'Section': studentDetails['section'] ?? '',
                    'DOB': studentDetails['dob'] ?? '',
                    'Email': studentDetails['email'] ?? '',
                    'Father Name': studentDetails['fatherName'] ?? '',
                  },
                  username: '',
                  facultyInfo: {},
                );
              },
            );
            break;
          case 'Fee Details':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeeDetailsPage(username: username, studentDetails: {},),
              ),
            );
            break;
          case 'Academic Details':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AcademicDetailsPage(username: username, subjectsData: [], studentDetails: {},),
              ),
            );
            break;
          case 'Exam Schedule':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExamSchedulePage(username: username, studentDetails: {}, subjectsData: [],),
              ),
            );
            break;
          case 'Class Attendance':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassAttendancePage(
                  enrollNo: studentDetails['enrollNo'].toString(),
                  username: username,
                  name: '${studentDetails['fName']} ${studentDetails['lName']}',
                  rollNo: studentDetails['rollNo'].toString(),
                  fineData: const {},
                  subjectsData: subjectsData,
                  year: studentDetails['year'].toString(),
                ),
              ),
            );
            break;
          case 'Exam Marks':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExamMarksPage(
                  username: username,
                  notices: notices, year: '', subjectsData: [], studentDetails: {},
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
                  color: const Color(0xff4a77f2),
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

