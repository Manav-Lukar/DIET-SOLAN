// shared_data.dart
import 'package:flutter/material.dart';

class SharedData extends ChangeNotifier {
  final Map<String, Map<String, String>> marks = {};

  void updateMarks(String student, String term, String subject, String mark) {
    if (!marks.containsKey(student)) {
      marks[student] = {};
    }
    marks[student]!['$term - $subject'] = mark;
    notifyListeners();
  }

  Map<String, String> getMarks(String student) {
    return marks[student] ?? {};
  }
}

final SharedData sharedData = SharedData();
