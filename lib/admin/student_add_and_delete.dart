import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StudentAddAndDeletePage extends StatefulWidget {
  @override
  _StudentAddAndDeletePageState createState() =>
      _StudentAddAndDeletePageState();
}

class _StudentAddAndDeletePageState extends State<StudentAddAndDeletePage> {
  List<Map<String, dynamic>> students = [];
  bool isLoading = true;
  final String apiUrl =
      'https://student-attendance-system-ckb1.onrender.com/api/student/all-students';
  final String addStudentApiUrl =
      'https://student-attendance-system-ckb1.onrender.com/api/student/new-student';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchStudents() async {
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

      print('Fetch Response status: ${response.statusCode}');
      print('Fetch Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          students = data
              .map((student) => {
                    'id': student['_id'] ?? '',
                    'name':
                        '${student['fName'] ?? ''} ${student['lName'] ?? ''}'
                            .trim(),
                    'email': student['email'] ?? 'No email',
                    'enrollNo':
                        student['enrollNo']?.toString() ?? 'No enrollNo',
                    'year': student['year']?.toString() ?? 'No year',
                    'section': student['section'] ?? 'No section',
                    'fatherName': student['fatherName'] ?? 'No father name',
                    'motherName': student['motherName'] ?? 'No mother name',
                    'dob': student['dob'] ?? 'No date of birth',
                  })
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load students')),
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

  Future<void> _deleteStudent(int index) async {
    final student = students[index];
    final studentId = student['id'];
    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$studentId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Delete Response status: ${response.statusCode}');
      print('Delete Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          students.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete student')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showStudentDetails(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Student Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Name: ${student['name']}',
                  style: Theme.of(context).textTheme.titleMedium),
              Text('Email: ${student['email']}',
                  style: Theme.of(context).textTheme.bodyLarge),
              Text('Enroll No: ${student['enrollNo']}',
                  style: Theme.of(context).textTheme.bodyLarge),
              Text('Year: ${student['year']}',
                  style: Theme.of(context).textTheme.bodyLarge),
              Text('Section: ${student['section']}',
                  style: Theme.of(context).textTheme.bodyLarge),
              Text('Father\'s Name: ${student['fatherName']}',
                  style: Theme.of(context).textTheme.bodyLarge),
              Text('Mother\'s Name: ${student['motherName']}',
                  style: Theme.of(context).textTheme.bodyLarge),
              Text('Date of Birth: ${student['dob']}',
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _addStudent(Map<String, dynamic> studentData) async {
    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(addStudentApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(studentData),
      );

      print('Add Student Response status: ${response.statusCode}');
      print('Add Student Response body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student added successfully')),
        );
        _fetchStudents(); // Refresh the student list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add student')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showAddStudentDialog() {
    final _formKey = GlobalKey<FormState>();
    final _fNameController = TextEditingController();
    final _lNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _enrollNoController = TextEditingController();
    final _yearController = TextEditingController();
    final _sectionController = TextEditingController();
    final _fatherNameController = TextEditingController();
    final _motherNameController = TextEditingController();
    final _dobController = TextEditingController();
    final _rollNoController = TextEditingController();
    final _genderController = TextEditingController();
    final _parentsContactController = TextEditingController();
    final _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Student'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _fNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _enrollNoController,
                  decoration: const InputDecoration(
                    labelText: 'Enroll No',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _sectionController,
                  decoration: const InputDecoration(
                    labelText: 'Section',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _fatherNameController,
                  decoration: const InputDecoration(
                    labelText: 'Father\'s Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _motherNameController,
                  decoration: const InputDecoration(
                    labelText: 'Mother\'s Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _rollNoController,
                  decoration: const InputDecoration(
                    labelText: 'Roll No',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _parentsContactController,
                  decoration: const InputDecoration(
                    labelText: 'Parents Contact',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final studentData = {
                        'fName': _fNameController.text,
                        'lName': _lNameController.text,
                        'email': _emailController.text,
                        'enrollNo': _enrollNoController.text,
                        'year': _yearController.text,
                        'section': _sectionController.text,
                        'fatherName': _fatherNameController.text,
                        'motherName': _motherNameController.text,
                        'dob': _dobController.text,
                        'rollNo': _rollNoController.text,
                        'gender': _genderController.text,
                        'parentsContact': _parentsContactController.text,
                        'password': _passwordController.text,
                      };

                      _addStudent(studentData);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add Student'),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Students'),
        backgroundColor: const Color(0xFFE0F7FA),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddStudentDialog,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(student['name'],
                        style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text('Enroll No: ${student['enrollNo']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteStudent(index),
                    ),
                    onTap: () => _showStudentDetails(student),
                  ),
                );
              },
            ),
    );
  }
}
