// import 'package:flutter/material.dart';

// class PersonalInfoPage extends StatelessWidget {
//   final Map<String, String> studentInfo;
//   final String username;

//   const PersonalInfoPage({
//     Key? key,
//     required this.studentInfo,
//     required this.username,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Personal Information'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: studentInfo.entries.map((entry) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     entry.key,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(entry.value),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
