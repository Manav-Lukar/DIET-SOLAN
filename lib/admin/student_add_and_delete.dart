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
  final String removeStudentApiUrl =
      'https://student-attendance-system-ckb1.onrender.com/api/student/remove-student';

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

      print(
          'Fetch Students Response: ${response.body}'); // Print response for debugging

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
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
        _showSnackBar('Failed to load students');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

Future<void> _deleteStudent(int index, int enrollNo) async {
  final token = await _getToken();

  if (token == null) {
    _showSnackBar('No token found');
    return;
  }

  try {
    final uri = Uri.parse('$removeStudentApiUrl?enrollNo=$enrollNo');

    // Print request details
    print('Deleting student with enrollNo: $enrollNo');
    print('Request URL: $uri');
    print('Authorization Header: Bearer $token');

    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Print detailed response for debugging
    print('Delete Student Response Status: ${response.statusCode}');
    print('Delete Student Response Body: ${response.body}');
    print('Delete Student Response Headers: ${response.headers}');  // Print response headers

    if (response.statusCode == 200) {
      setState(() {
        students.removeAt(index);
      });
      _showSnackBar('Student deleted successfully');
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to delete student';
      _showSnackBar(errorMessage);
    }
  } catch (e) {
    _showSnackBar('Error: $e');
  }
}


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showStudentDetails(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Student Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ...[
                'Name',
                'Email',
                'Enroll No',
                'Year',
                'Section',
                'Father\'s Name',
                'Mother\'s Name',
                'Date of Birth'
              ].map((label) => Text('$label: ${student[_getKey(label)]}',
                  style: Theme.of(context).textTheme.bodyLarge)),
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
      case 'Enroll No':
        return 'enrollNo';
      case 'Year':
        return 'year';
      case 'Section':
        return 'section';
      case 'Father\'s Name':
        return 'fatherName';
      case 'Mother\'s Name':
        return 'motherName';
      case 'Date of Birth':
        return 'dob';
      default:
        return '';
    }
  }

  Future<void> _addStudent(Map<String, dynamic> studentData) async {
    final token = await _getToken();

    if (token == null) {
      _showSnackBar('No token found');
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

      print(
          'Add Student Response: ${response.body}'); // Print response for debugging

      if (response.statusCode == 201) {
        _showSnackBar('Student added successfully');
        _fetchStudents();
      } else {
        _showSnackBar('Failed to add student');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showAddStudentDialog() {
    final _formKey = GlobalKey<FormState>();
    final _controllers = {
      'fName': TextEditingController(),
      'lName': TextEditingController(),
      'email': TextEditingController(),
      'enrollNo': TextEditingController(),
      'year': TextEditingController(),
      'section': TextEditingController(),
      'fatherName': TextEditingController(),
      'motherName': TextEditingController(),
      'dob': TextEditingController(),
      'rollNo': TextEditingController(),
      'gender': TextEditingController(),
      'parentsContact': TextEditingController(),
      'password': TextEditingController(),
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Student'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._controllers.entries.map((entry) {
                  final key = entry.key;
                  final controller = entry.value;
                  final labelText = _getLabelText(key);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: labelText,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: _getKeyboardType(key),
                      obscureText: key == 'password',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter $labelText'
                          : null,
                    ),
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final studentData = _controllers.map(
                          (key, controller) => MapEntry(key, controller.text));
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getLabelText(String key) {
    switch (key) {
      case 'fName':
        return 'First Name';
      case 'lName':
        return 'Last Name';
      case 'email':
        return 'Email';
      case 'enrollNo':
        return 'Enroll No';
      case 'year':
        return 'Year';
      case 'section':
        return 'Section';
      case 'fatherName':
        return 'Father\'s Name';
      case 'motherName':
        return 'Mother\'s Name';
      case 'dob':
        return 'Date of Birth';
      case 'rollNo':
        return 'Roll No';
      case 'gender':
        return 'Gender';
      case 'parentsContact':
        return 'Parents Contact';
      case 'password':
        return 'Password';
      default:
        return '';
    }
  }

  TextInputType _getKeyboardType(String key) {
    if (key == 'email') return TextInputType.emailAddress;
    if (key == 'enrollNo' || key == 'year') return TextInputType.number;
    return TextInputType.text;
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(student['name']),
                    subtitle: Text('Enroll No: ${student['enrollNo']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(student['enrollNo']),
                    ),
                    onTap: () => _showStudentDetails(student),
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteDialog(String enrollNo) {
    final _enrollNoController = TextEditingController(text: enrollNo);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _enrollNoController,
              decoration: const InputDecoration(
                labelText: 'Enter Enroll No',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final enrollNo = int.tryParse(_enrollNoController.text) ?? 0;
              if (enrollNo > 0) {
                _deleteStudent(
                    students.indexWhere(
                        (student) => student['enrollNo'] == enrollNo),
                    enrollNo);
                Navigator.of(context).pop();
              } else {
                _showSnackBar('Invalid enroll number');
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
}
