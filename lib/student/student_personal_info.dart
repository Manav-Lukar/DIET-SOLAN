import 'package:flutter/material.dart';

class PersonalInfoDialog extends StatelessWidget {
  final Map<String, String> studentInfo;
  final String username; // Unused here but included as per original code
  final Map<String, String> facultyInfo; // Unused here but included as per original code

  const PersonalInfoDialog({
    super.key,
    required this.studentInfo,
    required this.username,
    required this.facultyInfo, required String role, required Map info, required Map<String, dynamic> parentsDetails,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal Information'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: studentInfo.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(entry.value),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
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
  }
}
