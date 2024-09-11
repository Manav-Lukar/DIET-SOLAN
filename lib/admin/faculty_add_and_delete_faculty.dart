import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FacultyAddAndDeletePage extends StatefulWidget {
  @override
  _FacultyAddAndDeletePageState createState() => _FacultyAddAndDeletePageState();
}

class _FacultyAddAndDeletePageState extends State<FacultyAddAndDeletePage> {
  List<Map<String, dynamic>> facultyList = [];
  bool isLoading = true;
  bool isAdding = false;

  final String apiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/show-faculty';
  final String addFacultyApiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/add-faculty';
  final String deleteFacultyApiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/remove-faculty';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _coursesTeachingController = TextEditingController();
  final TextEditingController _classesTeachingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFaculty();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchFaculty() async {
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
          facultyList = data.map((faculty) => {
                'id': faculty['_id'] ?? '',
                'name': faculty['name'] ?? 'No name',
                'email': faculty['email'] ?? 'No email',
                'role': faculty['role'] ?? 'No role',
                'coursesTeaching': faculty['coursesTeaching'] ?? [],
                'classesTeaching': faculty['classesTeaching'] ?? [],
              }).toList();
        });
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired, please log in again.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load faculty')),
        );
      }
      print('API Response: ${response.body}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error fetching faculty: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteFaculty(String id) async {
    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$deleteFacultyApiUrl/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          facultyList.removeWhere((faculty) => faculty['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Faculty deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete faculty')),
        );
      }
      print('Delete Response: ${response.body}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error deleting faculty: $e');
    }
  }

  Future<void> _addFaculty() async {
    final token = await _getToken();
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _roleController.text;
    final coursesTeaching = json.decode(_coursesTeachingController.text);
    final classesTeaching = json.decode(_classesTeachingController.text);

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(addFacultyApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'coursesTeaching': coursesTeaching,
          'classesTeaching': classesTeaching,
        }),
      );

      if (response.statusCode == 201) {
        final newFaculty = json.decode(response.body);
        setState(() {
          facultyList.add({
            'id': newFaculty['_id'],
            'name': newFaculty['name'],
            'email': newFaculty['email'],
            'role': newFaculty['role'],
            'coursesTeaching': newFaculty['coursesTeaching'],
            'classesTeaching': newFaculty['classesTeaching'],
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Faculty added successfully')),
        );
        setState(() {
          isAdding = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add faculty')),
        );
      }
      print('Add Response: ${response.body}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error adding faculty: $e');
    }
  }

  void _showAddFacultyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Faculty'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: _coursesTeachingController,
                decoration: const InputDecoration(labelText: 'Courses Teaching (JSON array)'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              TextField(
                controller: _classesTeachingController,
                decoration: const InputDecoration(labelText: 'Classes Teaching (JSON array)'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addFaculty();
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
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

  void _showFacultyDetailsDialog(Map<String, dynamic> faculty) {
    final List<dynamic> classesTeaching = faculty['classesTeaching'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(faculty['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${faculty['email']}'),
              Text('Role: ${faculty['role']}'),
              const SizedBox(height: 10),
              Text('Courses Teaching: ${faculty['coursesTeaching'].join(', ')}'),
              const SizedBox(height: 10),
              Text('Classes Teaching:'),
              ...classesTeaching.map((classItem) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('Year ${classItem['year']}, Sections: ${classItem['sections'].join(', ')}'),
                );
              }).toList(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Faculty'),
        backgroundColor: const Color(0xFFE0F7FA),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddFacultyDialog,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: facultyList.length,
              itemBuilder: (context, index) {
                final faculty = facultyList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(faculty['name']),
                    subtitle: Text('Email: ${faculty['email']}\nRole: ${faculty['role']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteFaculty(faculty['id']);
                      },
                    ),
                    onTap: () => _showFacultyDetailsDialog(faculty),
                  ),
                );
              },
            ),
    );
  }
}
