import 'package:flutter/material.dart';
import 'faculty_personal_info.dart';
import 'faculty_attendance_page.dart';
import 'courses_teaching_page.dart';

class FacultyHomePage extends StatefulWidget {
  final String username;
  final String token;
  final String email;
  final String facultyName;
  final List<dynamic> coursesTeaching;
  final List<dynamic> notices;

  const FacultyHomePage({
    Key? key,
    required this.username,
    required this.token,
    required this.email,
    required this.facultyName,
    required this.coursesTeaching,
    required this.notices, required classesTeaching,
  }) : super(key: key);

  @override
  _FacultyHomePageState createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  bool isLoadingFacultyInfo = false;

  @override
  void initState() {
    super.initState();
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
      "Name": widget.facultyName,
      "Email": widget.email,
      "CoursesTeaching": widget.coursesTeaching,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        title: Text(
          'Welcome ${widget.facultyName}',
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
            const SizedBox(height: 40.0), // Pushing the tiles down
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
                        context, 'Personal Info', Icons.person, Colors.blue),
                    buildTile(
                        context, 'Courses Teaching', Icons.book, Colors.green),
                    buildTile(context, 'Attendance Records', Icons.assignment,
                        Colors.orange),
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return FacultyInfoDialog(
                facultyInfo: response,
                username: widget.username,
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        tooltip: 'View Personal Info',
        child: const Icon(Icons.account_circle, color: Colors.white),
      ),
    );
  }

  Widget buildTile(
      BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == 'Personal Info') {
          fetchAndShowFacultyInfo(context);
        } else if (title == 'Courses Teaching') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoursesTeachingPage(
                facultyName: widget.facultyName,
                token: widget.token,
                facultyDetails: widget.coursesTeaching,
              ),
            ),
          );
        } else if (title == 'Attendance Records') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FacultyAttendancePage(
                facultyName: widget.facultyName,
                subjects: const ['Mathematics', 'Physics', 'Chemistry'],
                token: widget.token,
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

  Future<void> fetchAndShowFacultyInfo(BuildContext context) async {
    final response = await fetchFacultyInfo();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FacultyInfoDialog(
          facultyInfo: response,
          username: widget.username,
        );
      },
    );
  }
}

class FacultyInfoDialog extends StatelessWidget {
  final Map<String, Object> facultyInfo;
  final String username;

  const FacultyInfoDialog({
    Key? key,
    required this.facultyInfo,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Faculty Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Name: ${facultyInfo["Name"]}'),
          Text('Email: ${facultyInfo["Email"]}'),
          Text('Courses Teaching: ${facultyInfo["CoursesTeaching"].toString()}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
