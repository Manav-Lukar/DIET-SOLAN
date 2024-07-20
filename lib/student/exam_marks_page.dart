import 'package:flutter/material.dart';
import 'package:diet_portal/color_theme.dart';

class ExamMarksPage extends StatefulWidget {
  final String username;

  const ExamMarksPage({super.key, required this.username, required List<String> notices});

  @override
  _ExamMarksPageState createState() => _ExamMarksPageState();
}

class _ExamMarksPageState extends State<ExamMarksPage> {
  final List<String> _terms = ['Term 1', 'Term 2'];
  String _selectedTerm = 'Term 1';
  Map<String, dynamic> _marksData = {};

  final Color _termTextColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _fetchMarks();
  }

  Future<void> _fetchMarks() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _marksData = {
        'Math': 85,
        'Science': 78,
        'English': 90,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Marks'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorTheme.appBarGradientStart,
                ColorTheme.appBarGradientEnd,
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
              ColorTheme.appBarGradientStart,
              ColorTheme.appBarGradientEnd,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  showMenu<String>(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      screenWidth * 0.2, // left
                      screenHeight * 0.1, // top (adjust as needed)
                      screenWidth * 0.2, // right
                      0, // bottom
                    ),
                    items: _terms.map((String term) {
                      return PopupMenuItem<String>(
                        value: term,
                        child: Text(
                          term,
                          style: TextStyle(
                            color: _termTextColor,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    color: ColorTheme.secondaryColor,
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _selectedTerm = value;
                        _fetchMarks();
                      });
                    }
                  });
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: ColorTheme.inputFieldBackground,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTerm,
                        style: TextStyle(
                          color: _termTextColor,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: ListView.builder(
                  itemCount: _marksData.keys.length,
                  itemBuilder: (context, index) {
                    final subject = _marksData.keys.elementAt(index);
                    final marks = _marksData[subject];
                    return Card(
                      color: ColorTheme.cardBackground,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(subject),
                        trailing: Text(
                          marks.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
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
