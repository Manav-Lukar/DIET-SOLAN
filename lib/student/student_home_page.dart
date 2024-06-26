import 'package:diet_portal/announcement%20message/announcement_widget.dart';
import 'package:flutter/material.dart';
import 'package:diet_portal/student/FeeDetailsPage.dart';
import 'package:diet_portal/student/academic_details_page.dart';
import 'package:diet_portal/student/class_attendance_page.dart';
import 'package:diet_portal/student/exam_schedule_page.dart';
import 'package:diet_portal/student/exam_marks_page.dart';

class StudentHomePage extends StatelessWidget {
  final String username;
  final String name = 'John Doe'; // Example student info
  final String rollNo = '123456';
  final String year = '2nd Year';
  final String? announcement;

  const StudentHomePage({
    Key? key,
    required this.username,
    required List<Map<String, Object>> subjectsData,
    this.announcement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home Page'),
        flexibleSpace: Container(
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
        ),
      ),
      body: Stack(
        children: [
          Container(
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
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.white.withOpacity(0.2), // Semi-transparent white color
                  child: Text(
                    'Welcome, $username',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10), // Adjust spacing as needed
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0), // Add top padding here
                    child: GridView.count(
                      crossAxisCount: 2,
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
          if (announcement != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnnouncementWidget(
                message: announcement!,
                onClose: () {
                  // Handle close action
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTile(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Personal Info') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return PersonalInfoDialog(studentInfo: {
                'Name': name,
                'Roll No': rollNo,
                'Year': year,
                'Username': username,
              });
            },
          );
        } else if (title == 'Fee Details') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeeDetailsPage()),
          );
        } else if (title == 'Academic Details') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AcademicDetailsPage()),
          );
        } else if (title == 'Exam Schedule') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExamSchedulePage()),
          );
        } else if (title == 'Class Attendance') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClassAttendancePage(
              name: name,
              rollNo: rollNo,
              year: year,
              fineData: const {},
              subjectsData: const [],
              username: username,
            )),
          );
        } else if (title == 'Exam Marks') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExamMarksPage()),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.6), // Semi-transparent white color
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class PersonalInfoDialog extends StatelessWidget {
  final Map<String, String> studentInfo;

  const PersonalInfoDialog({
    Key? key,
    required this.studentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal Information'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: studentInfo.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '${entry.key}: ${entry.value}',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
