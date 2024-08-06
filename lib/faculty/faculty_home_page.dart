import 'package:flutter/material.dart';
import 'package:diet_portal/faculty/ClassSchedulePage.dart';
import 'package:diet_portal/faculty/notices_page.dart';
import 'package:diet_portal/faculty/faculty_personal_info.dart';
import 'package:diet_portal/faculty/faculty_attendance_page.dart';

class FacultyHomePage extends StatefulWidget {
  final String username;

  const FacultyHomePage({
    Key? key,
    required this.username, required notices, required email, required String facultyName,
  }) : super(key: key);

  @override
  _FacultyHomePageState createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  List<String> notices = [];
  bool isLoadingNotices = false;
  bool isLoadingFacultyInfo = false;

  @override
  void initState() {
    super.initState();
    fetchNotices(); // Fetch notices on initial load
  }

  Future<void> fetchNotices() async {
    setState(() {
      isLoadingNotices = true;
    });
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      notices = ['Notice 1', 'Notice 2']; // Update with actual data
      isLoadingNotices = false;
    });
  }

  Future<Map<String, Object>> fetchFacultyInfo() async {
    setState(() {
      isLoadingFacultyInfo = true;
    });
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoadingFacultyInfo = false;
    });
    return {
      "Name": "Shubham",
      "Email": "shubham5818@gmail.com",
      "CoursesTeaching": [103, 104, 203]
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        title: Text(
          'Welcome, ${widget.username}',
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
                    buildTile(context, 'Class Schedule', Icons.calendar_today, Colors.green),
                    buildTile(context, 'Attendance Records', Icons.assignment, Colors.orange),
                    buildTile(context, 'Notices', Icons.notifications, Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final response = await fetchFacultyInfo();
          if (response != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FacultyInfoDialog(
                  facultyInfo: response,
                  studentInfo: const {},
                  username: widget.username,
                );
              },
            );
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.account_circle, color: Colors.white),
        tooltip: 'View Personal Info',
      ),
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
                  icon: isLoadingNotices
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.refresh, color: Colors.blue),
                  onPressed: isLoadingNotices ? null : fetchNotices,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...notices.map((notice) => Padding(
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
      onTap: () async {
        if (title == 'Personal Info') {
          final response = await fetchFacultyInfo();
          if (response != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FacultyInfoDialog(
                  facultyInfo: response,
                  studentInfo: const {},
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
                ],
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
