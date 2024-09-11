import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Faculty {
  final String id;
  final String name;
  final String email;

  Faculty({
    required this.id,
    required this.name,
    required this.email,
  });

  // Factory constructor to create a Faculty from JSON
  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
    );
  }
}

class FacultyAddAndDeletePage extends StatefulWidget {
  const FacultyAddAndDeletePage({super.key});

  @override
  _FacultyAddAndDeletePageState createState() => _FacultyAddAndDeletePageState();
}

class _FacultyAddAndDeletePageState extends State<FacultyAddAndDeletePage> {
  List<Faculty> _faculties = [];
  bool isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _getTokenAndFetchFaculties();
  }

  Future<void> _getTokenAndFetchFaculties() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');  // Retrieve the token

    if (_token != null) {
      fetchFaculties();
    } else {
      print('Token not found');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchFaculties() async {
    final url = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/show-faculty?role=admin';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $_token',
      });

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _faculties = data.map((facultyJson) => Faculty.fromJson(facultyJson)).toList();
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        print('Faculties not found! Please check the endpoint and parameters.');
        setState(() {
          isLoading = false;
        });
      } else {
        print('Failed to load faculties. Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  Future<void> _addFaculty(String name, String email) async {
    final url = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/add-faculty'; // Replace with the actual endpoint
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'role': 'admin',
        }),
      );

      print('Add Faculty API Response Status: ${response.statusCode}');
      print('Add Faculty API Response Body: ${response.body}');

      if (response.statusCode == 201) {
        print('Faculty added successfully');
        fetchFaculties(); // Refresh the list after adding
      } else {
        print('Failed to add faculty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _deleteFaculty(String id) async {
    final url = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/delete-faculty/$id'; // Replace with the actual endpoint
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      print('Delete Faculty API Response Status: ${response.statusCode}');
      print('Delete Faculty API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Faculty deleted successfully');
        setState(() {
          _faculties.removeWhere((faculty) => faculty.id == id);
        });
      } else {
        print('Failed to delete faculty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showAddFacultyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController emailController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Faculty'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final String name = nameController.text;
                final String email = emailController.text;

                Navigator.of(context).pop();
                _addFaculty(name, email);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        title: const Text(
          'Manage Faculties',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _showAddFacultyDialog,
                      child: const Text('Add New Faculty'),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _faculties.length,
                        itemBuilder: (context, index) {
                          final faculty = _faculties[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(faculty.name),
                              subtitle: Text(faculty.email),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteFaculty(faculty.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
