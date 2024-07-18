import 'package:flutter/material.dart';

class ClassAttendancePage extends StatelessWidget {
  final String name;
  final String rollNo;
  final String year;
  final Map<String, Map<String, String>> attendance = {
    'Mathematics': {
      '01-01-2024': 'P',
      '01-02-2024': 'A',
      '22-02-2024': 'A',
      '11-04-2024': 'P',
      '09-05-2024': 'L',
      // Add more dates as needed
    },
    'Physics': {
      '01-01-2024': 'P',
      '01-02-2024': 'P',
      '22-02-2024': 'A',
      '11-04-2024': 'P',
      '09-05-2024': 'L',
      '30-03-2024': 'L',
      // Add more dates as needed
    },
    'Chemistry': {
      '01-01-2024': 'P',
      '01-02-2024': 'A',
      '22-02-2024': 'P',
      '11-04-2024': 'P',
      '09-05-2024': 'L',
      // Add more dates as needed
    },
    'History': {
      '01-01-2024': 'P',
      '01-02-2024': 'P',
      '22-02-2024': 'P',
      '11-04-2024': 'A',
      '09-05-2024': 'L',
      // Add more dates as needed
    },
    'English': {
      '01-01-2024': 'P',
      '01-02-2024': 'A',
      '22-02-2024': 'A',
      '11-04-2024': 'P',
      '09-05-2024': 'L',
      // Add more dates as needed
    },
    'Economics': {
      '01-01-2024': 'P',
      '01-02-2024': 'P',
      '22-02-2024': 'A',
      '11-04-2024': 'P',
      '09-05-2024': 'L',
      // Add more dates as needed
    },
    'EVS': {
      '01-01-2024': 'P',
      '01-02-2024': 'P',
      '22-02-2024': 'P',
      '11-04-2024': 'P',
      '09-05-2024': 'L',
      // Add more dates as needed
    },
  };

  ClassAttendancePage({
    super.key,
    required this.name,
    required this.rollNo,
    required this.year,
    required Map fineData,
    required List subjectsData,
    required String username, required Map attendance,
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
                    Text('Total Fine: ₹${calculateFine()}'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  ...attendance.entries.map((entry) {
                    int subjectTotal = entry.value.length;
                    int subjectPresent = entry.value.values.where((record) => record == 'P').length;
                    double subjectPercentage = (subjectPresent / subjectTotal) * 100;

                    return GestureDetector(
                      onTap: () {
                        _showAttendanceDetails(context, entry.key, entry.value);
                      },
                      child: Card(
                        color: Colors.white.withOpacity(0.6), // Semi-transparent white color
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(                            '${subjectPercentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceDetails(BuildContext context, String subject, Map<String, String> records) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attendance Details for $subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: records.entries.map((entry) {
              return ListTile(
                leading: Icon(
                  entry.value == 'P'
                      ? Icons.check_circle
                      : entry.value == 'A'
                          ? Icons.cancel
                          : Icons.info,
                  color: entry.value == 'P'
                      ? Colors.green
                      : entry.value == 'A'
                          ? Colors.red
                          : Colors.orange,
                ),
                title: Text(
                  '${entry.key}: ${entry.value == 'P'
                          ? 'Present'
                          : entry.value == 'A'
                              ? 'Absent'
                              : 'Leave'}',
                ),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double calculateFine() {
    int totalAbsent = 0;

    for (var records in attendance.values) {
      totalAbsent += records.values.where((record) => record == 'A').length;
    }

    return totalAbsent * 2.0;
  }
}

void main() {
  runApp(MaterialApp(
    home: ClassAttendancePage(
      name: 'John Doe',
      rollNo: '123456',
      year: '2024',
      fineData: const {},
      subjectsData: const [],
      username: '', attendance: {},
    ),
  ));
}
