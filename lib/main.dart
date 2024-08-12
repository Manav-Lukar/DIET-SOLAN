import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart'; // Import the LoginPage widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: LoginPage(),
    );
  }
}
