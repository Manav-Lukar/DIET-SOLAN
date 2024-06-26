// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'student/student_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'District Institute of Education and Training-Solan (H.P.)',
      theme: ThemeData(
        primaryColor: const Color(0xff3498db),
        colorScheme: const ColorScheme(
          primary: Color(0xff3498db),
          secondary: Color(0xfff1c40f),
          surface: Color(0xfff7f7f7),
          background: Color(0xfff7f7f7),
          error: Colors.red,
          brightness: Brightness.light,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  bool isStudentSelected = true; // Default selection
  String username = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _formAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _logoAnimation,
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/diet_logo.jpg',
                    height: screenHeight * 0.25,
                  ),
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
              SizedBox(height: screenHeight * 0.06),
              Text(
                'Hello, $username',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              FadeTransition(
                opacity: _formAnimation,
                child: Column(
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Member Type :',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Student',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            Checkbox(
                              value: isStudentSelected,
                              onChanged: (newValue) {
                                setState(() {
                                  isStudentSelected = newValue ?? false;
                                });
                              },
                              checkColor: Colors.white,
                              activeColor: Colors.blue,
                            ),
                            SizedBox(width: screenWidth * 0.015),
                            Text(
                              'Faculty',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            Checkbox(
                              value: !isStudentSelected,
                              onChanged: (newValue) {
                                setState(() {
                                  isStudentSelected = !(newValue ?? true);
                                });
                              },
                              checkColor: Colors.white,
                              activeColor: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.03,
                          horizontal: screenWidth * 0.15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        ),
                      ),
                      onPressed: () {
                        if (isStudentSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentHomePage(
                                username: username,
                                subjectsData: const [
                                  {
                                    'subjectCode': 'MAT101',
                                    'subjectName': 'Mathematics',
                                    'attendance': 85,
                                    'attendanceData': [
                                      {'date': '2024-01-01', 'status': 'Present'},
                                      {'date': '2024-01-02', 'status': 'Absent'},
                                    ],
                                  },
                                  {
                                    'subjectCode': 'PHY101',
                                    'subjectName': 'Physics',
                                    'attendance': 90,
                                    'attendanceData': [
                                      {'date': '2024-01-01', 'status': 'Present'},
                                      {'date': '2024-01-02', 'status': 'Present'},
                                    ],
                                 
                                                                   },
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Handle faculty login
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
