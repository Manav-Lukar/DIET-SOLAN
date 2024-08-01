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

  ClassSchedulePage({super.key, required this.facultyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Schedule', style: TextStyle(color: Colors.black)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffe6f7ff),
                Color(0xffcceeff),
              ],
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffe6f7ff),
              Color(0xffcceeff),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final schedule = schedules[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 6.0,
              shadowColor: Colors.blue.shade100,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.day,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: schedule.classes.map((classInfo) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            tileColor: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            leading: Icon(
                              classInfo.type == 'Lecture'
                                  ? Icons.school
                                  : Icons.laptop,
                              color: classInfo.type == 'Lecture'
                                  ? Colors.indigo.shade300
                                  : Colors.green.shade600,
                            ),
                            title: Text(
                              classInfo.subject,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              '${classInfo.time} - ${classInfo.type}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
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
