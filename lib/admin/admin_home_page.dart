import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home Page'),
        automaticallyImplyLeading: false, // Disables the back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/someAdminFunctionality');
              },
              child: const Text('Go to Some Admin Functionality'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Implement the logout functionality
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token'); // Remove the token on logout

                Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
