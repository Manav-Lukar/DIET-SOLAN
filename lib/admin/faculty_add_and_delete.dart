import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FacultyAddAndDeletePage extends StatefulWidget {
  @override
  _FacultyAddAndDeletePageState createState() =>
      _FacultyAddAndDeletePageState();
}

class _FacultyAddAndDeletePageState extends State<FacultyAddAndDeletePage> {
  List<Map<String, dynamic>> faculty = [];
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;
  List<String> selectedCourses = [];

  final String apiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/faculty/show-faculty';
  final String addFacultyApiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/faculty/add-faculty';
  final String deleteFacultyApiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/faculty/remove-faculty';
  final String coursesApiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/course/show-courses';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _fetchFaculty();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchCourses() async {
    final token = await _getToken();

    if (token == null) {
      _showSnackBar('No token found');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(coursesApiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          courses = data
              .map((course) => {
                    'id': course['courseId'].toString() ?? '',
                    'name': course['courseName'] ?? 'No name',
                  })
              .toList();
        });
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<void> _fetchFaculty() async {
    setState(() => isLoading = true);
    final token = await _getToken();

    if (token == null) {
      _showSnackBar('No token found');
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          faculty = data
              .map((fac) => {
                    'id': fac['_id'] ?? '',
                    'name': fac['name'] ?? 'No name',
                    'email': fac['email'] ?? 'No email',
                    'role': fac['role'] ?? 'No role',
                    'coursesTeaching':
                        fac['coursesTeaching']?.join(', ') ?? 'None',
                    'classesTeaching': fac['classesTeaching']
                            ?.map((c) =>
                                'Year ${c['year']}, Sections: ${c['sections'].join(', ')}')
                            ?.join('\n') ??
                        'None',
                  })
              .toList();
        });
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteFacultyByNameAndEmail(
      int index, String name, String email) async {
    final token = await _getToken();

    if (token == null) {
      _showSnackBar('No token found');
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$deleteFacultyApiUrl'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          faculty.removeAt(index);
        });
        _showSnackBar('Faculty deleted successfully');
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showDeleteFacultyDialog(int index) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Faculty'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the name'
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter the email'
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _deleteFacultyByNameAndEmail(
                  index,
                  _nameController.text,
                  _emailController.text,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _addFaculty(Map<String, dynamic> facultyData) async {
    final token = await _getToken();

    if (token == null) {
      _showSnackBar('No token found');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(addFacultyApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(facultyData),
      );

      if (response.statusCode == 201) {
        _showSnackBar('Faculty added successfully');
        _fetchFaculty();
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _handleHttpError(http.Response response) {
    final responseBody = json.decode(response.body);
    final errorMessage = responseBody['message'] ?? 'An error occurred';
    _showSnackBar(errorMessage);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showFacultyDetails(Map<String, dynamic> faculty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Faculty Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ...[
                'Name',
                'Email',
                'Role',
                'Courses Teaching',
                'Classes Teaching'
              ].map((label) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '$label: ${faculty[_getKey(label)]}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getKey(String label) {
    switch (label) {
      case 'Name':
        return 'name';
      case 'Email':
        return 'email';
      case 'Role':
        return 'role';
      case 'Courses Teaching':
        return 'coursesTeaching';
      case 'Classes Teaching':
        return 'classesTeaching';
      default:
        return '';
    }
  }

  void _showAddFacultyDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    List<String> selectedYears = [];
    List<String> selectedSections = [];
    String selectedYear = '1';
    String selectedSection = 'A';
    String selectedRole = 'Faculty'; // Default role

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Faculty'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter the name'
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter the email'
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter the password'
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Faculty', 'Admin'].map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value ?? 'Faculty';
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField<String>(
                      value: selectedYear,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      items: ['1', '2', '3', '4'].map((year) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value ?? '1';
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField<String>(
                      value: selectedSection,
                      decoration: const InputDecoration(
                        labelText: 'Section',
                        border: OutlineInputBorder(),
                      ),
                      items: ['A', 'B', 'C'].map((section) {
                        return DropdownMenuItem(
                          value: section,
                          child: Text(section),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSection = value ?? 'A';
                        });
                      },
                    ),
                  ),
                  // Add course selection
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Wrap(
                      spacing: 8.0,
                      children: courses.map((course) {
                        return FilterChip(
                          label: Text(course['name']),
                          selected: selectedCourses.contains(course['id']),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedCourses.add(course['id']);
                              } else {
                                selectedCourses.remove(course['id']);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _addFaculty({
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'password': _passwordController.text,
                    'role': selectedRole,
                    'coursesTeaching': selectedCourses,
                    'classesTeaching': [
                      {
                        'year': selectedYear,
                        'sections': [selectedSection]
                      },
                    ],
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Management'),
        backgroundColor: const Color(0xFFE0F7FA), // Set AppBar color
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddFacultyDialog,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFE0F7FA), // Set background color
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: faculty.length,
                itemBuilder: (context, index) {
                  elevation:
                  5;

                  final fac = faculty[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    child: ListTile(
                      title: Text(fac['name']),
                      subtitle: Text('Email: ${fac['email']}'),
                      onTap: () => _showFacultyDetails(fac),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteFacultyDialog(index),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
