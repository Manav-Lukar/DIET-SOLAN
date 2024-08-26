import 'package:diet_portal/admin/faculty_add_and_delete_faculty.dart';
import 'package:flutter/material.dart';
import 'admin_personal_info.dart';
import 'student_add_and_delete.dart'; // Import the Student management file
import 'parent_add_and_delete.dart';  // Import the Parent management file
import 'course_add_and_delete.dart';  // Import the Course management file
import 'notice_publish.dart'; // Import the Notice publishing file

class AdminHomePage extends StatelessWidget {
  final Map<String, dynamic> adminInfo;

  const AdminHomePage({
    super.key,
    required this.adminInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        title: const Text(
          'Welcome, Admin',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false, // Disables the back button
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
                  childAspectRatio: 0.9,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    buildTile(
                      context,
                      'Personal Info',
                      Icons.person,
                      Colors.blue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminPersonalInfoPage(
                            adminInfo: {
                              'name': adminInfo['name'],
                              'email': adminInfo['email'],
                            },
                          ),
                        ),
                      ),
                    ),
                    buildTile(
                      context,
                      'Faculty',
                      Icons.school,
                      Colors.green,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FacultyAddAndDeletePage(),
                        ),
                      ),
                    ),
                    buildTile(
                      context,
                      'Student',
                      Icons.people,
                      Colors.orange,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentAddAndDeletePage(),
                        ),
                      ),
                    ),
                    buildTile(
                      context,
                      'Parent',
                      Icons.family_restroom,
                      Colors.teal,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParentAddAndDeletePage(),
                        ),
                      ),
                    ),
                    buildTile(
                      context,
                      'Course',
                      Icons.book,
                      Colors.purple,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseAddAndDeletePage(),
                        ),
                      ),
                    ),
                    buildTile(
                      context,
                      'Notice',
                      Icons.notifications,
                      Colors.red,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoticePublishPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
