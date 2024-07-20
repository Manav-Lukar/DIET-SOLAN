import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:diet_portal/student/student_home_page.dart';
import 'package:diet_portal/faculty/faculty_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
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
  setState(() {
    _isLoading = true;
  });

  String usernameInput = _usernameController.text.trim();
  late String apiUrl;
  late String successRole;
  late Map<String, dynamic> requestBody;

  // Determine API URL based on input (email or roll number)
  if (usernameInput.contains('@')) {
    apiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/faculty-login';
    successRole = 'Faculty';
    requestBody = <String, dynamic>{
      'email': usernameInput,
    };
  } else {
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
      final detailsKey = '${successRole.toLowerCase()}Details';

      if (data.containsKey(detailsKey) && data[detailsKey]['role'] == successRole) {
        final userDetails = data[detailsKey];

        if (successRole == 'Student') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentHomePage(
                username: _usernameController.text,
                notices: const [], // Adjust as per your app logic
                subjectsData: const [], // Adjust as per your app logic
                studentDetails: userDetails, // Pass the entire studentDetails map
              ),
            ),
          );
        } else {
          // For faculty
          final name = userDetails['Name'] ?? 'Faculty'; // Handle null case
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FacultyHomePage(
                username: name,
                email: userDetails['email'] ?? '', // Handle null case
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
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
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
                  Color(0xff3498db),
                  Color(0xff4a77f2),
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
                          color: Colors.white,
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
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Color.fromARGB(255, 229, 238, 242),
                size: 50,
              ),
            ),
        ],
      ),
    );
  }
}
