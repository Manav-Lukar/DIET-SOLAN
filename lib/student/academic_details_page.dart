import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcademicDetailsPage extends StatefulWidget {
  final String username;
  final List<int> subjectsData;
  final Map<String, dynamic> studentDetails;
  final String studentName;
  final String rollNo;

  const AcademicDetailsPage({
    super.key,
    required this.username,
    required this.subjectsData,
    required this.studentDetails,
    required this.studentName,
    required this.rollNo,
    required List<String> subjects,
    required String token,
  });

  @override
  _AcademicDetailsPageState createState() => _AcademicDetailsPageState();
}

class _AcademicDetailsPageState extends State<AcademicDetailsPage> {
  List<String> _courses = [];
  String? _token;

  // Course data mapping
  final Map<int, String> _courseData = {
    101: 'Education Technology',
    102: 'Psychology',
    103: 'Maths',
    104: 'Education 102\'',
    105: 'EVS',
    106: 'Hindi',
    107: 'Work Education',
    108: 'Physical Education',
    109: 'English',
    110: 'Fine Art',
    111: 'Music',
    112: 'Education103\'',
    201: 'Psychology',
    202: 'English',
    203: 'Maths',
    204: 'Hindi',
    205: 'Fine Arts',
    206: 'Music',
    207: 'Physical Education',
    208: 'Social Science',
    209: 'Education',
    210: 'Planning and Management',
    211: 'Science Education',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch the saved token
    _token = prefs.getString('token');

    // Fetch the saved course IDs and decode them into a List<int>
    final List<String>? savedCourses = prefs.getStringList('courses');

    if (savedCourses != null) {
      // Convert course IDs to integers and then fetch course names
      final List<String> courseNames = savedCourses.map((courseIdStr) {
        final int courseId = int.tryParse(courseIdStr) ?? 0;
        return _courseData[courseId] ?? 'Unknown Course';
      }).toList();

      setState(() {
        _courses = courseNames;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract details from the API response
    final String name = widget.studentDetails['fName'] ?? 'N/A';
    final String rollNo = widget.studentDetails['rollNo']?.toString() ?? 'N/A';
    final String year = widget.studentDetails['year']?.toString() ?? 'N/A';
    final String section = widget.studentDetails['section'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffe6f7ff),
                Color(0xffcceeff),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffe6f7ff),
              Color(0xffcceeff),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.9),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Roll No.: $rollNo',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Year: $year',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Section: $section',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Courses:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            ..._courses.isEmpty
                ? [const Text(
                    'No courses available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  )]
                : _courses.map((course) {
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        title: Text(
                          course,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        leading: Icon(Icons.school, color: Colors.blue.shade300),
                      ),
                    );
                  }).toList(),
          ],
        ),
      ),
    );
  }
}
