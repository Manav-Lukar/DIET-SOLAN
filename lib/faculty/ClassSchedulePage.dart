import 'package:flutter/material.dart';
import 'class_schedule.dart'; // Import your ClassSchedule model

class ClassSchedulePage extends StatelessWidget {
  final List<ClassSchedule> schedules = [
    // Example schedule for a faculty member in the CSE department
    ClassSchedule(
      day: 'Monday',
      classes: [
        ClassInfo(time: '09:00 AM', subject: 'DSA', type: 'Lecture'),
        ClassInfo(time: '11:00 AM', subject: 'OOPS', type: 'Lecture'),
        ClassInfo(
            time: '02:00 PM', subject: 'Operating System', type: 'Lecture'),
        ClassInfo(
            time: '04:00 PM', subject: 'C++ Programming', type: 'Lecture'),
      ],
    ),
    ClassSchedule(
      day: 'Tuesday',
      classes: [
        ClassInfo(time: '09:00 AM', subject: 'DSA Lab', type: 'Lab'),
        ClassInfo(time: '11:00 AM', subject: 'OOPS Lab', type: 'Lab'),
        ClassInfo(
            time: '02:00 PM', subject: 'Operating System Lab', type: 'Lab'),
        ClassInfo(
            time: '04:00 PM', subject: 'C++ Programming Lab', type: 'Lab'),
      ],
    ),
    // Add schedules for other days as needed
  ];

  final String facultyName;

  ClassSchedulePage({Key? key, required this.facultyName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Schedule'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade300,
                Colors.blue.shade500,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade500,
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final schedule = schedules[index];
            return Card(
              margin: const EdgeInsets.all(10),
              color: Colors.blue.shade300,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.day,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: schedule.classes.map((classInfo) {
                        return ListTile(
                          title: Text(
                            classInfo.subject,
                            style: TextStyle(color: Colors.black), // Text color
                          ),
                          subtitle: Text(
                            '${classInfo.time} - ${classInfo.type}',
                            style: TextStyle(color: Colors.black), // Text color
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
