import 'package:diet_portal/student/FeeDetailsPage.dart';
import 'package:flutter/material.dart';
import 'class_attendance_page.dart';
import 'academic_details_page.dart';
import 'exam_marks_page.dart';
import 'exam_schedule_page.dart';
import 'student_personal_info.dart';

class StudentHomePage extends StatelessWidget {
  final String username;
  final List<String> notices;
  final List subjectsData;
  final Map studentDetails;

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
        backgroundColor: const Color(0xff3498db),
        title: Text('Welcome, ${studentDetails['fName']}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
      rollNo: studentDetails['rollNo'].toString(),  // Ensure this is a string
      fineData: const {},
      subjectsData: subjectsData,
      year: studentDetails['year'].toString(),  // Ensure this is a string
      attendance: const {
        'Mathematics': {
          '01-01-2024': 'P',
          '01-02-2024': 'A',
          '22-02-2024': 'A',
          '11-04-2024': 'P',
          '09-05-2024': 'L',
        },
        'Physics': {
          '01-01-2024': 'P',
          '01-02-2024': 'P',
          '22-02-2024': 'A',
          '11-04-2024': 'P',
          '09-05-2024': 'L',
          '30-03-2024': 'L',
        },
        'Chemistry': {
          '01-01-2024': 'P',
          '01-02-2024': 'A',
          '22-02-2024': 'P',
          '11-04-2024': 'P',
          '09-05-2024': 'L',
        },
        'History': {
          '01-01-2024': 'P',
          '01-02-2024': 'P',
          '22-02-2024': 'P',
          '11-04-2024': 'A',
          '09-05-2024': 'L',
        },
        'English': {
          '01-01-2024': 'P',
          '01-02-2024': 'A',
          '22-02-2024': 'A',
          '11-04-2024': 'P',
          '09-05-2024': 'L',
        },
        'Economics': {
          '01-01-2024': 'P',
          '01-02-2024': 'P',
          '22-02-2024': 'A',
          '11-04-2024': 'P',
          '09-05-2024': 'L',
        },
        'EVS': {
          '01-01-2024': 'P',
          '01-02-2024': 'P',
          '22-02-2024': 'P',
          '11-04-2024': 'P',
          '09-05-2024': 'L',
        },
      },
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
