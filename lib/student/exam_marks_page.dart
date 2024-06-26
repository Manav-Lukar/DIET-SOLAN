import 'package:flutter/material.dart';

class ExamMarksPage extends StatelessWidget {
  final Map<String, Map<String, String>> term1Marks = {
    'Mathematics': {'Term 1': '7/15', 'Term 2': '12/15'},
    'Physics': {'Term 1': '10/15', 'Term 2': '18/25'},
    'Chemistry': {'Term 1': '11/15', 'Term 2': '20/25'},
    'Biology': {'Term 1': '9/15', 'Term 2': '15/25'},
    'English': {'Term 1': '13/15', 'Term 2': '22/25'},
  };

  final Map<String, Map<String, String>> term2Marks = {
    'Mathematics': {'Term 1': '14/15', 'Term 2': '13/15'},
    'Physics': {'Term 1': '20/25', 'Term 2': '22/25'},
    'Chemistry': {'Term 1': '18/25', 'Term 2': '23/25'},
    'Biology': {'Term 1': '12/15', 'Term 2': '20/25'},
    'English': {'Term 1': '22/25', 'Term 2': '24/25'},
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exam Marks'),
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
          child: TabBarView(
            children: [
              buildMarksList(term1Marks),
              buildMarksList(term2Marks),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMarksList(Map<String, Map<String, String>> marks) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: marks.entries.map((entry) {
        return Card(
          color: Colors.white.withOpacity(0.6), // Semi-transparent white color
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(
              entry.key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Term 1: ${entry.value['Term 1']}'),
                Text('Term 2: ${entry.value['Term 2']}'),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
