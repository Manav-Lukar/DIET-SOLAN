import 'package:flutter/material.dart';
import 'package:diet_portal/student/FeeDetailsPage.dart';
import 'package:diet_portal/student/class_attendance_page.dart';
import 'package:diet_portal/student/academic_details_page.dart';
import 'package:diet_portal/student/student_personal_info.dart';

class StudentHomePage extends StatelessWidget {
  final String username;
  final List<String> notices;
  final List<dynamic> subjectsData; // This needs to be converted to List<int>
  final Map<String, dynamic> studentDetails;

  const StudentHomePage({
    Key? key,
    required this.username,
    required this.notices,
    required this.subjectsData,
    required this.studentDetails, required String rollNo, required String studentName, required String year, required section,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        title: Text(
          'Welcome, ${studentDetails['fName']}',
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
                    buildTile(
                      context, 
                      'Personal Info', 
                      Icons.person, 
                      Colors.blue,
                      () => showDialog(
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
                              'Mother Name': studentDetails['motherName'] ?? '',
                            },
                            username: username,
                            facultyInfo: {},
                            role: '',
                            info: {},
                          );
                        },
                      ),
                    ),
                    buildTile(
                      context, 
                      'Fee Details', 
                      Icons.account_balance, 
                      Colors.green,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeeDetailsPage(
                            username: username,
                            studentDetails: studentDetails,
                            studentName: studentDetails['fName'],
                            rollNo: studentDetails['rollNo'].toString(),
                          ),
                        ),
                      ),
                    ),
                    buildTile(
                      context, 
                      'Academic Details', 
                      Icons.school, 
                      Colors.orange,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AcademicDetailsPage(
                            username: username,
                            subjectsData: _convertToIntList(subjectsData), // Convert to List<int>
                            studentDetails: studentDetails,
                            studentName: studentDetails['fName'],
                            rollNo: studentDetails['rollNo'].toString(), subjects: [],
                          ),
                        ),
                      ),
                    ),
                    buildTile(
                      context, 
                      'Class Attendance', 
                      Icons.assignment, 
                      Colors.red,
                      () => Navigator.push(
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
                            studentName: studentDetails['fName'],
                            section: studentDetails['section'] ?? '', studentDetails: {},
                          ),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Notices',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Refresh button (if needed)
                // IconButton(
                //   icon: isLoadingNotices
                //       ? const CircularProgressIndicator()
                //       : const Icon(Icons.refresh, color: Colors.blue),
                //   onPressed: isLoadingNotices ? null : fetchNotices,
                // ),
              ],
            ),
            const SizedBox(height: 10),
            ...notices.map((notice) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notifications, size: 16, color: Colors.black54),
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

  // Helper method to convert List<dynamic> to List<int>
  List<int> _convertToIntList(List<dynamic> data) {
    return data.map((item) => item is int ? item : int.tryParse(item.toString()) ?? 0).toList();
  }
}
