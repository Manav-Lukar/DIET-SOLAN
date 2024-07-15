import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyAttendancePage extends StatefulWidget {
  final String facultyName;
  final List<String> subjects;

  FacultyAttendancePage({required this.facultyName, required this.subjects});

  @override
  _FacultyAttendancePageState createState() => _FacultyAttendancePageState();
}

class _FacultyAttendancePageState extends State<FacultyAttendancePage> {
  Map<String, Map<String, Map<String, String>>> attendance = {
    'Student1': {
      '14-07-2024': {
        'Mathematics': 'P',
        'Physics': 'A',
        'Chemistry': 'L',
      },
    },
    'Student2': {
      '14-07-2024': {
        'Mathematics': 'A',
        'Physics': 'P',
        'Chemistry': 'P',
      },
    },
  };

  DateTime selectedDate = DateTime.now();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _showAttendanceDetails(BuildContext context, String student, Map<String, String> records) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attendance Details for $student on ${DateFormat('dd-MM-yyyy').format(selectedDate)}'),
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
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      records[entry.key] = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return ['P', 'A', 'L'].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
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

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Attendance Records'),
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
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
            Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.white.withOpacity(0.2),
              child: Text(
                'Date: $formattedDate',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: attendance.entries.map((entry) {
                  return Card(
                    color: Colors.white.withOpacity(0.6),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          if (entry.value.containsKey(formattedDate)) {
                            _showAttendanceDetails(context, entry.key, entry.value[formattedDate]!);
                          } else {
                            setState(() {
                              entry.value[formattedDate] = {
                                for (var subject in widget.subjects) subject: 'A'
                              };
                            });
                            _showAttendanceDetails(context, entry.key, entry.value[formattedDate]!);
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
