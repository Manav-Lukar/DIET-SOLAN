import 'package:flutter/material.dart';

class ClassAttendancePage extends StatelessWidget {
  final String name;
  final String rollNo;
  final String year;
  final Map<String, Map<String, String>> attendance;
  final Map fineData; // Add the correct data structure for fineData
  final List subjectsData; // Add the correct data structure for subjectsData
  final String username;

  const ClassAttendancePage({
    super.key,
    required this.name,
    required this.rollNo,
    required this.year,
    required this.attendance,
    required this.fineData,
    required this.subjectsData,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Attendance'),
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
      body: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white.withOpacity(0.6), // Semi-transparent white color
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $name\nRoll No: $rollNo\nYear: $year',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Total Fine: ${fineData['total'] ?? 'N/A'}'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: attendance.length,
                itemBuilder: (context, index) {
                  String subject = attendance.keys.elementAt(index);
                  Map<String, String> subjectAttendance = attendance[subject]!;
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ExpansionTile(
                      title: Text(subject),
                      children: subjectAttendance.entries.map((entry) {
                        return ListTile(
                          title: Text('Date: ${entry.key}, Status: ${entry.value}'),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
