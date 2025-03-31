import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExcelService {
  final String bulkUploadUrl = 'https://attendance-management-system-jdbc.onrender.com/api/student/bulk-upload';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> processExcelData(List<int> bytes) async {
    try {
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables[excel.tables.keys.first];
      
      if (sheet == null) {
        return {'success': false, 'message': 'No sheet found in Excel file'};
      }

      // Expected headers
      final expectedHeaders = [
        'First Name',
        'Last Name',
        'Email',
        'Enrollment No',
        'Year',
        'Section',
        'Father Name',
        'Mother Name',
        'DOB',
        'Roll No',
        'Gender',
        'Parents Contact',
        'Password'
      ];

      // Verify headers
      var headers = sheet.row(0);
      for (int i = 0; i < expectedHeaders.length; i++) {
        if (headers[i]?.value.toString() != expectedHeaders[i]) {
          return {
            'success': false,
            'message': 'Invalid header format. Please use the correct template.'
          };
        }
      }

      // Process rows
      List<Map<String, dynamic>> students = [];
      for (int row = 1; row < sheet.maxRows; row++) {
        var studentData = _processRow(sheet.row(row));
        if (studentData != null) {
          students.add(studentData);
        }
      }

      if (students.isEmpty) {
        return {'success': false, 'message': 'No valid student data found'};
      }

      // Upload to server
      final response = await _uploadStudents(students);
      return response;
    } catch (e) {
      return {'success': false, 'message': 'Error processing file: $e'};
    }
  }

  Map<String, dynamic>? _processRow(List<dynamic> row) {
    if (row.any((cell) => cell?.value == null)) return null;

    return {
      'fName': row[0]?.value.toString(),
      'lName': row[1]?.value.toString(),
      'email': row[2]?.value.toString(),
      'enrollNo': row[3]?.value.toString(),
      'year': row[4]?.value.toString(),
      'section': row[5]?.value.toString(),
      'fatherName': row[6]?.value.toString(),
      'motherName': row[7]?.value.toString(),
      'dob': row[8]?.value.toString(),
      'rollNo': row[9]?.value.toString(),
      'gender': row[10]?.value.toString(),
      'parentsContact': row[11]?.value.toString(),
      'password': row[12]?.value.toString(),
    };
  }

  Future<Map<String, dynamic>> _uploadStudents(List<Map<String, dynamic>> students) async {
    final token = await _getToken();
    if (token == null) {
      return {'success': false, 'message': 'No authentication token found'};
    }

    try {
      final response = await http.post(
        Uri.parse(bulkUploadUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'students': students}),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Successfully uploaded ${students.length} students'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to upload students: ${response.body}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error uploading students: $e'};
    }
  }

  Future<List<int>> generateTemplate() async {
    var excel = Excel.createExcel();
    var sheet = excel['Students'];

    // Add headers
    final headers = [
      'First Name',
      'Last Name',
      'Email',
      'Enrollment No',
      'Year',
      'Section',
      'Father Name',
      'Mother Name',
      'DOB',
      'Roll No',
      'Gender',
      'Parents Contact',
      'Password'
    ];

    // Add header row with fixed styling
    for (var i = 0; i < headers.length; i++) {
      var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]); // Wrap string in TextCellValue
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.blue100, // Create ExcelColor from hex
        horizontalAlign: HorizontalAlign.Center,
      );
    }

    // Auto-fit columns
    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnAutoFit(i);
    }

    // Add a sample row
    final sampleData = [
      'John',
      'Doe',
      'john.doe@example.com',
      '12345',
      '1',
      'A',
      'Father Name',
      'Mother Name',
      '01/01/2000',
      '1',
      'M',
      '1234567890',
      'password123'
    ];

    for (var i = 0; i < sampleData.length; i++) {
      var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1));
      cell.value = TextCellValue(sampleData[i]); // Wrap string in TextCellValue
      cell.cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Left,
      );
    }

    // Return encoded excel file
    final bytes = excel.encode();
    return bytes ?? [];
  }
}