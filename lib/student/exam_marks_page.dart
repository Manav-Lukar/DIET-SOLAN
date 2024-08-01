// import 'package:diet_portal/color_theme.dart';
// import 'package:flutter/material.dart';

// class ExamMarksPage extends StatefulWidget {
//   final String username;
//   final List<String> notices;

//   const ExamMarksPage({
//     super.key,
//     required this.username,
//     required this.notices, required String year, required List subjectsData, required Map<String, dynamic> studentDetails,
//   });

//   @override
//   _ExamMarksPageState createState() => _ExamMarksPageState();
// }

// class _ExamMarksPageState extends State<ExamMarksPage> {
//   final List<String> _terms = ['Term 1', 'Term 2'];
//   String _selectedTerm = 'Term 1';
//   Map<String, dynamic> _marksData = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchMarks();
//   }

//   Future<void> _fetchMarks() async {
//     await Future.delayed(const Duration(seconds: 1));

//     setState(() {
//       _marksData = {
//         'Math': 85,
//         'Science': 78,
//         'English': 90,
//       };
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Exam Marks',
//           style: TextStyle(color: Colors.black),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 ColorTheme.primaryColor,
//                 ColorTheme.secondaryColor,
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               ColorTheme.pageBackgroundStart,
//               ColorTheme.pageBackgroundEnd,
//             ],
//           ),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(height: screenHeight * 0.02),
//             GestureDetector(
//               onTap: () {
//                 showMenu<String>(
//                   context: context,
//                   position: RelativeRect.fromLTRB(
//                     screenWidth * 0.04, // left
//                     screenHeight * 0.15, // top
//                     screenWidth * 0.04, // right
//                     screenHeight * 0.05, // bottom
//                   ),
//                   items: _terms.map((String term) {
//                     return PopupMenuItem<String>(
//                       value: term,
//                       child: Text(
//                         term,
//                         style: TextStyle(
//                           color: ColorTheme.dropdownTextColor,
//                           fontSize: 16,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   color: ColorTheme.dropdownBackground,
//                 ).then((value) {
//                   if (value != null) {
//                     setState(() {
//                       _selectedTerm = value;
//                       _fetchMarks();
//                     });
//                   }
//                 });
//               },
//               child: Container(
//                 height: 48,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: ColorTheme.inputFieldBackground,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       _selectedTerm,
//                       style: TextStyle(
//                         color: ColorTheme.dropdownTextColor,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Icon(Icons.arrow_drop_down, color: const Color.fromARGB(255, 12, 12, 12)),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _marksData.keys.length,
//                 itemBuilder: (context, index) {
//                   final subject = _marksData.keys.elementAt(index);
//                   final marks = _marksData[subject];
//                   return Card(
//                     color: Colors.white.withOpacity(0.8),
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       title: Text(
//                         subject,
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       trailing: Text(
//                         marks.toString(),
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                           color: marks >= 50 ? Colors.black : Colors.red, // Example condition
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
