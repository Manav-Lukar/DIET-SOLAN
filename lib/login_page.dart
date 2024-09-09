import 'dart:convert';
import 'package:diet_portal/admin/admin_home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diet_portal/parent/parent_home_page.dart';
import 'package:diet_portal/student/student_home_page.dart';
import 'package:diet_portal/faculty/faculty_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _selectedRole;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // Corrected parameter name
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> _loginUser(BuildContext context) async {
  if (_selectedRole == null) {
    setState(() {
      _errorMessage = 'Please select a role';
    });
    return;
  }

  setState(() {
    _isLoading = true;
  });

  String usernameInput = _usernameController.text.trim();
  late String apiUrl;
  late String successRole;
  late Map<String, dynamic> requestBody;

  if (_selectedRole == 'Faculty' || _selectedRole == 'Admin') {
    apiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/faculty-login';
    successRole = _selectedRole!;
    requestBody = {'email': usernameInput};
  } else if (_selectedRole == 'Student') {
    apiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/student/student-login';
    successRole = 'Student';
    requestBody = {'enrollNo': int.tryParse(usernameInput) ?? 0};
  } else {
    setState(() {
      _errorMessage = 'Invalid role selected';
    });
    return;
  }

  requestBody['password'] = _passwordController.text.trim();
  requestBody['role'] = successRole;

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final data = jsonDecode(response.body);

    // Determine the key based on the role
    String detailsKey = successRole == 'Admin' ? 'facultyDetails' : '${successRole.toLowerCase()}Details';

    if (response.statusCode == 200) {
      if (data.containsKey(detailsKey)) {
        final userDetails = data[detailsKey];
        print('User details: $userDetails');

        final token = userDetails['token'];
        if (token != null) {
          print('Token from response: $token');
          await _saveToken(token);
        }

        if (successRole == 'Admin') {
          final adminName = userDetails['Name'];
          final adminEmail = userDetails['email'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminHomePage(
                adminInfo: {
                  'name': adminName ?? 'Admin',
                  'email': adminEmail ?? '',
                },
              ),
            ),
          );
        } else if (successRole == 'Faculty') {
          final facultyName = userDetails['Name'];
          final facultyEmail = userDetails['email'];
          final coursesTeaching = userDetails['coursesTeaching'] ?? [];
          final classesTeaching = userDetails['classesTeaching'] ?? [];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FacultyHomePage(
                username: facultyName ?? 'Faculty',
                email: facultyEmail ?? '',
                notices: [], // Adjust as per your app logic
                facultyName: facultyName,
                token: token ?? '',
                coursesTeaching: coursesTeaching,
                classesTeaching: classesTeaching,
              ),
            ),
          );
        } else if (successRole == 'Student') {
          final courses = userDetails['courses'] ?? [];
          if (courses != null) {
            print('Courses from response: $courses');
            await _saveCourses(courses);
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentHomePage(
                username: _usernameController.text,
                notices: const [], // Adjust as per your app logic
                subjectsData: const [], // Adjust as per your app logic
                studentDetails: userDetails,
                studentName: '${userDetails['fName']} ${userDetails['lName']}',
                rollNo: userDetails['rollNo'].toString(),
                year: userDetails['year'].toString(),
                section: userDetails['section'],
                token: token ?? '', 
                role: '',
              ),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid role or data format';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  } catch (e) {
    print('Error: $e');
    setState(() {
      _errorMessage = 'Error: $e';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}




  // Add method to save coursesTeaching in SharedPreferences
  Future<void> _saveCoursesTeaching(List<dynamic> coursesTeaching) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('coursesTeaching', jsonEncode(coursesTeaching));
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token saved: $token'); // Print the token to the debug console
  }

  Future<void> _saveCourses(List<dynamic> courses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'courses',
      courses.map((id) => id.toString()).toList(),
    );
    print(
        'Course IDs saved: $courses'); // Print the course IDs to the debug console
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE0F7FA),
                  Color(0xFFE0F7FA),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500, // Adjust max width if needed
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _animation,
                        child: Image.asset(
                          'assets/diet_logo.jpg',
                          height: screenHeight * 0.25,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Text(
                        'Welcome to DIET Solan',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Email or Roll Number',
                            prefixIcon: Icon(Icons.person),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Role Selection Dropdown
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          hint: const Text('Select Role'),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                              horizontal: screenWidth * 0.05,
                            ),

                            prefixIcon: const Icon(Icons.group), // Added icon
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Faculty',
                              child: Text('Faculty',
                                  style: TextStyle(fontSize: 16)),
                            ),
                            DropdownMenuItem(
                              value: 'Student',
                              child: Text('Student',
                                  style: TextStyle(fontSize: 16)),
                            ),
                            
                            DropdownMenuItem(
                              value: 'Admin',
                              child:
                                  Text('Admin', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ElevatedButton(
                        onPressed: () => _loginUser(context),
                        child: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.2, // Adjusted width
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                          ),
                          textStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      if (_isLoading)
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.blue,
                          size: screenWidth * 0.1,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}