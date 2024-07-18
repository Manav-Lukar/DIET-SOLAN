import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:diet_portal/student/student_home_page.dart';
import 'package:diet_portal/faculty/faculty_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _loginUser(BuildContext context) async {
    String usernameInput = _usernameController.text.trim();
    late String apiUrl;
    late String successRole;
    late Map<String, dynamic> requestBody;

    // Determine API URL based on input (email or roll number)
    if (usernameInput.contains('@')) {
      // If input contains '@', treat it as an email (faculty)
      apiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/faculty-login';
      successRole = 'Faculty';
      requestBody = <String, dynamic>{
        'email': usernameInput,
      };
    } else {
      // Otherwise, treat it as a roll number (student)
      apiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/student/student-login';
      successRole = 'Student';
      requestBody = <String, dynamic>{
        'enrollNo': int.tryParse(usernameInput) ?? 0,
      };
    }

    requestBody.addAll({
      'password': _passwordController.text.trim(),
      'role': successRole,
    });

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('${successRole.toLowerCase()}Details') && data['${successRole.toLowerCase()}Details']['role'] == successRole) {
          if (successRole == 'Student') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StudentHomePage(
                  username: _usernameController.text,
                  notices: const [], // Adjust as per your app logic
                  subjectsData: const [], // Adjust as per your app logic
                ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FacultyHomePage(
                  username: _usernameController.text,
                  email: '', // Adjust as per your app logic
                  notices: null, // Adjust as per your app logic
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff3498db),
              Color(0xff4a77f2),
            ],
          ),
        ),
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/diet_logo.jpg',
                    height: screenHeight * 0.25,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  'Welcome to DIET Solan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () => _loginUser(context),
                      child: const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
