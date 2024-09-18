import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonDecode

class CoursesTeachingPage extends StatefulWidget {
  final String facultyName;
  final String token;

  const CoursesTeachingPage({
    super.key,
    required this.facultyName,
    required this.token, required facultyDetails, required String username, required List coursesTeaching,
  });

  @override
  _CoursesTeachingPageState createState() => _CoursesTeachingPageState();
}

class _CoursesTeachingPageState extends State<CoursesTeachingPage> {
  bool isLoading = true;
  List<String> _coursesTeaching = [];
  String errorMessage = '';
  String? facultyEmail;
  String? facultyYear;
  String? facultySection;

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
    final token = prefs.getString('token') ?? widget.token;

    // Fetch the saved coursesTeaching and decode them into a List<String>
    final String? savedCoursesTeaching = prefs.getString('coursesTeaching');
    final String? savedFacultyEmail = prefs.getString('facultyEmail');
    final String? savedFacultyYear = prefs.getString('facultyYear');
    final String? savedFacultySection = prefs.getString('facultySection');

    if (savedCoursesTeaching != null) {
      try {
        final List<dynamic> coursesTeachingJson = jsonDecode(savedCoursesTeaching);
        final List<int> courseIds = coursesTeachingJson.map((e) => int.tryParse(e.toString()) ?? 0).toList();

        // Convert course IDs to course names
        final List<String> courseNames = courseIds.map((courseId) => _courseData[courseId] ?? 'Unknown Course').toList();

        setState(() {
          _coursesTeaching = courseNames;
          errorMessage = '';
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Error parsing coursesTeaching data';
        });
      }
    } else {
      setState(() {
        errorMessage = 'No courses available.';
      });
    }

    setState(() {
      facultyEmail = savedFacultyEmail;
      facultyYear = savedFacultyYear;
      facultySection = savedFacultySection;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses Teaching'),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView(
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
                                'Name: ${widget.facultyName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (facultyEmail != null) ...[
                                Text(
                                  'Email: $facultyEmail',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (facultyYear != null) ...[
                                Text(
                                  'Year: $facultyYear',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (facultySection != null) ...[
                                Text(
                                  'Section: $facultySection',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Courses Teaching:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._coursesTeaching.isEmpty
                          ? [const Text(
                              'No courses available.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            )]
                          : _coursesTeaching.map((course) {
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
