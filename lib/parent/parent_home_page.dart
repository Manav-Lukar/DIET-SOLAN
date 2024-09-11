// import 'package:flutter/material.dart';
// import 'package:diet_portal/student/FeeDetailsPage.dart';
// import 'package:diet_portal/student/academic_details_page.dart';
// import 'package:diet_portal/student/class_attendance_page.dart';
// import 'package:diet_portal/student/student_personal_info.dart';

// class ParentHomePage extends StatelessWidget {
//   final String parentName;
//   final String studentName;
//   final String rollNo;
//   final String year;
//   final String section;

//   const ParentHomePage({
//     super.key,
//     required this.parentName,
//     required this.studentName,
//     required this.rollNo,
//     required this.year,
//     required this.section, required String username, required parentDetails, required contactNumber, required motherName, required fatherName, required parentId, required enrollNo, required String parentContact, required String parentEmail, required String parentAddress, required String token,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 225, 244, 248),
//         title: Text(
//           'Welcome, $parentName',
//           style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, '/');
//           },
//         ),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFE0F7FA),
//               Color(0xFFE0F2F1),
//             ],
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 20.0),
//             _buildNoticesSection(),
//             const SizedBox(height: 20.0),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.9,
//                   mainAxisSpacing: 20.0,
//                   crossAxisSpacing: 20.0,
//                   children: [
//                     buildTile(
//                       context,
//                       'Personal Info',
//                       Icons.person,
//                       Colors.blue,
//                       () => _showPersonalInfoDialog(context),
//                     ),
//                     buildTile(
//                       context,
//                       'Fee Details',
//                       Icons.account_balance,
//                       Colors.green,
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => FeeDetailsPage(
//                             username: '',
//                             studentDetails: {
//                               'Name': studentName,
//                               'Roll No': rollNo,
//                             },
//                             studentName: studentName,
//                             rollNo: rollNo, token: '',
//                           ),
//                         ),
//                       ),
//                     ),
//                     buildTile(
//                       context,
//                       'Academic Details',
//                       Icons.school,
//                       Colors.orange,
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AcademicDetailsPage(
//                             username: '',
//                             subjectsData: const [], // Update as needed
//                             studentDetails: {
//                               'Name': studentName,
//                               'Roll No': rollNo,
//                             },
//                             studentName: studentName,
//                             subjects: const [], // Update as needed
//                             rollNo: rollNo, token: '',
//                           ),
//                         ),
//                       ),
//                     ),
//                     buildTile(
//                       context,
//                       'Class Attendance',
//                       Icons.assignment,
//                       Colors.red,
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ClassAttendancePage(
//                             enrollNo: rollNo,
//                             username: '',
//                             name: studentName,
//                             rollNo: rollNo,
//                             fineData: const {}, // Update as needed
//                             subjectsData: const [], // Update as needed
//                             year: year,
//                             studentName: studentName,
//                             section: section,
//                             studentDetails: const {}, token: '',
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showPersonalInfoDialog(context);
//         },
//         backgroundColor: Colors.blue,
//         tooltip: 'View Personal Info',
//         child: const Icon(Icons.account_circle, color: Colors.white),
//       ),
//     );
//   }

//   void _showPersonalInfoDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Personal Information'),
//           content: PersonalInfoDialog(
//             studentInfo: {
//               'Name': studentName,
//               'Roll No': rollNo,
//               'Year': year,
//               'Section': section,
//               'Student Name': studentName,
//               'Parent Name': parentName,
//             },
//             username: '',
//             facultyInfo: const {},
//             role: '',
//             info: const {}, parentsDetails: {}, parentInfo: {},
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNoticesSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Recent Notices',
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Sample notices (can be fetched from an API if needed)
//             ...[
//               'Notice 1: School reopens next week.',
//               'Notice 2: Parent-teacher meeting scheduled.',
//             ].map((notice) => Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.notifications, size: 16, color: Colors.black54),
//                   const SizedBox(width: 8.0),
//                   Expanded(
//                     child: Text(
//                       '• $notice',
//                       style: const TextStyle(color: Colors.black87),
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTile(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//           color: Colors.white,
//           gradient: LinearGradient(
//             colors: [color.withOpacity(0.2), Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   icon,
//                   size: 40,
//                   color: color,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
