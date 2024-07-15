import 'package:flutter/material.dart';

class ExamSchedulePage extends StatelessWidget {
  final Map<String, String> term1Schedule = {
    'Mathematics': '12th July 2024, 9:00 AM - 12:00 PM',
    'Physics': '14th July 2024, 9:00 AM - 12:00 PM',
    'Chemistry': '16th July 2024, 9:00 AM - 12:00 PM',
    'Biology': '18th July 2024, 9:00 AM - 12:00 PM',
    'English': '20th July 2024, 9:00 AM - 12:00 PM',
  };

  final Map<String, String> term2Schedule = {
    'Mathematics': '10th December 2024, 9:00 AM - 12:00 PM',
    'Physics': '12th December 2024, 9:00 AM - 12:00 PM',
    'Chemistry': '14th December 2024, 9:00 AM - 12:00 PM',
    'Biology': '16th December 2024, 9:00 AM - 12:00 PM',
    'English': '18th December 2024, 9:00 AM - 12:00 PM',
  };

   ExamSchedulePage({super.key, required String username});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exam Schedule'),
          bottom: const TabBar(
            labelColor: Colors.white, // Color for selected tab
            unselectedLabelColor: Colors.black54, // Color for unselected tabs
            labelStyle: TextStyle(fontWeight: FontWeight.bold), // Bold text for selected tab
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Bold text for unselected tabs
            tabs: [
              Tab(text: 'Term 1'),
              Tab(text: 'Term 2'),
            ],
          ),
          flexibleSpace: Container(
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
          ),
        ),
        body: TabBarView(
          children: [
            buildScheduleList(term1Schedule),
            buildScheduleList(term2Schedule),
          ],
        ),
      ),
    );
  }

  Widget buildScheduleList(Map<String, String> schedule) {
    return Container(
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
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: schedule.entries.map((entry) {
          return Card(
            color: Colors.white.withOpacity(0.6), // Semi-transparent white color
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                entry.value,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
