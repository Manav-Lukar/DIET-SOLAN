import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // Example of a basic authentication status flag
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // Method to simulate a login
  void login() {
    _isAuthenticated = true;
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to simulate a logout
  void logout() {
    _isAuthenticated = false;
    notifyListeners(); // Notify listeners to update UI
  }
}
