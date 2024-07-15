// class_schedule_model.dart

// Define the ClassInfo class to represent information about each class
class ClassInfo {
  final String time;    // Time of the class
  final String subject; // Subject name
  final String type;    // Type of class (Lecture or Lab)

  // Constructor to initialize the ClassInfo object
  ClassInfo({
    required this.time,
    required this.subject,
    required this.type,
  });
}

// Define the ClassSchedule class to represent the schedule for a single day
class ClassSchedule {
  final String day;           // Day of the week
  final List<ClassInfo> classes; // List of classes scheduled for the day

  // Constructor to initialize the ClassSchedule object
  ClassSchedule({
    required this.day,
    required this.classes,
  });
}
