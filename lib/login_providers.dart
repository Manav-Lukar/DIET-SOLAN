// import 'package:diet_portal/faculty/faculty_home_page.dart';
// import 'package:diet_portal/student/student_home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// // State Notifier for login loading status
// class LoginNotifier extends StateNotifier<bool> {
//   LoginNotifier() : super(false);

//   void setLoading(bool isLoading) {
//     state = isLoading;
//   }
// }

// // State Notifier for error messages
// class ErrorMessageNotifier extends StateNotifier<String> {
//   ErrorMessageNotifier() : super('');

//   void setErrorMessage(String message) {
//     state = message;
//   }
// }

// // Provider for username TextEditingController
// final usernameProvider = StateProvider<TextEditingController>((ref) {
//   return TextEditingController();
// });

// // Provider for password TextEditingController
// final passwordProvider = StateProvider<TextEditingController>((ref) {
//   return TextEditingController();
// });

// // State Notifier Provider for login loading status
// final isLoadingProvider = StateNotifierProvider<LoginNotifier, bool>((ref) {
//   return LoginNotifier();
// });

// // State Notifier Provider for error messages
// final errorMessageProvider = StateNotifierProvider<ErrorMessageNotifier, String>((ref) {
//   return ErrorMessageNotifier();
// });

// // Provider for managing password visibility
// final isPasswordVisibleProvider = StateProvider<bool>((ref) {
//   return false; // Initially password is hidden
// });

// // Function to handle login
// final loginUserProvider = Provider.autoDispose((ref) => (BuildContext context) async {
//   final usernameController = ref.read(usernameProvider);
//   final passwordController = ref.read(passwordProvider);
//   final isLoadingNotifier = ref.read(isLoadingProvider.notifier);
//   final errorMessageNotifier = ref.read(errorMessageProvider.notifier);

//   isLoadingNotifier.setLoading(true);

//   String usernameInput = usernameController.text.trim();
//   late String apiUrl;
//   late String successRole;
//   late Map<String, dynamic> requestBody;

//   if (usernameInput.contains('@')) {
//     apiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/faculty/faculty-login';
//     successRole = 'Faculty';
//     requestBody = <String, dynamic>{
//       'email': usernameInput,
//     };
//   } else {
//     apiUrl = 'https://student-attendance-system-ckb1.onrender.com/api/student/student-login';
//     successRole = 'Student';
//     requestBody = <String, dynamic>{
//       'enrollNo': int.tryParse(usernameInput) ?? 0,
//     };
//   }

//   requestBody.addAll({
//     'password': passwordController.text.trim(),
//     'role': successRole,
//   });

//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(requestBody),
//     );

//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       final detailsKey = '${successRole.toLowerCase()}Details';
//       if (data.containsKey(detailsKey) && data[detailsKey]['role'] == successRole) {
//         final userDetails = data[detailsKey];
//         final token = data['token'] ?? ''; // Extract token from response

//         if (successRole == 'Student') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => StudentHomePage(
//                 username: usernameController.text,
//                 notices: const [], // Adjust as per your app logic
//                 subjectsData: const [], // Adjust as per your app logic
//                 studentDetails: userDetails,
//                 studentName: '${userDetails['fName']} ${userDetails['lName']}',
//                 rollNo: userDetails['rollNo'].toString(),
//                 year: userDetails['year'].toString(),
//                 section: userDetails['section'],
//               ),
//             ),
//           );
//         } else {
//           final name = userDetails['Name'] ?? 'Faculty'; // Handle null case
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => FacultyHomePage(
//                 username: name,
//                 email: userDetails['email'] ?? '',
//                 token: token, // Pass the token
//               ),
//             ),
//           );
//         }
//       } else {
//         errorMessageNotifier.setErrorMessage('Invalid role or data format');
//       }
//     } else {
//       errorMessageNotifier.setErrorMessage('Invalid email or password');
//     }
//   } catch (e) {
//     print('Error: $e');
//     errorMessageNotifier.setErrorMessage('Error: $e');
//   } finally {
//     isLoadingNotifier.setLoading(false);
//   }
// });
