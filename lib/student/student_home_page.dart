import 'package:flutter/material.dart';
import 'package:diet_portal/student/FeeDetailsPage.dart';
import 'package:diet_portal/student/academic_details_page.dart';
import 'package:diet_portal/student/class_attendance_page.dart';
import 'package:diet_portal/student/exam_marks_page.dart';
import 'package:diet_portal/student/exam_schedule_page.dart';
import 'package:diet_portal/student/student_personal_info.dart';

class StudentHomePage extends StatelessWidget {
  final String username;
  final List<String> notices; // List of notices

  const StudentHomePage({
    Key? key,
    required this.username,
    required this.notices, required List subjectsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff3498db),
              Color(0xff4a77f2),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40.0), // Adjusted spacing for welcome message
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: Colors.white.withOpacity(0.2),
              child: Text(
                'Welcome, $username',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8, // Aspect ratio to adjust tile size
                  mainAxisSpacing: 20.0, // Vertical spacing between tiles
                  crossAxisSpacing: 20.0, // Horizontal spacing between tiles
                  children: [
                    buildTile(context, 'Personal Info'),
                    buildTile(context, 'Fee Details'),
                    buildTile(context, 'Academic Details'),
                    buildTile(context, 'Exam Schedule'),
                    buildTile(context, 'Class Attendance'),
                    buildTile(context, 'Exam Marks'),
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

  Widget buildTile(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Personal Info':
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PersonalInfoDialog(
                  studentInfo: {
                    'Username': username,
                    'Name': 'John Doe', // Example student info
                    'Roll No': '123456',
                    'Year': '2nd Year',
                  },
                  facultyInfo: {}, username: '', // Pass faculty info if needed
                );
              },
            );
            break;
          case 'Fee Details':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeeDetailsPage(username: username),
              ),
            );
            break;
          case 'Academic Details':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AcademicDetailsPage(username: username),
              ),
            );
            break;
          case 'Exam Schedule':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExamSchedulePage(username: username),
              ),
            );
            break;
          case 'Class Attendance':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassAttendancePage(
                  username: username,
                  name: 'John Doe', // Example student name
                  rollNo: '123456', // Example student roll number
                  fineData: {}, // Provide fine data if needed
                  subjectsData: [], // Provide subjects data
                  year: '2nd Year', attendance: {}, // Example student year
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
                  notices: notices,
                ),
              ),
            );
            break;
          default:
            // Handle default case or add additional tiles
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.6),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

