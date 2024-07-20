import 'package:flutter/material.dart';
import 'package:diet_portal/student/FeeDetailsPage.dart';
import 'package:diet_portal/student/academic_details_page.dart';
import 'package:diet_portal/student/class_attendance_page.dart';
import 'package:diet_portal/student/exam_marks_page.dart';
import 'package:diet_portal/student/exam_schedule_page.dart';
import 'package:diet_portal/student/student_personal_info.dart'; // Make sure this import is correct

class StudentHomePage extends StatelessWidget {
  final String username;
  final List<String> notices;
  final List subjectsData;
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
        backgroundColor: Color(0xff3498db),
        title: Text('Welcome, ${studentDetails['fName']}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
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
            const SizedBox(height: 40.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    buildTile(context, 'Personal Info'),
                    buildTile(context, 'Fee Details'),
                    buildTile(context, 'Academic Details'),
                    buildTile(context, 'Exam Schedule'),
                    buildTile(context, 'Class Attendance'),
                    buildTile(context, 'Exam Marks'),
                  ],
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
                    'Name': '${studentDetails['fName']} ${studentDetails['lName']}',
                    'Roll No': studentDetails['rollNo'].toString(),
                    'Email': studentDetails['email'].toString(),
                    // 'Date Of Birth': studentDetails['dob'].toString(),
                    'Year': studentDetails['year'].toString(),
                    'Section': studentDetails['section'] ?? 'N/A',
                    'Father\'s Name': studentDetails['fatherName'] ?? 'N/A',
                    // 'Mother\'s Name': studentDetails['motherName'] ?? 'N/A',
                  }, username: '', facultyInfo: {},
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
                  name: '${studentDetails['fName']} ${studentDetails['lName']}',
                  rollNo: studentDetails['rollNo'].toString(),
                  fineData: const {},
                  subjectsData: subjectsData,
                  year: studentDetails['year'],
                  attendance: const {},
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
