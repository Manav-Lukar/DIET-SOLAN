import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyAttendancePage extends StatefulWidget {
  final String facultyName;
  final List<String> subjects;

  const FacultyAttendancePage({
    Key? key,
    required this.facultyName,
    required this.subjects, required String token,
  }) : super(key: key);

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
      '15-07-2024': {
        'Mathematics': 'P',
        'Physics': 'P',
        'Chemistry': 'L',
      },
    },
    'Student2': {
      '14-07-2024': {
        'Mathematics': 'P',
        'Physics': 'P',
        'Chemistry': 'P',
      },
      '15-07-2024': {
        'Mathematics': 'A',
        'Physics': 'L',
        'Chemistry': 'P',
      },
    },
  };

  List<String> selectedSubjects = [];
  List<String> students = [];
  String selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    selectedSubjects = widget.subjects;
    students = attendance.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Records'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh attendance data
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffe6f7ff),
              Color(0xffcceeff),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Faculty: ${widget.facultyName}',
                style: theme.textTheme.headline6?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Date:',
                    style: theme.textTheme.subtitle1?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                        });
                      }
                    },
                    child: Text(
                      selectedDate,
                      style: theme.textTheme.button?.copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    String studentName = students[index];
                    return Card(
                      color: Colors.white.withOpacity(0.9),
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              studentName,
                              style: theme.textTheme.headline6?.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            ...selectedSubjects.map((subject) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      subject,
                                      style: theme.textTheme.subtitle1?.copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: attendance[studentName]?[selectedDate]?[subject] ?? 'P',
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          attendance[studentName]?[selectedDate]?[subject] = newValue!;
                                        });
                                      },
                                      items: <String>['P', 'A', 'L']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(
                                            children: [
                                              Icon(
                                                value == 'P'
                                                    ? Icons.check_circle
                                                    : value == 'A'
                                                        ? Icons.cancel
                                                        : Icons.access_time,
                                                color: value == 'P'
                                                    ? Colors.green
                                                    : value == 'A'
                                                        ? Colors.red
                                                        : Colors.orange,
                                              ),
                                              const SizedBox(width: 8.0),
                                              Text(
                                                value,
                                                style: TextStyle(
                                                  color: value == 'P'
                                                      ? Colors.green
                                                      : value == 'A'
                                                          ? Colors.red
                                                          : Colors.orange,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
