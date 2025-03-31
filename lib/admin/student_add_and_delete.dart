import 'dart:io';

import 'package:diet_portal/admin/excel_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class StudentAddAndDeletePage extends StatefulWidget {
  const StudentAddAndDeletePage({super.key,});

  @override
  _StudentAddAndDeletePageState createState() =>
      _StudentAddAndDeletePageState();
}

class _StudentAddAndDeletePageState extends State<StudentAddAndDeletePage> {
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> courses = [];
  List<String> selectedCourses = [];

  bool isLoading = true;
  // ignore: unused_field
  String _message = '';

  final String apiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/student/all-students';
  final String addStudentApiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/student/new-student';
  final String removeStudentApiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/student/remove-student';
  final String coursesApiUrl =
      'https://attendance-management-system-jdbc.onrender.com/api/course/show-courses';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
    _fetchCourses();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
        Uri.parse(coursesApiUrl),  // Changed from apiUrl to coursesApiUrl
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          courses = data
              .map((course) => {
                    'id': course['_id'] ?? '',
                    'courseId': course['courseId'] ?? '',
                    'courseName': course['courseName'] ?? 'No name',
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
      print(
          'Delete Student Response Headers: ${response.headers}'); // Print response headers

      if (response.statusCode == 200) {
        setState(() {
          students.removeAt(index);
        });
        _showSnackBar('Student deleted successfully');
      } else {
        final responseBody = json.decode(response.body);
        final errorMessage =
            responseBody['message'] ?? 'Failed to delete student';
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
            onPressed: () {
              Navigator.of(context).pop();
              _showEditStudentDialog(student);
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

  Future<void> _updateStudent(Map<String, dynamic> studentData, String enrollNo) async {
  final token = await _getToken();

  if (token == null) {
    _showSnackBar('No token found');
    return;
  }

  try {
    final response = await http.put(
      Uri.parse('${apiUrl.replaceAll('all-students', 'update-student')}/$enrollNo'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(studentData),
    );

    print('Update Student Response: ${response.body}');

    if (response.statusCode == 200) {
      _showSnackBar('Student updated successfully');
      _fetchStudents();
    } else {
      _showSnackBar('Failed to update student');
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
      'fatherName': TextEditingController(),
      'motherName': TextEditingController(),
      'rollNo': TextEditingController(),
      'parentsContact': TextEditingController(),
      'password': TextEditingController(),
      'dob': TextEditingController(), // Add DOB controller
    };

    String selectedYear = '1'; // Default selected year
    String selectedSection = 'A'; // Default selected section
    String selectedGender = 'M'; // Default selected gender
    List<Map<String, dynamic>> selectedCourses = []; // To hold selected courses



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

                // Year Dropdown
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField<String>(
                    value: selectedYear,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    items: ['1', '2'].map((String year) {
                      return DropdownMenuItem<String>(
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

                // Section Dropdown
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField<String>(
                    value: selectedSection,
                    decoration: const InputDecoration(
                      labelText: 'Section',
                      border: OutlineInputBorder(),
                    ),
                    items: ['A', 'B'].map((String section) {
                      return DropdownMenuItem<String>(
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

                // Date of Birth Text Field
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: TextFormField(
                //     controller: _controllers['dob'], // Use controller for DOB
                //     decoration: InputDecoration(
                //       labelText: 'Date of Birth (DD/MM/YYYY)',
                //       border: OutlineInputBorder(),
                //     ),
                //     keyboardType: TextInputType.datetime,
                //     validator: (value) {
                //       final dobPattern = r'^\d{2}/\d{2}/\d{4}$';
                //       final isValid = RegExp(dobPattern).hasMatch(value ?? '');
                //       return isValid ? null : 'Please enter a valid DOB';
                //     },
                //     onChanged: (value) {
                //       // Automatically format the date input
                //       if (value.length == 2 || value.length == 5) {
                //         _controllers['dob']!.text += '/';
                //         _controllers['dob']!.selection =
                //             TextSelection.fromPosition(
                //           TextPosition(
                //               offset: _controllers['dob']!.text.length),
                //         );
                //       }
                //     },
                //   ),
                // ),

                // Gender Dropdown
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: ['M', 'F'].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender == 'M' ? 'Male' : 'Female'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value ?? 'M';
                      });
                    },
                  ),
                ),

                // Courses Dropdown
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MultiSelectDialogField(
                    items: courses.map((course) {
                      return MultiSelectItem(course,
                          '${course['courseName']} [${course['courseId']}]');
                    }).toList(),
                    title: const Text('Select Courses'),
                    initialValue: selectedCourses,
                    onConfirm: (values) {
                      setState(() {
                        selectedCourses = values.cast<Map<String, dynamic>>();
                      });
                    },
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Create studentData as Map<String, dynamic>
                      final Map<String, dynamic> studentData = _controllers.map(
                        (key, controller) => MapEntry(key, controller.text),
                      );

                      // Adding year and section to studentData
                      studentData['year'] = selectedYear;
                      studentData['section'] = selectedSection;
                      studentData['gender'] =
                          selectedGender; // Add selected gender

                      // Prepare course data as a list of course IDs
                      studentData['courses'] = selectedCourses.map((course) {
                        return course['courseId']; // Only get courseId
                      }).toList(); // Convert to List<int>

                      // Debug: Print student data for verification
                      print(studentData);

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

  Future<void> _uploadExcelFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      setState(() => isLoading = true);
      
      final excelService = ExcelService();
      final response = await excelService.processExcelData(result.files.first.bytes!);
      
      _showSnackBar(response['message']);
      
      if (response['success']) {
        _fetchStudents(); // Refresh the student list
      }
    }
  } catch (e) {
    _showSnackBar('Error uploading file: $e');
  } finally {
    setState(() => isLoading = false);
  }
}

Future<void> _downloadTemplate() async {
  try {
    final excelService = ExcelService();
    final bytes = await excelService.generateTemplate();
    
    // For web platform
    // html.AnchorElement(
    //   href: html.Url.createObjectUrlFromBlob(
    //     html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
    //   ),
    // )
    //   ..setAttribute('download', 'student_template.xlsx')
    //   ..click();
    
    // For mobile/desktop platforms
    final String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      final file = File('$path/student_template.xlsx');
      await file.writeAsBytes(bytes);
      _showSnackBar('Template downloaded successfully');
    }
  } catch (e) {
    _showSnackBar('Error downloading template: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Students'),
        backgroundColor: const Color(0xFFE0F7FA),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadTemplate,
            tooltip: 'Download Template',
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _uploadExcelFile,
            tooltip: 'Upload Excel File',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddStudentDialog,
            tooltip: 'Add Student',
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

  void _showEditStudentDialog(Map<String, dynamic> student) {
  final _formKey = GlobalKey<FormState>();
  final _controllers = {
    'fName': TextEditingController(text: student['name'].split(' ')[0]),
    'lName': TextEditingController(
        text: student['name'].split(' ').length > 1 ? student['name'].split(' ')[1] : ''),
    'email': TextEditingController(text: student['email']),
    'enrollNo': TextEditingController(text: student['enrollNo']),
    'fatherName': TextEditingController(text: student['fatherName']),
    'motherName': TextEditingController(text: student['motherName']),
    'dob': TextEditingController(text: student['dob']),
  };

  String selectedYear = student['year'].toString();
  String selectedSection = student['section'];
  String originalEnrollNo = student['enrollNo'];

  // Function to check if enrollment number is unique
  Future<bool> isEnrollmentUnique(String enrollNo) async {
    if (enrollNo == originalEnrollNo) return true; // Allow same number if unchanged
    
    return !students.any((s) => s['enrollNo'].toString() == enrollNo);
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Student'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      border: const OutlineInputBorder(),
                    ),
                    enabled: key != 'enrollNo', // Disable enrollment number editing
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter $labelText';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),
              
              // Year Dropdown
              DropdownButtonFormField<String>(
                value: selectedYear,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                items: ['1', '2'].map((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedYear = value ?? '1';
                },
              ),

              const SizedBox(height: 10),

              // Section Dropdown
              DropdownButtonFormField<String>(
                value: selectedSection,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  border: OutlineInputBorder(),
                ),
                items: ['A', 'B'].map((String section) {
                  return DropdownMenuItem<String>(
                    value: section,
                    child: Text(section),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedSection = value ?? 'A';
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final enrollNo = _controllers['enrollNo']!.text;
              final isUnique = await isEnrollmentUnique(enrollNo);

              if (!isUnique) {
                _showSnackBar('Enrollment number must be unique');
                return;
              }

              final updatedData = {
                'fName': _controllers['fName']!.text,
                'lName': _controllers['lName']!.text,
                'email': _controllers['email']!.text,
                'enrollNo': enrollNo,
                'fatherName': _controllers['fatherName']!.text,
                'motherName': _controllers['motherName']!.text,
                'dob': _controllers['dob']!.text,
                'year': selectedYear,
                'section': selectedSection,
              };

              _updateStudent(updatedData, student['enrollNo']);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
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
