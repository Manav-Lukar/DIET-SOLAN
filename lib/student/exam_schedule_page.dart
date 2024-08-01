// import 'package:flutter/material.dart';

// class ExamSchedulePage extends StatelessWidget {
//   final Map<String, String> term1Schedule = {
//     'Mathematics': '12th July 2024, 9:00 AM - 12:00 PM',
//     'Physics': '14th July 2024, 9:00 AM - 12:00 PM',
//     'Chemistry': '16th July 2024, 9:00 AM - 12:00 PM',
//     'Biology': '18th July 2024, 9:00 AM - 12:00 PM',
//     'English': '20th July 2024, 9:00 AM - 12:00 PM',
//   };

//   final Map<String, String> term2Schedule = {
//     'Mathematics': '10th December 2024, 9:00 AM - 12:00 PM',
//     'Physics': '12th December 2024, 9:00 AM - 12:00 PM',
//     'Chemistry': '14th December 2024, 9:00 AM - 12:00 PM',
//     'Biology': '16th December 2024, 9:00 AM - 12:00 PM',
//     'English': '18th December 2024, 9:00 AM - 12:00 PM',
//   };

//   // Constructor
//   ExamSchedulePage({super.key, required String username, required List subjectsData, required Map<String, dynamic> studentDetails});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Exam Schedule'),
//           bottom: const TabBar(
//             labelColor: Color.fromARGB(255, 14, 12, 12), // Color for selected tab
//             unselectedLabelColor: Colors.black54, // Color for unselected tabs
//             labelStyle: TextStyle(fontWeight: FontWeight.bold), // Bold text for selected tab
//             unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Bold text for unselected tabs
//             tabs: [
//               Tab(text: 'Term 1'),
//               Tab(text: 'Term 2'),
//             ],
//           ),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                 Color(0xffe6f7ff), // Deep blue for consistency
//                 Color(0xffe6f7ff), // Light blue for consistency
//               ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   spreadRadius: 0,
//                   blurRadius: 6,
//                   offset: Offset(0, 2), // Shadow position
//                 ),
//               ],
//             ),
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             buildScheduleList(term1Schedule),
//             buildScheduleList(term2Schedule),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildScheduleList(Map<String, String> schedule) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Color(0xffe6f7ff), // Light blue gradient for a fresh look
//             Color(0xffcceeff), // Slightly darker blue for contrast
//           ],
//         ),
//       ),
//       child: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: schedule.entries.map((entry) {
//           return Card(
//             color: Colors.white.withOpacity(0.8), // Semi-transparent white color
//             margin: const EdgeInsets.symmetric(vertical: 8.0),
//             child: ListTile(
//               title: Text(
//                 entry.key,
//                 style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//               ),
//               subtitle: Text(
//                 entry.value,
//                 style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
