import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ShowAttendancePage extends StatefulWidget {
  final String token;
  final String facultyName;

  const ShowAttendancePage({
    Key? key,
    required this.token,
    required this.facultyName,
    required List classesTeaching,
    required String courseId,
    required String section,
    required String year,
  }) : super(key: key);

  @override
  _ShowAttendancePageState createState() => _ShowAttendancePageState();
}

class _ShowAttendancePageState extends State<ShowAttendancePage> {
  final _courseIdController = TextEditingController();
  final _yearController = TextEditingController();
  final _sectionController = TextEditingController();

  List<Map<String, dynamic>> attendanceRecords = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void dispose() {
    _courseIdController.dispose();
    _yearController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  Future<void> _fetchAttendanceRecords() async {
    final courseId = _courseIdController.text;
    final year = _yearController.text;
    final section = _sectionController.text;

    final url = Uri.parse(
        'https://student-attendance-system-ckb1.onrender.com/api/attendance/show-attendance-faculty/$courseId/$year/$section');

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      // Print response status code and body to debug console
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          attendanceRecords = List<Map<String, dynamic>>.from(data.map((record) {
            final date = record['date']?.split('T')?.first ?? 'No Date';
            return {
              'enrollNo': record['enrollNo'],
              'status': record['status'],
              'date': date,
            };
          }));
          _message = attendanceRecords.isEmpty
              ? 'No attendance records found.'
              : 'Attendance records loaded successfully.';
        });
      } else {
        setState(() {
          _message =
              'Failed to load attendance records. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error loading attendance records: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateAndDownloadPdf(List<Map<String, dynamic>> records) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Attendance Records', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Enroll No', 'Status', 'Date'],
                data: records.map((record) => [
                  record['enrollNo'].toString(),
                  record['status'],
                  record['date'],
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Attendance Records'),
        backgroundColor: Color(0xFFE0F7FA),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              if (attendanceRecords.isNotEmpty) {
                _generateAndDownloadPdf(attendanceRecords);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No records to download.')),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFE0F7FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _courseIdController,
              decoration: InputDecoration(
                labelText: 'Course ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _yearController,
              decoration: InputDecoration(
                labelText: 'Year (e.g., 1, 2)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _sectionController,
              decoration: InputDecoration(
                labelText: 'Section (e.g., A, B)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchAttendanceRecords,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text('Show Attendance'),
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : attendanceRecords.isEmpty
                    ? Center(child: Text(_message))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: attendanceRecords.length,
                          itemBuilder: (context, index) {
                            final record = attendanceRecords[index];
                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal[50],
                                  child: Text(
                                    '${record['enrollNo']}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                title: Text('Enroll No: ${record['enrollNo']}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status: ${record['status']}'),
                                    Text('Date: ${record['date']}'),
                                  ],
                                ),
                                trailing: Icon(Icons.check_circle, color: Colors.green),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
