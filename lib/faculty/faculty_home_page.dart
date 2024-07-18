import 'package:diet_portal/faculty/exam_papers_page.dart';
import 'package:diet_portal/faculty/faculty_attendance_page.dart';
import 'package:diet_portal/faculty/notices_page.dart';
import 'package:diet_portal/student/student_personal_info.dart';
import 'package:flutter/material.dart';
import 'package:diet_portal/faculty/ClassSchedulePage.dart';
 // Import your PersonalInfoDialog

class FacultyHomePage extends StatefulWidget {
  final String username;

  const FacultyHomePage({Key? key, required this.username, required String email, required notices}) : super(key: key);

  @override
  _FacultyHomePageState createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  List<String> notices = [];

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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: Colors.white.withOpacity(0.2),
              child: Text(
                'Welcome, ${widget.username}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    buildTile(context, 'Class Schedule'),
                    buildTile(context, 'Attendance Records'),
                    buildTile(context, 'Exam Papers'),
                    buildTile(context, 'Notices'),
                    buildTile(context, 'Reports'),
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
        if (title == 'Personal Info') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return PersonalInfoDialog(
                facultyInfo: {
                  'Username': widget.username,
                },
                studentInfo: {}, // Adjust as per your app logic
                username: '', // Adjust as per your app logic
              );
            },
          );
        } else if (title == 'Class Schedule') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassSchedulePage(facultyName: widget.username),
            ),
          );
        } else if (title == 'Attendance Records') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FacultyAttendancePage(
                facultyName: widget.username,
                subjects: [
                  'Mathematics',
                  'Physics',
                  'Chemistry',
                ], // Example subjects
              ),
            ),
          );
        } else if (title == 'Exam Papers') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExamPapersPage(
                facultyName: widget.username,
                username: '',
              ),
            ),
          );
        } else if (title == 'Notices') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoticesPage(
                onMessagePublished: (message) {
                  setState(() {
                    notices.add(message);
                  });
                },
                notices: notices,
              ),
            ),
          );
        } else if (title == 'Reports') {
          // Navigate to Reports page
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
