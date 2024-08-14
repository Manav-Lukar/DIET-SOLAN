// import 'package:flutter/material.dart';

// class ParentPersonalInfoPage extends StatelessWidget {
//   final String parentName;
//   final String parentContact;
//   final String parentEmail;
//   final String parentAddress;

//   const ParentPersonalInfoPage({
//     Key? key,
//     required this.parentName,
//     required this.parentContact,
//     required this.parentEmail,
//     required this.parentAddress,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Parent Personal Info'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildInfoRow('Name', parentName),
//             _buildInfoRow('Contact', parentContact),
//             _buildInfoRow('Email', parentEmail),
//             _buildInfoRow('Address', parentAddress),
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Back'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
// }
