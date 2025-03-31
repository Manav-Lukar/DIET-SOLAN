import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CourseAddAndDeletePage extends StatefulWidget {
  @override
  _CourseAddAndDeletePageState createState() => _CourseAddAndDeletePageState();
}

class _CourseAddAndDeletePageState extends State<CourseAddAndDeletePage> {
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;

  final String apiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/course/show-courses';
  final String addCourseApiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/course/add-course';
  final String deleteCourseApiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/course/remove-course';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> _isCourseCodeUnique(String courseId, {String? originalCourseId}) async {
    // If checking against the same code, it's unique
    if (courseId == originalCourseId) return true;
    
    // Check if any other course has this code
    return !courses.any((course) => 
      course['courseId'].toString() == courseId.toString() && 
      course['courseId'].toString() != originalCourseId
    );
  }

  Future<void> _fetchCourses() async {
    setState(() {
      isLoading = true;
    });

    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          courses = data
              .map((course) => {
                    'id': course['_id'] ?? '',
                    'courseId': course['courseId'] ?? '',
                    'name': course['courseName'] ?? 'No name',
                    'year': course['year'] ?? 1,
                  })
              .toList();
        });
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Session expired, please log in again.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load courses')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteCourse(int index) async {
    final course = courses[index];
    final courseId = course['courseId'];
    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse(deleteCourseApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'courseId': courseId}),
      );

      // Debug prints
      print('Delete Course Response Status: ${response.statusCode}');
      print('Delete Course Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          courses.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted successfully')),
        );
      } else {
        // Print response body to debug why the deletion failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete course: ${response.body}')),
        );
      }
    } catch (e) {
      // Print detailed error message for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _addCourse(Map<String, dynamic> courseData) async {
    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(addCourseApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(courseData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course added successfully')),
        );
        _fetchCourses();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add course')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateCourse(Map<String, dynamic> courseData) async {
    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('${apiUrl.replaceAll('show-courses', 'update-course')}/${courseData['courseId']}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(courseData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course updated successfully')),
        );
        _fetchCourses();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update course')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showAddCourseDialog() {
    final _formKey = GlobalKey<FormState>();
    final _courseNameController = TextEditingController();
    final _courseCodeController = TextEditingController();
    final _yearController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Course'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _courseNameController,
                  decoration: const InputDecoration(
                    labelText: 'Course Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the course name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _courseCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Course Code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the course code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the year';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final courseData = {
                  'courseId': int.parse(_courseCodeController.text),
                  'courseName': _courseNameController.text,
                  'year': int.parse(_yearController.text),
                };
                _addCourse(courseData);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add Course'),
          ),
        ],
      ),
    );
  }

  void _showCourseDetailsDialog(Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(course['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course Code: ${course['courseId']}'),
            Text('Year: ${course['year']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditCourseDialog(course);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Replace existing _showEditCourseDialog method
void _showEditCourseDialog(Map<String, dynamic> course) {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController(text: course['name']);
  final _courseCodeController = TextEditingController(text: course['courseId'].toString());
  final _yearController = TextEditingController(text: course['year'].toString());
  final originalCourseId = course['courseId'].toString();
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Course'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _courseNameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Replace the TextFormField for course code with this implementation
              TextFormField(
                controller: _courseCodeController,
                decoration: const InputDecoration(
                  labelText: 'Course Code',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  // Perform validation on change
                  if (value.isNotEmpty) {
                    final isUnique = await _isCourseCodeUnique(value, originalCourseId: originalCourseId);
                    if (!isUnique) {
                      _formKey.currentState?.validate(); // Trigger validation
                    }
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course code';
                  }
                  // Store the current validation state
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final newCourseId = _courseCodeController.text;
              final isUnique = await _isCourseCodeUnique(newCourseId, originalCourseId: originalCourseId);
              
              if (!isUnique) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Course code must be unique')),
                );
                return;
              }

              final updatedCourse = {
                'courseId': int.parse(newCourseId),
                'courseName': _courseNameController.text,
                'year': int.parse(_yearController.text),
              };
              _updateCourse(updatedCourse);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save Changes'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Courses'),
        backgroundColor: const Color(0xFFE0F7FA),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCourseDialog,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8), // Reduced padding
                    title: Text(
                      course['name'],
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium // Adjusted font size
                          ?.copyWith(fontSize: 18), // Smaller font size
                    ),
                    subtitle: Text(
                      'Code: ${course['courseId']}',
                      style: TextStyle(fontSize: 11), // Smaller font size
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Course'),
                            content: const Text(
                                'Do you want to delete this course?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  _deleteCourse(index); // Proceed with deletion
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    onTap: () => _showCourseDetailsDialog(course),
                  ),
                );
              },
            ),
    );
  }
}
