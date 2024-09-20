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
  String? _selectedYear;
  String? _selectedSection;

  List<Map<String, dynamic>> attendanceRecords = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void dispose() {
    _courseIdController.dispose();
    super.dispose();
  }

  Future<void> _fetchAttendanceRecords() async {
    final courseId = _courseIdController.text.trim();
    final year = _selectedYear;
    final section = _selectedSection;

    if (courseId.isEmpty || year == null || section == null) {
      setState(() {
        _message = 'Please fill in all fields.';
      });
      return;
    }

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

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          attendanceRecords = data.map((record) {
            final date = record['date']?.split('T')?.first ?? 'No Date';
            return {
              'enrollNo': record['enrollNo'],
              'status': record['status'],
              'date': date,
            };
          }).toList();
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
        title: const Text('Show Attendance Records'),
        backgroundColor: const Color(0xFFE0F7FA),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              if (attendanceRecords.isNotEmpty) {
                _generateAndDownloadPdf(attendanceRecords);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No records to download.')),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_courseIdController, 'Course ID'),
            const SizedBox(height: 16.0),
            _buildDropdown('Select Year', ['1', '2'], (value) {
              setState(() {
                _selectedYear = value;
              });
            }),
            const SizedBox(height: 16.0),
            _buildDropdown('Select Section', ['A', 'B'], (value) {
              setState(() {
                _selectedSection = value;
              });
            }),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchAttendanceRecords,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Show Attendance'),
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
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal[50],
                                  child: Text(
                                    '${record['enrollNo']}',
                                    style: const TextStyle(color: Colors.black),
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
                                trailing: const Icon(Icons.check_circle, color: Colors.green),
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

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: label == 'Select Year' ? _selectedYear : _selectedSection,
      items: items.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}