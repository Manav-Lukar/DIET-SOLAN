import 'package:flutter/material.dart';
import 'package:diet_portal/color_theme.dart';

class ExamPapersPage extends StatefulWidget {
  final String username;

  const ExamPapersPage(
      {Key? key, required this.username, required String facultyName})
      : super(key: key);

  @override
  _ExamPapersPageState createState() => _ExamPapersPageState();
}

class _ExamPapersPageState extends State<ExamPapersPage> {
  final TextEditingController _marksController = TextEditingController();
  final List<String> _terms = ['Term 1', 'Term 2'];
  String _selectedTerm = 'Term 1';
  final List<String> _subjects = ['Math', 'Science', 'English'];
  String _selectedSubject = 'Math';

  Future<void> _uploadMarks() async {
    // Simulated API call
    await Future.delayed(Duration(seconds: 2));

    // Simulated success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Marks uploaded successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Papers'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
        decoration: BoxDecoration(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedTerm,
                items: _terms.map((term) {
                  return DropdownMenuItem(
                    value: term,
                    child: Text(
                      term,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Increased text size
                        color: Colors.black, // Text color
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTerm = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Term',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: ColorTheme.inputFieldBackground,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                items: _subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(
                      subject,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Increased text size
                        color: Colors.black, // Text color
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Subject',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: ColorTheme.inputFieldBackground,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: _marksController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: screenWidth * 0.045, // Increased text size
                ),
                decoration: InputDecoration(
                  labelText: 'Enter Marks',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: ColorTheme.inputFieldBackground,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: _uploadMarks,
                child: const Text('Upload Marks'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.025,
                    horizontal: screenWidth * 0.3,
                  ),
                  backgroundColor: Color(0xFFF3F2F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  textStyle: TextStyle(
                    fontSize: screenWidth * 0.045, // Increased text size
                    fontWeight: FontWeight.bold,
                  ), // Background color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
