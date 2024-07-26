
import 'package:flutter/material.dart';
import 'package:diet_portal/faculty/ClassSchedulePage.dart';
import 'package:diet_portal/faculty/exam_papers_page.dart';
import 'package:diet_portal/faculty/faculty_attendance_page.dart';
import 'package:diet_portal/faculty/notices_page.dart';
import 'package:diet_portal/faculty/faculty_personal_info.dart'; // Updated import

class FacultyHomePage extends StatefulWidget {
  final String username;

  const FacultyHomePage({super.key, required this.username, required email, required notices});

  @override
  _FacultyHomePageState createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  List<String> notices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Welcome, ${widget.username}',
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
                    buildTile(context, 'Class Schedule', Icons.calendar_today),
                    buildTile(context, 'Attendance Records', Icons.assignment),
                    buildTile(context, 'Exam Papers', Icons.note),
                    buildTile(context, 'Notices', Icons.notifications),
                    buildTile(context, 'Reports', Icons.report),
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
      onTap: () async {
        if (title == 'Personal Info') {
          // Fetch faculty info here before showing dialog
          final response = await fetchFacultyInfo(); // Fetch data
          if (response != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FacultyInfoDialog(
                  facultyInfo: response,
                  studentInfo: const {}, // Adjust as per your app logic
                  username: widget.username,
                );
              },
            );
          }
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
                subjects: const [
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

  Future<Map<String, dynamic>?> fetchFacultyInfo() async {
    // Implement API call here to fetch faculty info
    // For now, return a sample response
    return {
      "Name": "Shubham",
      "Email": "shubham5818@gmail.com",
      "CoursesTeaching": [103, 104, 203, 204],
      "ClassesTeaching": [
        {"year": 1, "sections": ["A", "B"]},
        {"year": 2, "sections": ["A"]}
      ],
      "Role": "Faculty"
    };
  }
}
